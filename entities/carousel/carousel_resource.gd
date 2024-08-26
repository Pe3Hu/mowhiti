class_name CarouselResource extends Resource


var member: MemberResource:
	set = set_member
#var aspect: String:
	#set = set_aspect

var tween = null
var pace = null
var tick = null
var time = null
var counter = 0
var skip = false #true
var anchor = null
var temp = true

const action_size = Vector2(64, 64)
const visible_actions = 3


#func set_aspect(aspect_: String) -> CarouselResource:
	#aspect = aspect_
	#return self
	
func set_member(member_: MemberResource) -> CarouselResource:
	member = member_
	member.squad.carousels.append(self)
	return self
