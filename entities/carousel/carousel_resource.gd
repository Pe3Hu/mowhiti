class_name CarouselResource extends Resource


var member: MemberResource:
	set = set_member
#var aspect: String:
	#set = set_aspect

var tween = null
var skip = false #true
var anchor = null
var repeats = 10
var spin_time = 0.40
var spin_gap = 0.25
var visible_actions = 3
var actions = 0

const action_size = Vector2(64, 64)


#func set_aspect(aspect_: String) -> CarouselResource:
	#aspect = aspect_
	#return self
	
func set_member(member_: MemberResource) -> CarouselResource:
	member = member_
	member.squad.carousels.append(self)
	return self
