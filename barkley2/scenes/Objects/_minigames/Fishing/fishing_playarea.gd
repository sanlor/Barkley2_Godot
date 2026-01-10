@tool
extends Node2D


@export_tool_button("Update play area bounds") var update : Callable = _update_area

@export var play_area := Rect2()

func _update_area() -> void:
	queue_redraw()
	
func _draw() -> void:
	if Engine.is_editor_hint():
		draw_rect( play_area, Color.RED, false )

func can_move( _pos : Vector2 ) -> bool:
	return play_area.has_point( _pos )
