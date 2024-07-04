@tool
extends Control
class_name B2_Border

signal button_pressed

## NOTE I was forced to change some stuff. This is mostly original code.
## Some files (corners) needed to me modified.

const S_BORDER_BG_0 = preload("res://barkley2/assets/Border/sBorderBG_0.png")
const S_1X_1 = preload("res://barkley2/assets/b2_original/images/s1x1.png")

@onready var b_2_panel_fg = $B2_panel_fg

@export_category("DEBUG")
@export var disable_corner := false
@export var disable_sides := false
@export var disable_bottom := false
@export var disable_bg := false

@export_category("Panel Setup")
@export var monitor_mouse := false
@export var change_children_color := true
@export var selected_color := Color.ORANGE

var is_first_draw := true
var is_highlighted := false

var decorations := []
var decoration_prev_colors : Array[Color] = []

@export var resize := false:
	set(a):
		queue_redraw()
		
@export var border_size := Vector2(50,50) : 
	set(s):
		border_size = s
		queue_redraw()

func _ready():
	size = border_size
	if monitor_mouse:
		mouse_entered.connect( func(): is_highlighted = true; queue_redraw() )
		mouse_exited.connect( func(): is_highlighted = false; queue_redraw() )

func add_decorations(node : Node, _is_centered := false): ## TODO _is_centered
	decorations.append(node)
	add_child(node)

func set_panel_size(x, y):
	border_size = Vector2(x,y)
	queue_redraw()

func _gui_input(event):
	if monitor_mouse:
		if event is InputEventMouseButton: ## Allow window to be pressed, if the mouse is being monitored.
			if event.is_action_pressed("Action"):
				button_pressed.emit()

func _draw():
	## BG
	var bg_rect := Rect2( Vector2(4,4), border_size - Vector2(8,8) ) # Small offset to hide the BG
	if not disable_bg:
		draw_texture_rect( S_BORDER_BG_0, bg_rect, true, Color(1, 1, 1, 0.5), false )
	if is_highlighted:
		draw_texture_rect( S_1X_1, bg_rect, true, Color(1, 1, 1, 0.25), false )
		
	if change_children_color:
		for n in decorations:
			if is_highlighted:
				n.modulate = selected_color
			else:
				n.modulate = Color.WHITE
	
	if is_first_draw: ## avoid updating the border decorations
		b_2_panel_fg.queue_redraw()
		is_first_draw = false
	
