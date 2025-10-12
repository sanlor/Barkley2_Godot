extends Node2D

@onready var s_wst_rope_01: TextureRect = $clipper/s_wst_rope01
@onready var s_cts_hoopz_captured: AnimatedSprite2D = $clipper/s_cts_hoopzCaptured


# Make hoopz wiggle
func execute_event_user_0():
	s_cts_hoopz_captured.play("default")
	
# Drop into pot
func execute_event_user_1():
	var t = create_tween()
	t.set_parallel( true )
	t.tween_property( s_wst_rope_01, "size:y", 120, 3.0 ) 
	t.tween_property( s_cts_hoopz_captured, "offset:y", -20.0 + 120.0 - 40.0, 3.0 )
	#print("%s: dropping hoopz into the pot, but there is something wrong with the layers.")
	## Issue solved by adding "the clipper".
