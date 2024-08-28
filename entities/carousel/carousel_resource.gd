class_name CarouselResource extends Resource


var member: MemberResource:
	set = set_member
#var aspect: String:
	#set = set_aspect
var active_actions: Array[ActionResource]
var inactive_actions: Array[ActionResource]

var tween = null
var skip = false #true
var anchor = null
var repeats = 10
var spin_time = 0.40
var spin_gap = 0.25
var display_actions = 3
var repeat_actions = 0
var spin_order: int
var visible_actions: Array[ActionResource]

const action_size = Vector2(64, 64)


#func set_aspect(aspect_: String) -> CarouselResource:
	#aspect = aspect_
	#return self
	
func set_member(member_: MemberResource) -> CarouselResource:
	member = member_
	member.squad.carousels.append(self)
	active_actions.append_array(member.actions)
	return self
	
func roll_action() -> void:
	Global.rng.randomize()
	spin_order = Global.rng.randi_range(0, active_actions.size())
	visible_actions.clear()
	var shifts = [-1, 0, 1]
	
	for shift in shifts:
		var index = (spin_order + shift + active_actions.size() + 1) % active_actions.size()
		var action = active_actions[index]
		visible_actions.append(action)
