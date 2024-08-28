class_name ManeuverResource extends Resource


var tactic: TacticResource:
	set = set_tactic
var index: int:
	set = set_index
var orders: Array[int]
var actions: Array[ActionResource]
var types: Dictionary


func set_index(index_: int) -> ManeuverResource:
	index = index_
	orders.append_array(Global.dict.maneuver.index[index].orders)
	return self
	
func set_tactic(tactic_: TacticResource) -> ManeuverResource:
	tactic = tactic_
	tactic.maneuvers.append(self)
	tactic.deck_indexs.append(index)
	return self
	
func update_actions() -> void:
	types = {}
	
	for _i in orders.size():
		var carousel_resource = tactic.squad.carousels[_i]
		var order = orders[_i]
		var action = carousel_resource.visible_actions[order]
		
		if !types.has(action.type):
			types[action.type] = 0
		
		types[action.type] += action.value
	
	#for type in types:
	for type in Global.arr.action:
		if types.has(type):
			var action_resource = ActionResource.new()
			action_resource.set_type(type).set_value(types[type])
			actions.append(action_resource)
