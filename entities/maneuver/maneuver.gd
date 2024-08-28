class_name Maneuver extends PanelContainer


@export var pattern: TextureRect
@export var actions: HBoxContainer

@onready var action_scene = preload("res://entities/action/action.tscn")

var tactic: Tactic:
	set = set_tactic
var resource: ManeuverResource:
	set = set_resource


func set_resource(resource_: ManeuverResource) -> Maneuver:
	resource = resource_
	return self
	
func set_tactic(tactic_: Tactic) -> Maneuver:
	tactic = tactic_
	pattern.material = ShaderMaterial.new()
	pattern.material.shader = load("res://shaders/maneuver pattern.gdshader")
	pattern.material.set("shader_parameter/index", resource.index) 
	tactic.maneuvers.add_child(self)
	return self

func update_actions() -> void:
	reset()
	
	for action_resource in resource.actions:
		var action = action_scene.instantiate()
		action.set_resource(action_resource).set_maneuver(self)
	
func reset() -> void:
	while actions.get_child_count() > 0:
		var action = actions.get_child(0)
		actions.remove_child(action)
		action.queue_free()
