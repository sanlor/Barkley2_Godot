@tool
@icon("res://barkley2/assets/b2_original/images/merged/s_cinema_marker_c.png")
extends Marker2D
class_name B2_CinemaSpot

@export var cinema_id := 0

var editor_font = preload("res://barkley2/assets/fonts/Perfect DOS VGA 437 Win.ttf")

func _enter_tree() -> void:
	add_to_group("cinema_spot")
	
func _draw() -> void:
	if Engine.is_editor_hint():
		z_index = 4000
		draw_string( editor_font, Vector2( -4 * str(cinema_id).length(), 4 ), str(cinema_id), HORIZONTAL_ALIGNMENT_CENTER, 0, 16, Color.HOT_PINK )
		draw_rect( Rect2( Vector2(-8, -8), Vector2(16, 16) ), Color.HOT_PINK, false, 1.5 )
		
	elif B2_Debug.ENABLE_CINEMASPOT: # used to check alignment
		draw_circle( Vector2.ZERO, 3.0, Color.HOT_PINK, true )
