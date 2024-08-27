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
	
	#resource.time = Time.get_unix_time_from_system()
	#resource.anchor = Vector2(0, -resource.action_size.y)
	init_actions()
	#shuffle_actions()
	update_size()
	reset()
	#skip_animation()
	roll()
	return self
	
func set_resource(resource_: CarouselResource) -> Carousel:
	resource = resource_
	var emblem_resource = EmblemResource.new()
	emblem_resource.set_index(resource.member.emblem_index)
	emblem.set_resource(emblem_resource)
	return self
	
func init_actions() -> void:
	for _j in resource.repeats:
		for action_resource in resource.member.active_actions:
			var action = action_scene.instantiate()
			action.set_resource(action_resource).set_carousel(self)
	
	#var last_action = action_scene.instantiate()
	#last_action.set_resource(resource.member.active_actions.back()).set_carousel(self)
	
func update_size() -> void:
	#var vector = resource.action_size#Vector2(actions.get_child(0).size)
	#vector.y *= resource.window
	#custom_minimum_size = vector
	%BG.custom_minimum_size = Vector2(resource.action_size.x, resource.action_size.y * resource.visible_actions)
	
func roll() -> void:
	if !squad.resource.fixed:
		if resource.skip:
			#skip_animation()
			spin_end()
		else:
			declare_spin()
	
	reset()
	
func reset() -> void:
	resource.actions = resource.repeats * resource.member.active_actions.size()
	#shuffle_actions()
	actions.position.y = -(resource.actions - resource.visible_actions) * resource.action_size.y
	
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
	Global.rng.randomize()
	var action_order = Global.rng.randi_range(0, resource.member.active_actions.size())
	var spin_end_position = Vector2(0, -action_order * resource.action_size.y)
	resource.tween = create_tween()
	resource.tween.tween_property(actions, "position", spin_end_position, spin_time).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	#resource.tween.tween_property(actions, "position", spin_end_position, spin_time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	resource.tween.tween_callback(spin_end)
	
func spin_end():
	squad.carousel_stopped(self)
	
func crush() -> void:
	get_parent().remove_child(self)
	queue_free()
