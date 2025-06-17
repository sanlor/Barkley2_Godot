@tool
extends Control
## Someone smarter than me would have used a shader or something like that.
# The Utility() script was responsible to create this screen. that script is 3000 lines long, full of math and 3 letters variables that change meaning in each section.

var flick := 0.25

func _ready() -> void:
	if B2_Screen.is_utility_open:
		if B2_Screen.utility_screen:
			B2_Screen.utility_screen.flickered.connect( flicker )

func flicker( _flick : float ) -> void:
	flick = _flick
	queue_redraw()
	
func _draw() -> void:
	draw_rect( Rect2(Vector2.ZERO, size), Color(Color.GREEN, flick), false, 1.0, false )
	draw_rect( Rect2(Vector2.ZERO, size), Color(Color.GREEN, flick * 0.25), false, 3.0, false )
