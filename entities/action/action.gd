class_name Action extends TextureRect


@export var label: Label
@export var resource: ActionResource:
	set = set_resource

var carousel: Carousel:
	set = set_carousel


func set_carousel(carousel_: Carousel) -> Action:
	carousel = carousel_
	carousel.actions.add_child(self)
	return self
	
func set_resource(resource_: ActionResource) -> Action:
	resource = resource_
	#resource_is_changed = resource.changed
	label.text = str(resource.value)
	material = load("res://entities/action/materials/" + resource.type + ".tres")
	texture = load("res://entities/action/images/" + resource.type + ".png")
	return self
