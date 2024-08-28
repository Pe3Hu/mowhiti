class_name Squad extends PanelContainer


@export var dungeon: PanelContainer:
	set = set_dungeon
@export var carousels: HBoxContainer
@export var tactic: Tactic

@onready var carousel_scene = preload("res://entities/carousel/carousel.tscn")
@onready var emblem_scene = preload("res://entities/emblem/emblem.tscn")

var resource: SquadResource:
	set = set_resource


func set_dungeon(dungeon_: Dungeon) -> Squad:
	dungeon = dungeon_
	return self
	
func set_resource(resource_: SquadResource) -> Squad:
	resource = resource_
	return self
	
func _ready() -> void:
	pass
	
	for carousel_resource in resource.carousels:
		var carousel = carousel_scene.instantiate()
		carousel.set_resource(carousel_resource).set_squad(self)
	
	roll_carousels()
	
func roll_carousels() -> void:
	tactic.resource.fill_hand()
	
	for maneuver in tactic.maneuvers.get_children():
		if tactic.resource.hand_indexs.has(maneuver.resource.index):
			maneuver.visible = true
			
	resource.rolls = []
	
	for carousel in resource.carousels:
		resource.rolls.append(carousel)
	
	for carousel in carousels.get_children():
		carousel.roll()
	
func carousel_stopped(carousel_: PanelContainer) -> void:
	resource.rolls.erase(carousel_.resource)
	
	if resource.rolls.is_empty():
		tactic.update_maneuvers()
	
func update_result() -> void:
	resource.result = 0
	
	for carousel in carousels.get_children():
		resource.result += carousel.get_current_facet_value()
		#if result < carousel.get_current_facet_value():
		#	result = carousel.get_current_facet_value()
	
	#var data = {}
	#data.role = role
	#data.value = result
	#print(data)
