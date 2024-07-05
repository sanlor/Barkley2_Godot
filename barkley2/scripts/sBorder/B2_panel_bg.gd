@tool
extends Control
class_name B2_Border

## NOTE I was forced to change some stuff. This is mostly original code.
## Some files (corners) needed to me modified.

const S_BORDER_BG_0 = preload("res://barkley2/assets/Border/sBorderBG_0.png")

@onready var b_2_panel_fg : B2_Border_Foreground# $B2_panel_fg

@export_category("DEBUG")
@export var disable_corner := false
@export var disable_sides := false
@export var disable_bottom := false
@export var disable_bg := false

var is_first_draw := true

var decorations := []
var decoration_prev_colors : Array[Color] = []

@export var resize := false:
	set(a):
		queue_redraw()
		
@export var border_size := Vector2(50,50) : 
	set(s):
		border_size = s
		queue_redraw()

func _init():
	b_2_panel_fg = B2_Border_Foreground.new()
	add_child(b_2_panel_fg)

func _ready():
	size = border_size
	b_2_panel_fg.set_panel_size(border_size.x, border_size.y)

func add_decorations(node : Node, _is_centered := false): ## TODO _is_centered
	decorations.append(node)
	add_child(node)

func set_panel_size(x, y):
	border_size = Vector2(x,y)
	b_2_panel_fg.set_panel_size(border_size.x, border_size.y)
	size = border_size
	queue_redraw()

func get_panel_size():
	return border_size

func _draw():
	## BG
	var bg_rect := Rect2( Vector2(4,4), border_size - Vector2(8,8) ) # Small offset to hide the BG
	if not disable_bg:
		draw_texture_rect( S_BORDER_BG_0, bg_rect, true, Color(1, 1, 1, 0.5), false )
	
	if is_first_draw: ## avoid updating the border decorations
		b_2_panel_fg.queue_redraw()
		is_first_draw = false
	
