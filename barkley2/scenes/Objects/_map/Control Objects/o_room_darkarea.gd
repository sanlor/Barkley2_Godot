extends CanvasModulate

const LIGHT_SPEED := 3.0

@onready var o_roundmound_bball_01: AnimatedSprite2D = $"../o_roundmound_bball01"
@onready var sprite_2d: Sprite2D = $Sprite2D

var ball_light 		: PointLight2D
var hoopz_light 	: PointLight2D

var t : Tween

func _ready() -> void:
	sprite_2d.hide()
	## Round mound cutscene.
	if o_roundmound_bball_01:
		ball_light = o_roundmound_bball_01.get_node("enviro_light")
	
## Full darkness
func execute_event_user_0():
	if t: t.kill()
	t = create_tween()
	t.tween_property( self, "color", Color( 0.0, 0.0, 0.0, 1.0 ), LIGHT_SPEED )
	print("Full darkness")
	
## Full lightness
func execute_event_user_1():
	if t: t.kill()
	t = create_tween()
	t.tween_property( self, "color", Color( 1.0, 1.0, 1.0, 1.0 ), LIGHT_SPEED )
	print("Full lightness")
	
## Roundmound Darkness
func execute_event_user_2():
	if t: t.kill()
	t = create_tween()
	t.tween_property( self, "color", Color( 0.25, 0.25, 0.25, 1.0 ), LIGHT_SPEED )
	print("Roundmound Darkness")
