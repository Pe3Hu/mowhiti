class_name Carousel extends PanelContainer


@export var actions: VBoxContainer

@onready var action_scene = preload("res://entities/action/action.tscn")

var squad: Squad:
	set = set_squad
var resource: CarouselResource:
	set = set_resource


func set_squad(squad_: Squad) -> Carousel:
	squad = squad_
	squad.carousels.add_child(self)
	
	resource.time = Time.get_unix_time_from_system()
	resource.anchor = Vector2(0, -resource.action_size.y)
	init_actions()
	#shuffle_actions()
	update_size()
	reset()
	#skip_animation()
	return self
	
func set_resource(resource_: CarouselResource) -> Carousel:
	resource = resource_
	return self
	
func init_actions() -> void:
	for action_resource in resource.member.active_actions:
		var action = action_scene.instantiate()
		action.set_resource(action_resource).set_carousel(self)
	
func update_size() -> void:
	#var vector = resource.action_size#Vector2(actions.get_child(0).size)
	#vector.y *= resource.window
	#custom_minimum_size = vector
	%BG.custom_minimum_size = Vector2(resource.action_size.x, resource.action_size.y * resource.visible_actions)
	
func roll() -> void:
	if !squad.fixed:
		if resource.skip:
			skip_animation()
			squad.carousel_stopped(self)
		else:
			%Timer.start()
	
	reset()
	
func reset() -> void:
	#shuffle_actions()
	resource.pace = 30
	resource.tick = 0
	actions.position.y = -resource.action_size.y * 1
	#var action = actions.get_child(faces-1)
	#var value = action.get_value()
	#flip_to_value(value)
	
func shuffle_actions() -> void:
	var temps = []
	
	for action in actions.get_children():
		actions.remove_child(action)
		temps.append(action)
	
	temps.shuffle()
	
	for action in temps:
		actions.add_child(action)
	
func decelerate_spin() -> void:
	resource.tick += 1
	var limit = {}
	limit.min = 0.01
	limit.max = max(limit.min, 10.0 - resource.tick * 0.15)
	#start 100 min 1.0 max 10.0 step 0.1 stop 10 = 2.2 sec
	Global.rng.randomize()
	var gap = Global.rng.randf_range(limit.min, limit.max)
	resource.pace -= gap
	var optimal = 0.1
	%Timer.wait_time = max(min(optimal, 1.0 / resource.pace), optimal)
	
func _on_timer_timeout():
	var _time = 1.0 / resource.pace
	
	if resource.pace >= 1.5:
		resource.tween = create_tween()
		resource.tween.tween_property(actions, "position", Vector2(0, 0), _time).from(resource.anchor)
		resource.tween.tween_callback(pop_up)
		decelerate_spin()
	else:
		#print("end at", Time.get_unix_time_from_system() - time)
		squad.carousel_stopped(self)
	
func pop_up() -> void:
	var action = actions.get_child(actions.get_child_count() - 1)
	actions.move_child(action, 0)
	
	if !resource.skip:
		actions.position = resource.anchor
		%Timer.start()
	
func skip_animation() -> void:
	var action = actions.get_children().pick_random()
	flip_to_value(action.get_value())
	
func flip_to_value(value_: int) -> void:
	for action in actions.get_children():
		if action.get_value() == value_:
			var index = action.get_index()
			var step = 1 - index
			
			if step < 0:
				step = actions.get_child_count() - index + 1
			
			for _j in step:
				pop_up()
			
			return
	
func get_current_action_value() -> int:
	var action = actions.get_child(1)
	return action.get_value()
	
func crush() -> void:
	get_parent().remove_child(self)
	queue_free()
