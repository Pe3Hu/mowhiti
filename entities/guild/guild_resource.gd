class_name GuildResource extends Resource


var planet: PlanetResource:
	set = set_planet
var members: Array[MemberResource]
var squads: Array[SquadResource]


func set_planet(planet_: PlanetResource) -> GuildResource:
	planet = planet_
	planet.guilds.append(self)
	init_members()
	return self
	
func init_members() -> void:
	var n = 1
	
	for aspect in Global.arr.aspect:
		for _i in n:
			var member = MemberResource.new()
			member.set_aspect(aspect).set_guild(self)
	
func add_squad(dungeon_: DungeonResource) -> void:
	var squad = SquadResource.new()
	squad.set_dungeon(dungeon_).set_guild(self)
