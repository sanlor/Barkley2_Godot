@tool
extends Node2D
class_name B2_PendingWork

# Node used to mark that there is some work pending on this node

const FN_1 = preload("res://barkley2/resources/fonts/fn1.tres")
const FN_2 = preload("res://barkley2/resources/fonts/fn2.tres")

@export_multiline var notes := "" :
	set(n):
		notes = n
		queue_redraw()

func _ready() -> void:
	if not Engine.is_editor_hint():
		queue_free()
	queue_redraw()

func _draw() -> void:
	draw_string(FN_1, Vector2(-32, -64 - 2), "Work Pending!", HORIZONTAL_ALIGNMENT_CENTER, 0, 16, Color.YELLOW)
	draw_string(FN_2, Vector2(-32, -64 + 16), notes, HORIZONTAL_ALIGNMENT_CENTER, 0, 8, Color.WHITE)
