@tool
extends Control

const S_BORDER_CORNERS = preload("res://barkley2/resources/Border/sBorderCorners.tres")
const S_BORDER_LEFT_RIGHT = preload("res://barkley2/resources/Border/sBorderLeftRight.tres")
const S_BORDER_TOP_BOTTOM = preload("res://barkley2/resources/Border/sBorderTopBottom.tres")

var corner_sprite_size := Vector2(25,25)

var border_h_tile_size := Vector2(10,8)
const border_h_tile_1 := 1
const border_h_tile_2 := 2
const border_h_tile_3 := 3
const border_h_tile_4 := 4
const border_h_tile_6 := 6

var border_v_tile_size := Vector2(8,10)
const border_v_tiles := [0,48,96,144,192,240,288,336,384,432,480,528,576,624] # This tileset has a weird offset
const border_v_tile_1 := 1
const border_v_tile_2 := 2
const border_v_tile_3 := 3
const border_v_tile_4 := 4
const border_v_tile_6 := 6

var border_size : Vector2

@onready var parent = get_parent()

func _ready():
	border_size = parent.border_size

func _draw():
	if not parent.disable_sides:
		## Horizontal
		var avaiable_h_space := border_size.y - (corner_sprite_size.y * 2)
		for i : int in int(avaiable_h_space / border_h_tile_size.y) + 1:
			var h_corner_left : AtlasTexture = 				S_BORDER_LEFT_RIGHT.duplicate()
			h_corner_left.region.position += 				Vector2( randi_range(0,0), 0 ) * border_h_tile_size ## WARNING randi_range(0,0) is TEMP
			var h_corner_right : AtlasTexture = 			S_BORDER_LEFT_RIGHT.duplicate()
			h_corner_right.region.position += 				Vector2( randi_range(0,0), 0 ) * border_h_tile_size ## WARNING randi_range(0,0) is TEMP
			draw_texture( h_corner_left, Vector2(0, (border_h_tile_size.y * i) + corner_sprite_size.y), Color.WHITE )
			draw_texture( h_corner_left, Vector2(border_size.x - border_h_tile_size.x, (border_h_tile_size.y * i) + corner_sprite_size.y), Color.WHITE )
	
	if not parent.disable_bottom:
		## Vertical
		var avaiable_v_space := border_size.x - (corner_sprite_size.x * 2)
		for i : int in int(avaiable_v_space / border_v_tile_size.x) + 1:
			var v_corner_left : AtlasTexture = 				S_BORDER_TOP_BOTTOM.duplicate()
			v_corner_left.region.position += 				Vector2( randi_range(0,0), 0 ) * border_v_tile_size ## WARNING randi_range(0,0) is TEMP
			var v_corner_right : AtlasTexture = 			S_BORDER_TOP_BOTTOM.duplicate()
			v_corner_right.region.position += 				Vector2( randi_range(0,0), 0 ) * border_v_tile_size ## WARNING randi_range(0,0) is TEMP
			
			draw_texture( v_corner_left, Vector2( (border_v_tile_size.x * i) + corner_sprite_size.x, 0), Color.WHITE )
			draw_texture( v_corner_left, Vector2( (border_v_tile_size.x * i) + corner_sprite_size.x, border_size.y - border_v_tile_size.y), Color.WHITE )
	
	if not parent.disable_corner:
		## Corners
		var corner_top_left : AtlasTexture = 			S_BORDER_CORNERS.duplicate()
		corner_top_left.region.position += Vector2( randi_range(0,3), 0 ) * corner_sprite_size
		var corner_top_right : AtlasTexture = 			S_BORDER_CORNERS.duplicate()
		corner_top_right.region.position += Vector2( randi_range(0,3), 3 ) * corner_sprite_size
		var corner_bottom_left : AtlasTexture = 		S_BORDER_CORNERS.duplicate()
		corner_bottom_left.region.position += Vector2( randi_range(0,3), 1 ) * corner_sprite_size
		var corner_bottom_right : AtlasTexture = 		S_BORDER_CORNERS.duplicate()
		corner_bottom_right.region.position += Vector2( randi_range(0,3), 2 ) * corner_sprite_size
		
		draw_texture( corner_top_left, Vector2.ZERO )
		draw_texture( corner_top_right, Vector2(border_size.x - corner_sprite_size.x, 0) )
		draw_texture( corner_bottom_left, Vector2(0, border_size.y - corner_sprite_size.y) )
		draw_texture( corner_bottom_right, border_size - corner_sprite_size)