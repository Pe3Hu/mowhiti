class_name Dungeon extends PanelContainer


@export var squad: Squad

var planet: Planet:
	set = set_planet
var resource: DungeonResource:
	set = set_resource


func set_planet(planet_: Planet) -> Dungeon:
	planet = planet_
	resource.index = planet.dungeons.get_child_count()
	planet.dungeons.add_child(self)
	return self
	
func set_resource(resource_: DungeonResource) -> Dungeon:
	resource = resource_
	squad.resource = resource_.squad
	squad.dungeon = self
	return self
	
func prepare_carousels() -> void:
	#for role in Global.arr.role:
		#var carousels = 1
		#var god = challenge[role]
		#var challenger = challenge.get_challenger_based_on_god(god)
		#
		#if challenger.accuracy.subtype != "standard":
			#carousels += 1
		#
		#var faces = challenge[role].summary.aspect.get_value()
		#var squad = get(role+"Pool")
		#squad.init_carousels(carousels, faces)
	pass
	
func roll_carousels() -> void:
	squad.roll_carousels()
