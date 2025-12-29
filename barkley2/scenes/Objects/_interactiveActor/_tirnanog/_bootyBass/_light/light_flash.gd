extends PointLight2D
# check o_mg_booty_light
# Very modified. not all light effects were ported due to lazyness.

#const S_MG_BOOTY_LIGHT_ADORATION = preload("uid://xkgo3rdhxao1")	# 0 -> USE S_MG_BOOTY_LIGHT_ORBIT
const S_MG_BOOTY_LIGHT_CROSS = preload("uid://jc60v13mvdxh")		# 1
#const S_MG_BOOTY_LIGHT_FLASH = preload("uid://bhiv8jb0f83d6")		# 2 -> USE S_MG_BOOTY_LIGHT_ORBIT
#const S_MG_BOOTY_LIGHT_HYACINTH = preload("uid://cbxir0ywxx0q8")	# 3 -> USE S_MG_BOOTY_LIGHT_CROSS
const S_MG_BOOTY_LIGHT_ORBIT = preload("uid://dbftuwpbfafqm")		# 4
const S_MG_BOOTY_LIGHT_PATTERN = preload("uid://cm41i2j3hx0ho")		# 5
const S_MG_BOOTY_LIGHT_STAR = preload("uid://d0gfyslbtxce8")		# 6
const S_MG_BOOTY_LIGHT_TV = preload("uid://c00pjg2es687t")			# 7 -> USE S_MG_BOOTY_PATTERN
const S_MG_BOOTY_LIGHT_TV_2 = preload("uid://5j7x0f2ft00b")			# 8 -> USE S_MG_BOOTY_PATTERN



var type_0 := [ Color.from_rgba8(240, 10, 120, 255),	 	Color.from_rgba8(240, 210, 120, 255), ]
var type_1 := [ Color.from_rgba8(50, 200, 250, 255), 		Color.from_rgba8(10, 160, 240, 255), ]
var type_2 := [ Color.from_rgba8(250, 20, 25, 255), 		Color.from_rgba8(250, 10, 0, 255), ]
var type_3 := [ Color.from_rgba8(204, 0, 208, 255), 		Color.from_rgba8(60, 255, 10, 255), ]
var type_4 := [ Color.from_rgba8(0, 167, 168, 255),	 	Color.from_rgba8(20, 240, 80, 255), ]
var type_5 := [ Color.from_rgba8(117, 225, 100, 255), 	Color.from_rgba8(255, 20, 10, 255), ]
var type_6 := [ Color.from_rgba8(255, 113, 108, 255), 	Color.from_rgba8(50, 200, 10, 255), ]
var type_7 := [ Color.from_rgba8(255, 134, 255, 255), 	Color.from_rgba8(100, 255, 255, 255), ]
var type_8 := [ Color.from_rgba8(255, 255, 111, 255), 	Color.from_rgba8(255, 100, 100, 255), ]
var my_type := type_1

func _ready() -> void:
	var t := create_tween()
	energy = 0.0
	var expand := false
	var rotate_light := false
	if my_type == type_0:
		texture = S_MG_BOOTY_LIGHT_ORBIT
		expand = true
	elif my_type == type_1:
		texture = S_MG_BOOTY_LIGHT_CROSS
		rotate_light = true
	elif my_type == type_2:
		texture = S_MG_BOOTY_LIGHT_ORBIT
		expand = true
	elif my_type == type_3:
		texture = S_MG_BOOTY_LIGHT_CROSS
		rotate_light = true
		expand = true
	elif my_type == type_4:
		texture = S_MG_BOOTY_LIGHT_ORBIT
		rotate_light = true
		expand = true
	elif my_type == type_5:
		texture = S_MG_BOOTY_LIGHT_PATTERN
		rotate_light = true
		expand = true
	elif my_type == type_6:
		texture = S_MG_BOOTY_LIGHT_STAR
		rotate_light = true
		expand = true
	elif my_type == type_7:
		texture = S_MG_BOOTY_LIGHT_PATTERN
		rotate_light = true
	elif my_type == type_8:
		texture = S_MG_BOOTY_LIGHT_PATTERN
		expand = true
		
	t.tween_property(self, "energy", 1.0, 0.25).set_ease(Tween.EASE_OUT)
	t.parallel().tween_property(self, "color", my_type[0], 0.25).set_ease(Tween.EASE_OUT)
	if expand:
		t.parallel().tween_property(self, "scale", Vector2(1,1) * randf_range(0.5,2.0), 0.25).set_ease(Tween.EASE_OUT)
	if rotate_light:
		t.parallel().tween_property(self, "rotation", randf_range(-TAU,TAU), 1.00).set_ease(Tween.EASE_OUT)
	t.tween_property(self, "energy", 0.0, 0.50).set_ease(Tween.EASE_IN)
	t.parallel().tween_property(self, "color", my_type[1], 0.50).set_ease(Tween.EASE_IN)
	if expand:
		t.parallel().tween_property(self, "scale", Vector2.ZERO, 0.50).set_ease(Tween.EASE_IN)
	t.tween_callback( queue_free )

func set_type( type : int ) -> void:
	assert( type >= 0 and type <= 8, "Weird type value: %s" % type )
	if type == 0: my_type = type_0
	if type == 1: my_type = type_1
	if type == 2: my_type = type_2
	if type == 3: my_type = type_3
	if type == 4: my_type = type_4
	if type == 5: my_type = type_5
	if type == 6: my_type = type_6
	if type == 7: my_type = type_7
	if type == 8: my_type = type_8
