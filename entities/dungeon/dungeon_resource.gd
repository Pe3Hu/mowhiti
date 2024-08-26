class_name DungeonResource extends Resource


var planet: PlanetResource:
	set = set_planet
var squad: SquadResource:
	set = set_squad


func set_squad(squad_: SquadResource) -> DungeonResource:
	squad = squad_
	return self
	
func set_planet(planet_: PlanetResource) -> DungeonResource:
	planet = planet_
	planet.dungeons.append(self)
	return self
