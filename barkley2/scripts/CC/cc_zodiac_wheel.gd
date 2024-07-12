@tool
extends AnimatedSprite2D

@export var button_radius := 10.0 :
	set(_r):
		button_radius = _r
		queue_redraw()
@export var button_position := Vector2(150,0) :
	set(_p):
		button_position = _p
		queue_redraw()
@export var debug_color := Color.HOT_PINK

var is_pressed := false

func _ready():
	var hotspot := Button.new()
	hotspot.flat = true
	add_child( hotspot )
	hotspot.size = Vector2(button_radius,button_radius)
	hotspot.position = button_position
	
	queue_redraw()

func _button_hovering():
	if is_pressed:
		frame = 2
	else:
		frame = 1

func _draw():
	if Engine.is_editor_hint():
		draw_circle( button_position, button_radius, debug_color)
