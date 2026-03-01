@tool
extends Control
class_name B2_Border_Foreground

## This node is part of the translation of the Border() script.
# This one handles the actual rrandom borders that each panel gets.

# Normal corners / edges
const S_BORDER_CORNERS 				:= preload("uid://dequiy8mu77u2")
const S_BORDER_LEFT_RIGHT 			:= preload("uid://dfcmdetivg7rl")
const S_BORDER_TOP_BOTTOM 			:= preload("uid://dux5axp1t4ca4")
const DYNAMIC_CORNER_SPRITE_SIZE 	:= Vector2(25,25)
const DYNAMIC_BORDER_H_TILE_SIZE 	:= Vector2(10,8)
const DYNAMIC_BORDER_V_TILE_SIZE 	:= Vector2(8,10)

# Static, different corners / edges
# Normal
const S_BORDER_CORNERS_STATIC 		:= preload("uid://byokb6crxxxbi")
const S_BORDER_EDGES_STATIC 		:= preload("uid://clq116vun41xa")
# VRW / O.O.
const S_BORDER_CORNERS_VRW 			:= preload("uid://ybqj1e6nf256")
const S_BORDER_EDGES_VRW 			:= preload("uid://040qgvjlhyri")
const STATIC_CORNER_SPRITE_SIZE 	:= Vector2(32,32)
const STATIC_BORDER_H_TILE_SIZE 	:= Vector2(16,16)
const STATIC_BORDER_V_TILE_SIZE 	:= Vector2(16,16)

var border_corners					:= S_BORDER_CORNERS
var border_top_bottom				:= S_BORDER_TOP_BOTTOM
var border_left_right				:= S_BORDER_LEFT_RIGHT
var corner_sprite_size 				:= DYNAMIC_CORNER_SPRITE_SIZE
var border_h_tile_size 				:= DYNAMIC_BORDER_H_TILE_SIZE
var border_v_tile_size 				:= DYNAMIC_BORDER_V_TILE_SIZE
var border_size 					: Vector2 = Vector2(50,50)

@export_category("Debug Stuff")
@export var disable_top_left_corner 		:= false
@export var disable_top_right_corner 		:= false
@export var disable_bottom_left_corner 		:= false
@export var disable_bottom_right_corner 	:= false
@export var disable_left_side 				:= false
@export var disable_right_side 				:= false
@export var disable_bottom_side 			:= false
@export var disable_upper_side 				:= false

@onready var parent : B2_Border = get_parent()

@onready var rng := RandomNumberGenerator.new()

var style 	: B2_CManager.DIAG_BOX
var my_seed := randi()

func _ready():
	# Theme
	theme 					= preload("res://barkley2/themes/dialogue.tres")
	z_index 				= 10
	
	# Weird behaviour!
	## https://www.reddit.com/r/godot/comments/15lpudk/can_you_configure_draw_to_still_draw_outside_the/
	custom_minimum_size 	= Vector2(3000,3000)
	mouse_filter 			= Control.MOUSE_FILTER_IGNORE
	use_parent_material 	= true
	_update_borders()
	
func set_panel_size(x, y):
	border_size = Vector2(x,y).round()
	queue_redraw()

func set_seed( _seed : int ):
	my_seed = _seed
	queue_redraw()

func _update_borders() -> void:
	## Set style
	if not Engine.is_editor_hint(): style = B2_CManager.curr_DIAG_BOX
	if parent.force_style:
		style = parent.forced_style
		
	match style:
		B2_CManager.DIAG_BOX.VRW:
			corner_sprite_size 	= STATIC_CORNER_SPRITE_SIZE
			border_h_tile_size 	= STATIC_BORDER_H_TILE_SIZE
			border_v_tile_size 	= STATIC_BORDER_V_TILE_SIZE
			border_left_right 	= S_BORDER_EDGES_VRW
			border_top_bottom 	= S_BORDER_EDGES_VRW
			border_corners 		= S_BORDER_CORNERS_VRW
		B2_CManager.DIAG_BOX.RETRO:
			corner_sprite_size 	= STATIC_CORNER_SPRITE_SIZE
			border_h_tile_size 	= STATIC_BORDER_H_TILE_SIZE
			border_v_tile_size 	= STATIC_BORDER_V_TILE_SIZE
			border_left_right 	= S_BORDER_EDGES_STATIC
			border_top_bottom 	= S_BORDER_EDGES_STATIC
			border_corners 		= S_BORDER_CORNERS_STATIC
		B2_CManager.DIAG_BOX.ALT:
			corner_sprite_size 	= STATIC_CORNER_SPRITE_SIZE
			border_h_tile_size 	= STATIC_BORDER_H_TILE_SIZE
			border_v_tile_size 	= STATIC_BORDER_V_TILE_SIZE
			border_left_right 	= S_BORDER_EDGES_STATIC
			border_top_bottom 	= S_BORDER_EDGES_STATIC
			border_corners 		= S_BORDER_CORNERS_STATIC
		B2_CManager.DIAG_BOX.NORMAL:
			corner_sprite_size 	= DYNAMIC_CORNER_SPRITE_SIZE
			border_h_tile_size 	= DYNAMIC_BORDER_H_TILE_SIZE
			border_v_tile_size 	= DYNAMIC_BORDER_V_TILE_SIZE
			border_left_right 	= S_BORDER_LEFT_RIGHT
			border_top_bottom 	= S_BORDER_TOP_BOTTOM
			border_corners 		= S_BORDER_CORNERS

	queue_redraw()
	
func _draw():
	## Make weights
	## 8 = 1, 16 = 4, 24 = 4, 32 = 4, 48 = 1      - 14 total
	if border_size < corner_sprite_size * 2:
		## NOTE Disabled 23-02
		#push_error("Panel size too small.")
		#return 
		pass
	
	# This is the famous code that handles the random border thing. it was annoying to port this to Godot, but it works.
	# if you can, take a look at the original code, its very clever. So much work... so much passion just wasted. For me at least, its a tragedy.
	
	# The original code lacks comentaries about this, so here we go:
	# the spritesheet has a set of tiles, ranging from 8X8 to 8X48.
	# while loop gets a random witdh, see if it fits the avaiable space. If not, add an aditional 8x8 and quits the while loop.
	
	# I tried to add my own modification and improvements to the code, but it didnt work well, so I just copy/pasted code and it worked.
	
	## Allow a predictable randomization.
	rng.seed = my_seed
	
	var start_pos := 24
	if style != B2_CManager.DIAG_BOX.NORMAL:
		start_pos = 8
	
	if not disable_left_side:
		## Horizontal
		var avaiable_left_v_space 		:= border_size.y - start_pos * 2	# (corner_sprite_size.y * 2)	## h = wid - 48;
		var left_start_pos				:= start_pos	#corner_sprite_size.y							## xxx = 24;
		var left_piece_height 			: Array[int] = [8,16,16,16,16,24,24,24,24,32,32,32,32,48]
		var failsafe 					:= 250
		
		while avaiable_left_v_space > 0: ######################### LEFT
			failsafe -= 1 ## Avoid cases where an infinite loop happens
			if failsafe < 0:
				push_error("Border LEFT is looping eternally!!!! %s fix this." % avaiable_left_v_space); break
			## Check if there are any small gap. if there is, add a small final tile.
			if avaiable_left_v_space <= 8:
				var v_edge_left : AtlasTexture = 			border_left_right.duplicate()
				if style != B2_CManager.DIAG_BOX.NORMAL:
					v_edge_left.region.size =				border_h_tile_size
					v_edge_left.region.position = 			Vector2( border_h_tile_size.x * 2, 		0)
				else:
					v_edge_left.region.size =				border_h_tile_size
					v_edge_left.region.position = 			Vector2.ZERO
				draw_texture( v_edge_left, Vector2( 0, 		left_start_pos						), Color.WHITE )
				avaiable_left_v_space = -INF
				break
			else: ## There is plenty os space, add a normal tile.
				var r := rng.randi_range(0,13) 			# iii = floor(random(14));
				if style != B2_CManager.DIAG_BOX.NORMAL: 	r = 1
				var height := left_piece_height[ r ] 	# siz = global.borderSize[iii];
				if avaiable_left_v_space - height >= 0 or style != B2_CManager.DIAG_BOX.NORMAL: ## Check if the selected tile can fit the avaiable space.
					var v_edge_left : AtlasTexture = 		border_left_right.duplicate()
					if style != B2_CManager.DIAG_BOX.NORMAL:
						v_edge_left.region.size =			border_h_tile_size
						v_edge_left.region.position = 		Vector2( border_h_tile_size.x * 2, 		0)
					else:
						v_edge_left.region.size =			Vector2( border_h_tile_size.x,		height)
						v_edge_left.region.position = 		Vector2( r * border_h_tile_size.x, 	0)
					draw_texture( v_edge_left, Vector2( 0, 	left_start_pos						), Color.WHITE )
					
					avaiable_left_v_space 	-= height
					left_start_pos 			+= height
					
	if not disable_right_side:
		var avaiable_right_v_space 		:= border_size.y - start_pos * 2 # (corner_sprite_size.y * 2)	## h = wid - 48;
		var right_start_pos				:= start_pos # corner_sprite_size.y							## xxx = 24;
		var right_piece_height 			: Array[int] = [8,16,16,16,16,24,24,24,24,32,32,32,32,48]
		var failsafe := 250
		
		while avaiable_right_v_space > 0: ######################### RIGHT
			failsafe -= 1
			if failsafe < 0:
				push_error("Border RIGHT is looping eternally!!!! %s fix this." % avaiable_right_v_space); break
			## Check if there are any small gap. if there is, add a small final tile.
			if avaiable_right_v_space <= 8:
				var v_edge_right : AtlasTexture = 				border_left_right.duplicate()
				if style != B2_CManager.DIAG_BOX.NORMAL:
					v_edge_right.region.size =					border_h_tile_size
					v_edge_right.region.position = 				Vector2( border_h_tile_size.x * 0, 		0)
				else:
					v_edge_right.region.size =					border_h_tile_size
					v_edge_right.region.position = 				Vector2(140, 0)
				draw_texture( v_edge_right, Vector2( border_size.x - border_h_tile_size.x, 			right_start_pos), Color.WHITE )
				avaiable_right_v_space = -INF
				break
			else: ## There is plenty os space, add a normal tile.
				var r := rng.randi_range(0,13) 			# iii = floor(random(14));
				if style != B2_CManager.DIAG_BOX.NORMAL: r = 1
				var height := right_piece_height[ r ] 	# siz = global.borderSize[iii];
				if avaiable_right_v_space - height >= 0 or style != B2_CManager.DIAG_BOX.NORMAL: ## Check if the selected tile can fit the avaiable space.
					var v_edge_right : AtlasTexture = 			border_left_right.duplicate()
					if style != B2_CManager.DIAG_BOX.NORMAL:
						v_edge_right.region.size =					border_h_tile_size
						v_edge_right.region.position = 				Vector2( border_h_tile_size.x * 0, 		0)
					else:
						v_edge_right.region.size =					Vector2( border_h_tile_size.x,		height)
						v_edge_right.region.position = 				Vector2( r * border_h_tile_size.x + 140, 	0) ## 140 is the offset for the right side of the tilemap
					draw_texture( v_edge_right, Vector2( border_size.x - border_h_tile_size.x, 		right_start_pos), Color.WHITE )
					
					avaiable_right_v_space 		-= height
					right_start_pos 			+= height
	
	if not disable_upper_side:
		## Vertical
		var avaiable_top_v_space 		:= border_size.x - start_pos * 2 # (corner_sprite_size.x * 2)	## h = wid - 48;
		var top_start_pos				:= start_pos # corner_sprite_size.x						## xxx = 24;
		var top_piece_width 			: Array[int] = [8,16,16,16,16,24,24,24,24,32,32,32,32,48]
		var failsafe := 250
		## Check if there are any small gap. if there is, add a small final tile.
		while avaiable_top_v_space > 0: ######################### TOP
			failsafe -= 1
			if failsafe < 0:
				push_error("Border TOP is looping eternally!!!! %s fix this." % avaiable_top_v_space); break
			if avaiable_top_v_space <= 8:
				var v_edge_top : AtlasTexture = 				border_top_bottom.duplicate()
				if style != B2_CManager.DIAG_BOX.NORMAL:
					v_edge_top.region.size =					border_v_tile_size
					v_edge_top.region.position = 				Vector2( border_h_tile_size.x * 1, 		0)
				else:
					v_edge_top.region.size =						border_v_tile_size
					v_edge_top.region.position = 					Vector2.ZERO
				draw_texture( v_edge_top, Vector2( top_start_pos, 0), Color.WHITE )
				avaiable_top_v_space = -INF
				break
			else: ## There is plenty os space, add a normal tile.
				var r := rng.randi_range(0,13) 			# iii = floor(random(14));
				if style != B2_CManager.DIAG_BOX.NORMAL: r = 1
				var width := top_piece_width[ r ] 	# siz = global.borderSize[iii];
				if avaiable_top_v_space - width >= 0 or style != B2_CManager.DIAG_BOX.NORMAL: ## Check if the selected tile can fit the avaiable space.
					var v_edge_top : AtlasTexture = 			border_top_bottom.duplicate()
					if style != B2_CManager.DIAG_BOX.NORMAL:
						v_edge_top.region.size =					border_v_tile_size
						v_edge_top.region.position = 				Vector2( border_h_tile_size.x * 1, 		0)
					else:
						v_edge_top.region.size =					Vector2(width, 			border_v_tile_size.y)
						v_edge_top.region.position = 				Vector2( r * 48, 		0)
					draw_texture( v_edge_top, Vector2( top_start_pos, 0), Color.WHITE )
					
					avaiable_top_v_space 	-= width
					top_start_pos 			+= width
	
	if not disable_bottom_side:
		var avaiable_bottom_v_space 			:= border_size.x - start_pos * 2 # (corner_sprite_size.x * 2) 	## h = wid - 48;
		var bottom_start_pos					:= start_pos # corner_sprite_size.x						## xxx = 24;
		var bottom_piece_width	: Array[int] = [8, 16,16,16,16, 24,24,24,24, 32,32,32,32, 48]
		var failsafe := 250
		## Check if there are any small gap. if there is, add a small final tile.
		while avaiable_bottom_v_space > 0: ######################### BOTTOM
			failsafe -= 1
			if failsafe < 0:
				push_error("Border BOTTOM is looping eternally!!!! %s fix this." % avaiable_bottom_v_space); break
			if avaiable_bottom_v_space <= 8:
				var v_edge_bottom : AtlasTexture = 		border_top_bottom.duplicate()
				if style != B2_CManager.DIAG_BOX.NORMAL:
					v_edge_bottom.region.size =					border_v_tile_size
					v_edge_bottom.region.position = 			Vector2( border_h_tile_size.x * 3, 		0)
				else:
					v_edge_bottom.region.size =					border_v_tile_size
					v_edge_bottom.region.position = 			Vector2(0, border_v_tile_size.y)
				draw_texture( v_edge_bottom, Vector2( bottom_start_pos, border_size.y - border_v_tile_size.y), Color.WHITE ) ## The plus 1 is used on the original code
				avaiable_bottom_v_space = -INF
				break
			else: ## There is plenty os space, add a normal tile.
				var r := rng.randi_range(0,13) 				# iii = floor(random(14));
				if style != B2_CManager.DIAG_BOX.NORMAL: r = 1
				var width := bottom_piece_width[ r ] 	# siz = global.borderSize[iii];
				if avaiable_bottom_v_space - width >= 0 or style != B2_CManager.DIAG_BOX.NORMAL: ## Check if the selected tile can fit the avaiable space.
					var v_corner_bottom : AtlasTexture = 			border_top_bottom.duplicate()
					if style != B2_CManager.DIAG_BOX.NORMAL:
						v_corner_bottom.region.size =				border_v_tile_size
						v_corner_bottom.region.position = 			Vector2( border_h_tile_size.x * 3, 		0)
					else:
						v_corner_bottom.region.size =				Vector2(width, 		border_v_tile_size.y)
						v_corner_bottom.region.position = 			Vector2( r * 48, 	border_v_tile_size.y)
					draw_texture( v_corner_bottom, Vector2( bottom_start_pos, border_size.y - border_v_tile_size.y ), Color.WHITE ) ## The plus 1 is used on the original code
					
					avaiable_bottom_v_space 	-= width
					bottom_start_pos 			+= width
	
	## Corners
	var transp := 1.0 # 0.25
	if not disable_top_left_corner:
		var corner_top_left : AtlasTexture = 			border_corners.duplicate()
		corner_top_left.region.position 		+= Vector2( rng.randi_range(0,3), 0 ) * corner_sprite_size
		if style != B2_CManager.DIAG_BOX.NORMAL:
			corner_top_left.region.position 		= Vector2( 1, 0 ) * corner_sprite_size
		draw_texture( corner_top_left, 		Vector2.ZERO, 												Color(Color.WHITE, transp))
		
	if not disable_top_right_corner:
		var corner_top_right : AtlasTexture = 			border_corners.duplicate()
		corner_top_right.region.position 		+= Vector2( rng.randi_range(0,3) + 12, 0 ) * corner_sprite_size
		if style != B2_CManager.DIAG_BOX.NORMAL:
			corner_top_right.region.position 		= Vector2( 0, 0 ) * corner_sprite_size
		draw_texture( corner_top_right, 	Vector2(border_size.x - corner_sprite_size.x, 0) , 			Color(Color.WHITE, transp))
		
	if not disable_bottom_left_corner:
		var corner_bottom_left : AtlasTexture = 		border_corners.duplicate()
		corner_bottom_left.region.position 		+= Vector2( rng.randi_range(0,3) + 4, 0 ) * corner_sprite_size
		if style != B2_CManager.DIAG_BOX.NORMAL:
			corner_bottom_left.region.position 		= Vector2( 2, 0 ) * corner_sprite_size
		draw_texture( corner_bottom_left, 	Vector2(0, border_size.y - corner_sprite_size.y), 			Color(Color.WHITE, transp))
		
	if not disable_bottom_right_corner:
		var corner_bottom_right : AtlasTexture = 		border_corners.duplicate()
		corner_bottom_right.region.position 	+= Vector2( rng.randi_range(0,3) + 8, 0 ) * corner_sprite_size
		if style != B2_CManager.DIAG_BOX.NORMAL:
			corner_bottom_right.region.position 	= Vector2( 3, 0 ) * corner_sprite_size
		draw_texture( corner_bottom_right, 	border_size - corner_sprite_size, 							Color(Color.WHITE, transp))
