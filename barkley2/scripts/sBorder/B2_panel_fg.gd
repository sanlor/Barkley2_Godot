extends Control
class_name B2_Border_Foreground

## This node is part of the translation of the Border() script.
# This one handles the actual rrandom borders that each panel gets.

const S_BORDER_CORNERS = 		preload("res://barkley2/resources/Border/sBorderCorners.tres")
const S_BORDER_LEFT_RIGHT = 	preload("res://barkley2/resources/Border/sBorderLeftRight.tres")
const S_BORDER_TOP_BOTTOM = 	preload("res://barkley2/resources/Border/sBorderTopBottom.tres")

var corner_sprite_size := Vector2(25,25)

var border_h_tile_size := Vector2(10,8)

var border_v_tile_size := Vector2(8,10)

var border_size : Vector2 = Vector2(50,50)

@export var disable_sides := false
@export var disable_bottom := false
@export var disable_corner := false

@onready var parent = get_parent()

func _ready():
	#border_size = parent.border_size
	pass

func set_panel_size(x, y):
	border_size = Vector2(x,y).round()
	#size = border_size
	queue_redraw()

func _draw():
	## Make weights
	## 8 = 1, 16 = 4, 24 = 4, 32 = 4, 48 = 1      - 14 total
	if border_size < corner_sprite_size * 2:
		push_error("Panel size too small.")
		return
	
	# This is the famous code that handles the random border thing. it was annoying to port this to Godot, but it works.
	# if you can, take a look at the original code, its very clever. So much work... so much passion just wasted. For me at least, its a tragedy.
	
	# The original code lacks comentaries about this, so here we go:
	# the spritesheet has a set of tiles, ranging from 8X8 to 8X48.
	# while loop gets a random witdh, see if it fits the avaiable space. If not, add an aditional 8x8 and quits the while loop.
	
	# I tried to add my own modification and improvements to the code, but it didnt work well, so I just copy/pasted code and it worked.
	
	randomize()
	if not disable_sides:
		## Horizontal
		var avaiable_left_v_space 		:= border_size.y - 48	# (corner_sprite_size.y * 2)	## h = wid - 48;
		var left_start_pos				:= 24	#corner_sprite_size.y							## xxx = 24;
		var left_piece_height 	: Array[int] = [8,16,16,16,16,24,24,24,24,32,32,32,32,48]
		
		while avaiable_left_v_space > 0: ######################### LEFT
			if avaiable_left_v_space <= 8:
				var v_corner_left : AtlasTexture = 				S_BORDER_LEFT_RIGHT.duplicate()
				v_corner_left.region.size =						border_h_tile_size
				v_corner_left.region.position = 				Vector2.ZERO
				draw_texture( v_corner_left, Vector2( 0, 		left_start_pos						), Color.WHITE )
				break
			else:
				var r := randi_range(0,13) 			# iii = floor(random(14));
				var height := left_piece_height[ r ] 	# siz = global.borderSize[iii];
				if avaiable_left_v_space - height >= 0:
					var v_corner_left : AtlasTexture = 			S_BORDER_LEFT_RIGHT.duplicate()
					v_corner_left.region.size =					Vector2( border_h_tile_size.x,		height)
					v_corner_left.region.position = 			Vector2( r * border_h_tile_size.x, 	0)
					draw_texture( v_corner_left, Vector2( 0, 	left_start_pos						), Color.WHITE )
					
					avaiable_left_v_space 	-= height
					left_start_pos 			+= height
					
		var avaiable_right_v_space 		:= border_size.y - 48 # (corner_sprite_size.y * 2)	## h = wid - 48;
		var right_start_pos				:= 24 # corner_sprite_size.y							## xxx = 24;
		var right_piece_height 	: Array[int] = [8,16,16,16,16,24,24,24,24,32,32,32,32,48]
		
		while avaiable_right_v_space > 0: ######################### RIGHT
			if avaiable_right_v_space <= 8:
				var v_corner_right : AtlasTexture = 				S_BORDER_LEFT_RIGHT.duplicate()
				v_corner_right.region.size =						border_h_tile_size
				v_corner_right.region.position = 					Vector2(140, 0)
				draw_texture( v_corner_right, Vector2( border_size.x - border_h_tile_size.x, 			right_start_pos), Color.WHITE )
				break
			else:
				var r := randi_range(0,13) 			# iii = floor(random(14));
				var height := right_piece_height[ r ] 	# siz = global.borderSize[iii];
				if avaiable_right_v_space - height >= 0:
					var v_corner_right : AtlasTexture = 			S_BORDER_LEFT_RIGHT.duplicate()
					v_corner_right.region.size =					Vector2( border_h_tile_size.x,		height)
					v_corner_right.region.position = 				Vector2( r * border_h_tile_size.x + 140, 	0) ## 140 is the offset for the right side of the tilemap
					draw_texture( v_corner_right, Vector2( border_size.x - border_h_tile_size.x, 		right_start_pos), Color.WHITE )
					
					avaiable_right_v_space 		-= height
					right_start_pos 			+= height
	
	if not disable_bottom:
		## Vertical
		var avaiable_top_v_space 		:= border_size.x - 48 # (corner_sprite_size.x * 2)	## h = wid - 48;
		var top_start_pos				:= 24 # corner_sprite_size.x						## xxx = 24;
		var top_piece_width 	: Array[int] = [8,16,16,16,16,24,24,24,24,32,32,32,32,48]
		
		while avaiable_top_v_space > 0: ######################### TOP
			if avaiable_top_v_space <= 8:
				var v_corner_top : AtlasTexture = 				S_BORDER_TOP_BOTTOM.duplicate()
				v_corner_top.region.size =						border_v_tile_size
				v_corner_top.region.position = 					Vector2.ZERO
				draw_texture( v_corner_top, Vector2( top_start_pos, 0), Color.WHITE )
				break
			else:
				var r := randi_range(0,13) 			# iii = floor(random(14));
				var width := top_piece_width[ r ] 	# siz = global.borderSize[iii];
				if avaiable_top_v_space - width >= 0:
					var v_corner_top : AtlasTexture = 			S_BORDER_TOP_BOTTOM.duplicate()
					v_corner_top.region.size =					Vector2(width, 			border_v_tile_size.y)
					v_corner_top.region.position = 				Vector2( r * 48, 		0)
					draw_texture( v_corner_top, Vector2( top_start_pos, 0), Color.WHITE )
					
					avaiable_top_v_space 	-= width
					top_start_pos 			+= width
		
		var avaiable_bottom_v_space 			:= border_size.x - 48 # (corner_sprite_size.x * 2) 	## h = wid - 48;
		var bottom_start_pos					:= 24 # corner_sprite_size.x						## xxx = 24;
		var bottom_piece_width	: Array[int] = [8, 16,16,16,16, 24,24,24,24, 32,32,32,32, 48]
		
		while avaiable_bottom_v_space > 0: ######################### BOTTOM
			if avaiable_bottom_v_space <= 8:
				var v_corner_bottom : AtlasTexture = 		S_BORDER_TOP_BOTTOM.duplicate()
				v_corner_bottom.region.size =				border_v_tile_size
				v_corner_bottom.region.position = 			Vector2(0, border_v_tile_size.y)
				draw_texture( v_corner_bottom, Vector2( bottom_start_pos, border_size.y - border_v_tile_size.y), Color.WHITE ) ## The plus 1 is used on the original code
				break
			else:
				var r := randi_range(0,13) 				# iii = floor(random(14));
				var width := bottom_piece_width[ r ] 	# siz = global.borderSize[iii];
				if avaiable_bottom_v_space - width >= 0:
					var v_corner_bottom : AtlasTexture = 			S_BORDER_TOP_BOTTOM.duplicate()
					v_corner_bottom.region.size =					Vector2(width, 		border_v_tile_size.y)
					v_corner_bottom.region.position = 				Vector2( r * 48, 	border_v_tile_size.y)
					draw_texture( v_corner_bottom, Vector2( bottom_start_pos, border_size.y - border_v_tile_size.y ), Color.WHITE ) ## The plus 1 is used on the original code
					
					avaiable_bottom_v_space 	-= width
					bottom_start_pos 			+= width
			
	if not disable_corner:
		## Corners
		var corner_top_left : AtlasTexture = 			S_BORDER_CORNERS.duplicate()
		corner_top_left.region.position 		+= Vector2( randi_range(0,3), 0 ) * corner_sprite_size
		var corner_top_right : AtlasTexture = 			S_BORDER_CORNERS.duplicate()
		corner_top_right.region.position 		+= Vector2( randi_range(0,3) + 12, 0 ) * corner_sprite_size
		var corner_bottom_left : AtlasTexture = 		S_BORDER_CORNERS.duplicate()
		corner_bottom_left.region.position 		+= Vector2( randi_range(0,3) + 4, 0 ) * corner_sprite_size
		var corner_bottom_right : AtlasTexture = 		S_BORDER_CORNERS.duplicate()
		corner_bottom_right.region.position 	+= Vector2( randi_range(0,3) + 8, 0 ) * corner_sprite_size
		
		var transp := 1.0#0.25
		draw_texture( corner_top_left, 		Vector2.ZERO, 												Color(Color.WHITE, transp))
		draw_texture( corner_top_right, 	Vector2(border_size.x - corner_sprite_size.x, 0) , 			Color(Color.WHITE, transp))
		draw_texture( corner_bottom_left, 	Vector2(0, border_size.y - corner_sprite_size.y), 			Color(Color.WHITE, transp))
		draw_texture( corner_bottom_right, 	border_size - corner_sprite_size, 							Color(Color.WHITE, transp))
