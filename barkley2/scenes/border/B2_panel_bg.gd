@tool
extends Control
class_name B2_Border

## This node is part of the translation of the Border() script.
# This is the base class for most nodes that rely on the old Border() script
## NOTE I was forced to change some stuff. This is mostly original code.
## Some files (corners) needed to me modified.

const S_BORDER_BG_0 = preload("res://barkley2/assets/Border/sBorderBG_0.png")

@onready var b_2_panel_fg : B2_Border_Foreground# $B2_panel_fg

@export_category("DEBUG")
@export var disable_top_left_corner 		:= false
@export var disable_top_right_corner 		:= false
@export var disable_bottom_left_corner 		:= false
@export var disable_bottom_right_corner 	:= false
@export var disable_left_side 				:= false
@export var disable_right_side 				:= false
@export var disable_bottom_side 			:= false
@export var disable_upper_side 				:= false
#@export var disable_corner := false
#@export var disable_sides := false
#@export var disable_bottom := false
@export var disable_bg := false

var is_first_draw := true

var decorations := []
var decorations_color := {}

var is_invisible := false

var bg_opacity := 0.65

@onready var my_seed := hash( randi() )

@export var resize := false:
	set(a):
		queue_redraw()
		
@export var border_size := Vector2(50,50) : 
	set(s):
		border_size = s
		queue_redraw()

@export_tool_button("Update Border") var update_border := _ready

func _init():
	b_2_panel_fg = B2_Border_Foreground.new()
	
	add_child(b_2_panel_fg)

func set_seed( _seed : String ):
	my_seed = hash(_seed)

func _ready():
	# Theme
	if not theme:
		theme = preload("res://barkley2/themes/dialogue.tres")
	
	# Material stuff
	# material = preload("res://barkley2/resources/Border/border_material.tres")
	
	## FG panel setup
	b_2_panel_fg.disable_top_left_corner 		= disable_top_left_corner
	b_2_panel_fg.disable_top_right_corner 		= disable_top_right_corner
	b_2_panel_fg.disable_bottom_left_corner 	= disable_bottom_left_corner
	b_2_panel_fg.disable_bottom_right_corner 	= disable_bottom_right_corner
	b_2_panel_fg.disable_left_side 				= disable_left_side
	b_2_panel_fg.disable_right_side 			= disable_right_side
	b_2_panel_fg.disable_bottom_side 			= disable_bottom_side
	b_2_panel_fg.disable_upper_side 			= disable_upper_side
	
	#size = border_size
	set_panel_size(border_size.x, border_size.y)
	#b_2_panel_fg.set_panel_size(border_size.x, border_size.y)
	if is_invisible:
		self_modulate.a = 0.0
		b_2_panel_fg.self_modulate.a = 0.0
	_post_ready()
	
func _post_ready() -> void:
	pass

# Decorations are children that this node can control, change color and such.
func add_decorations(node : Node, _is_centered := false, add_node := true ): ## TODO _is_centered <- In the end, i never TODIDIT...
	decorations.append(node)
	decorations_color[node] = node.modulate
	if add_node:
		add_child(node)
	move_child(b_2_panel_fg, -1)

# This replaces que Border("generate") argument
func set_panel_size(x, y):
	border_size = Vector2(x,y)
	size = border_size
	b_2_panel_fg.set_panel_size(border_size.x, border_size.y)
	queue_redraw()

func get_panel_size():
	return border_size

func _draw():
	## BG
	var bg_rect := Rect2( Vector2(4,4), border_size - Vector2(8,8) ) # Small offset to hide the BG
	if not disable_bg:
		draw_texture_rect( S_BORDER_BG_0, bg_rect, true, Color(1, 1, 1, bg_opacity), false )
	
	if is_first_draw: ## avoid updating the border decorations
		b_2_panel_fg.set_panel_size(border_size.x, border_size.y)
		is_first_draw = false
	
func _on_child_entered_tree(_node):
	b_2_panel_fg.queue_redraw()
