class_name Carousel extends PanelContainer


@export var emblem: Emblem
@export var actions: VBoxContainer

@onready var action_scene = preload("res://entities/action/action.tscn")

var squad: Squad:
	set = set_squad
var resource: CarouselResource:
	set = set_resource


func set_squad(squad_: Squad) -> Carousel:
	squad = squad_
	squad.carousels.add_child(self)
	
	%BG.custom_minimum_size = Vector2(resource.action_size.x, resource.action_size.y * resource.display_actions)
	
	#resource.time = Time.get_unix_time_from_system()
	#resource.anchor = Vector2(0, -resource.action_size.y)
	init_actions()
	#shuffle_actions()
	reset()
	#skip_animation()
	return self
	
func set_resource(resource_: CarouselResource) -> Carousel:
	resource = resource_
	var emblem_resource = EmblemResource.new()
	emblem_resource.set_index(resource.member.emblem_index)
	emblem.set_resource(emblem_resource)
	return self
	
func init_actions() -> void:
	for _j in resource.repeats:
		for action_resource in resource.member.actions:
			var action = action_scene.instantiate()
			action.set_resource(action_resource).set_carousel(self)
	
func roll() -> void:
	if !squad.resource.fixed:
		if resource.skip:
			#skip_animation()
			spin_end()
		else:
			declare_spin()
	
	reset()
	
func reset() -> void:
	resource.repeat_actions = resource.repeats * resource.active_actions.size()
	#shuffle_actions()
	actions.position.y = -(resource.repeat_actions - resource.display_actions) * resource.action_size.y
	
func shuffle_actions() -> void:
	var temps = []
	
	for action in actions.get_children():
		actions.remove_child(action)
		temps.append(action)
	
	temps.shuffle()
	
	for action in temps:
		actions.add_child(action)
	
func declare_spin() -> void:
	Global.rng.randomize()
	var spin_time = resource.spin_time +  Global.rng.randf_range(-resource.spin_gap, resource.spin_gap)
	resource.roll_action()
	var spin_end_position = Vector2(0, -resource.spin_order * resource.action_size.y)
	resource.tween = create_tween()
	resource.tween.tween_property(actions, "position", spin_end_position, spin_time).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	resource.tween.tween_callback(spin_end)
	
func spin_end():
	squad.carousel_stopped(self)
	
func crush() -> void:
	get_parent().remove_child(self)
	queue_free()
