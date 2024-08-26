class_name ActionResource extends Resource


@export_enum("active", "inactive") var status: = "active"
@export_enum("bleeding", "suppression", "block", "blow", "prediction", "heal") var type = "bleeding":
	set = set_type
@export var value: int = 0:
	set = set_value

var member: MemberResource:
	set = set_member

func set_value(value_: int) -> ActionResource:
	if value != value_:
		value = value_
		emit_changed()
	return self
	
func set_type(type_: String) -> ActionResource:
	if type != type_:
		type = type_
		emit_changed()
	return self
	
func set_member(member_: MemberResource) -> ActionResource:
	member = member_
	member.active_actions.append(self)
	return self
	
func switch_status() -> void:
	var actions = member.get(status + "_actions")
	actions.erase(self)
	
	if status == "active":
		status = "inactive"
	else:
		status = "active"
	
	actions = member.get(status + "_actions")
	actions.append(self)
	
