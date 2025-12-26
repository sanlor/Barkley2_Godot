extends PointLight2D

var type_0 := [ Color.from_rgba8(240, 10, 120, 255), 	Color.from_rgba8(240, 210, 120, 255), ]
var type_1 := [ Color.from_rgba8(50, 200, 250, 255), 	Color.from_rgba8(10, 160, 240, 255), ]
var type_2 := [ Color.from_rgba8(250, 20, 25, 255), 	Color.from_rgba8(250, 10, 0, 255), ]
var my_type := type_1

func _ready() -> void:
	var t := create_tween()
	energy = 0.0
	t.tween_property(self, "energy", 1.0, 0.25).set_ease(Tween.EASE_OUT)
	t.parallel().tween_property(self, "color", my_type[0], 0.25).set_ease(Tween.EASE_OUT)
	t.tween_property(self, "energy", 0.0, 0.50).set_ease(Tween.EASE_IN)
	t.parallel().tween_property(self, "color", my_type[1], 0.50).set_ease(Tween.EASE_IN)
	t.tween_callback( queue_free )

func set_type( type : int ) -> void:
	assert( type == 0 or type == 1 or type == 2, "Weird type value: %s" % type )
	if type == 0: my_type = type_0
	if type == 1: my_type = type_1
	if type == 2: my_type = type_2
