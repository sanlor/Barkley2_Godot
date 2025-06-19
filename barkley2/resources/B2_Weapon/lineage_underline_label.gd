@tool
extends Label

func _ready() -> void:
	#size.x = 0
	pass

func _draw() -> void:
	draw_line( Vector2(-1, 	size.y + 3), Vector2(size.x + 1, 	size.y + 3), Color.BLACK, 3, false )
	draw_line( Vector2(0, 	size.y + 3), Vector2(size.x, 		size.y + 3), Color.WHITE )
