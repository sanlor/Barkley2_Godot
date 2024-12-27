@tool
extends Node2D
class_name B2_PendingWork

# Node used to mark that there is some work pending on this node

const FN_1 = preload("res://barkley2/resources/fonts/fn1.tres")
const FN_2 = preload("res://barkley2/resources/fonts/fn2.tres")

@export var title := "Work Pending!":
	set(t):
		title = t
		queue_redraw()
@export var title_size := 16:
	set(s):
		title_size = s
		queue_redraw()
@export var title_color := Color.YELLOW :
	set(c):
		title_color = c
		queue_redraw()
@export_multiline var notes := "" :
	set(n):
		notes = n
		queue_redraw()
@export var text_size := 8:
	set(s):
		text_size = s
		queue_redraw()

func _ready() -> void:
	if not Engine.is_editor_hint():
		queue_free()
	z_index = 9999
	queue_redraw()

func _draw() -> void:
	draw_string(FN_1, Vector2(-32, -64 - 2), title, HORIZONTAL_ALIGNMENT_CENTER, 0, title_size, title_color)
	draw_string(FN_2, Vector2(-( notes.length() * ( text_size / 8 ) ), -64 + 16), notes, HORIZONTAL_ALIGNMENT_CENTER, 0, text_size, Color.WHITE)
