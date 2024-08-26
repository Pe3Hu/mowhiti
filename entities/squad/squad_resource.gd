class_name SquadResource extends Resource


var dungeon: DungeonResource:
	set = set_dungeon
var guild: GuildResource:
	set = set_guild
var members: Array[MemberResource]
var carousels: Array[CarouselResource]
var result = null
var rolls = []
var fixed = false

const member_count = 3


func set_dungeon(dungeon_: DungeonResource) -> SquadResource:
	dungeon = dungeon_
	dungeon.squad = self
	return self
	
func set_guild(guild_: GuildResource) -> SquadResource:
	guild = guild_
	guild.squads.append(self)
	init_members()
	return self
	
func init_members() -> void:
	for _i in member_count:
		var member = guild.members.pick_random()
		add_member(member)
	
func add_member(member_: MemberResource) -> void:
	member_.squad = self
	members.append(member_)
	guild.members.erase(member_)
	var carousel = CarouselResource.new()
	carousel.set_member(member_)
	
	
func reset() -> void:
	fixed = false
	result = 0
	rolls = []
	
	#while carousels.get_child_count() > 0:
		#var carousel = carousels.get_child(0)
		#carousels.remove_child(carousel)
		#carousel.queue_free()
	
#func set_fixed_value(value_: int) -> void:
	#var carousel = carousels.get_child(0)
	#carousel.flip_to_value(value_)
