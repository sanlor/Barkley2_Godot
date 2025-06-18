@tool
extends Control
## Someone smarter than me would have used a shader or something like that.
# The Utility() script was responsible to create this screen. that script is 3000 lines long, full of math and 3 letters variables that change meaning in each section.

var intensity := 1.0
var flick := 0.25
var my_color := Color.GREEN

func _ready() -> void:
	if Engine.is_editor_hint(): ## avoid unecessary error messages
		return
		
	if B2_Screen.is_utility_open:
		if B2_Screen.utility_screen:
			B2_Screen.utility_screen.flickered.connect( flicker )
			B2_Screen.utility_screen.set_color.connect( _set_color )

func _set_color( _my_color : Color ) -> void:
	my_color = _my_color

func flicker( _flick : float ) -> void:
	flick = _flick
	queue_redraw()
	
func _draw() -> void:
	#draw_rect( Rect2(Vector2.ZERO, size), Color(my_color, flick * intensity * 0.125), true, -1.0, false )
	draw_rect( Rect2( Vector2.ZERO - Vector2.ONE * 1.0, size + Vector2.ONE * 2.0 ), Color(my_color, flick * intensity * 0.125), true, -1.0, false )
	draw_rect( Rect2( Vector2.ZERO, size), Color(my_color, flick * intensity * 0.5 ), false, 1.0, false )
	
	_after_draw()

func _after_draw() -> void:
	pass
