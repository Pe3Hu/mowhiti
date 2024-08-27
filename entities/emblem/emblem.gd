class_name Emblem extends TextureRect


@export var label: Label
@export var resource: EmblemResource:
	set = set_resource
#
#var carousel: Carousel:
	#set = set_carousel
#
#
#func set_carousel(carousel_: Carousel) -> Emblem:
	#carousel = carousel_
	#carousel.actions.add_child(self)
	#return self
	
func set_resource(resource_: EmblemResource) -> Emblem:
	material = ShaderMaterial.new()
	material.shader = load("res://shaders/emblem pattern.gdshader")
	resource = resource_
	
	for property in resource.get_property_list():
		if property.name != "index" and property.usage == 4096:
			material.set("shader_parameter/" + property.name, resource.get(property.name))
	
	return self
