@tool
extends Control

## NOTE I was forced to change some stuff. This is mostly original code.
## Some files (corners) needed to me modified.

const S_BORDER_BG_0 = preload("res://barkley2/assets/Border/sBorderBG_0.png")

@onready var b_2_panel_fg = $B2_panel_fg


@export_category("DEBUG")
@export var disable_corner := false
@export var disable_sides := false
@export var disable_bottom := false
@export var disable_bg := false

@export var resize := false:
	set(a):
		queue_redraw()
		
@export var border_size := Vector2(50,50)

func set_panel_size(x, y):
	border_size = Vector2(x,y)
	queue_redraw()

func _draw():
	size = border_size
	
	if not disable_bg:
		## BG
		var bg_rect := Rect2( Vector2(2,2), border_size - Vector2(4,4) ) # Small offset to hide the BG
		draw_texture_rect( S_BORDER_BG_0, bg_rect, true, Color(1, 1, 1, 0.5), false )
	
	b_2_panel_fg.queue_redraw()
	
