class_name Member extends PanelContainer


var squad: Squad:
	set = set_squad
var resource: MemberResource:
	set = set_resource


func set_squad(squad_: Squad) -> Member:
	squad = squad_
	squad.members.add_child(self)
	return self
	
func set_resource(resource_: MemberResource) -> Member:
	resource = resource_
	return self
