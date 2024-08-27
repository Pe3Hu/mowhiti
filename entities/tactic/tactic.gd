class_name Tactic extends PanelContainer


@export var squad: Squad
@export var maneuvers: GridContainer#VBoxContainer

@onready var maneuver_scene = preload("res://entities/maneuver/maneuver.tscn")


func _ready() -> void:
	init_maneuvers()
	
func init_maneuvers() -> void:
	for type in Global.dict.maneuver.type:
		for index in Global.dict.maneuver.type[type]:
			var maneuver = maneuver_scene.instantiate()
			maneuver.pattern.material = ShaderMaterial.new()
			maneuver.pattern.material.shader = load("res://shaders/maneuver pattern.gdshader")
			maneuver.pattern.material.set("shader_parameter/index", index) 
			maneuvers.add_child(maneuver)
