class_name EmblemResource extends Resource


var index: int:
	set = set_index

var is_inverse: bool
var is_circle: bool
var is_perfect: bool

var offset: float
var zoom_scale: float
var radius_scale: float

var color: Color


func set_index(index_: int) -> EmblemResource:
	index = index_
	var description = Global.dict.emblem.index[index]
	
	for key in description:
		set(key, description[key])
	
	#var hue = Global.dict.hue[(floor(index / 9))] / 360.0
	var rand_hue =  Global.dict.hue.pick_random()
	var max_shift = 5
	Global.rng.randomize()
	var shift = Global.rng.randi_range(-max_shift, max_shift)
	var h = ((rand_hue + shift + 360) % 360) / 360.0
	var s = 0.6
	var v = 1
	
	if index > 8:
		s = 0.65
		var min_v = 0.3
		var max_v = 0.6
		
		if index < 18:
			max_v = 0.4
		
		Global.rng.randomize()
		v = Global.rng.randf_range(min_v, max_v)
	
	color = Color.from_hsv(h, s, v)
	return self
