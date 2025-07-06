@tool
extends Label

@export var y_offset := 0

func _ready() -> void:
	#size.x = 0
	pass

func _draw() -> void:
	draw_line( Vector2(-1, 	size.y + y_offset), Vector2(size.x + 1, 	size.y + y_offset), Color.BLACK, 3, false )
	draw_line( Vector2(0, 	size.y + y_offset), Vector2(size.x, 		size.y + y_offset), Color.WHITE, 1 )
