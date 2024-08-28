class_name MemberResource extends Resource


var guild: GuildResource:
	set = set_guild
var aspect: String:
	set = set_aspect
var actions: Array[ActionResource]
var squad: SquadResource
var emblem_index: int


func set_aspect(aspect_: String) -> MemberResource:
	aspect = aspect_
	return self
	
func set_guild(guild_: GuildResource) -> MemberResource:
	guild = guild_
	guild.members.append(self)
	init_actions()
	emblem_index = Global.arr.free_emblem.pop_back()
	return self
	
func init_actions() -> void:
	var n = 4
	
	for _i in n:
		var type = Global.arr.action.pick_random()
		var value = int(_i + 1)
		var action = ActionResource.new()
		action.set_type(type).set_value(value).set_member(self)
