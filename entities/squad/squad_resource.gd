class_name SquadResource extends Resource


var dungeon: DungeonResource:
	set = set_dungeon
var guild: GuildResource:
	set = set_guild
var members: Array[MemberResource]
var carousels: Array[CarouselResource]
var tactic: TacticResource
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
	
	tactic = TacticResource.new()
	tactic.squad = self
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
	rolls = []
