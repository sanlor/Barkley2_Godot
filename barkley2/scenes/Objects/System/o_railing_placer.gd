@tool
extends StaticBody2D
class_name B2_Railing_Placer

## Check Railing() and o_world ( event 0 )
# not easy to use, need to fiddle with exports to work correct.
# check the original oRailing0Placer scale. it uses that to setup the railings.

const S_RAILING_0 = preload("res://barkley2/assets/b2_original/images/merged/sRailing0.png")
const S_RAILING_1 = preload("res://barkley2/assets/b2_original/images/merged/sRailing1.png")

@export var rail_atlas : AtlasTexture
@export var col_color	:= Color("8080ff2d")
var my_col : CollisionShape2D

@export_enum("Horizontal", "Vertical") var orientation := 0 :
	set(o):
		orientation = o
		_update_railing()
		
@export var size := 5 :
	set(s):
		size = s
		_update_railing()

@export_category("Setup")
@export var start_offset_x 	:= 0.0 :
	set(a): 
		start_offset_x = snapped( a, Vector2(8.0,0.0) )
		_update_railing()
@export var start_offset_y 	:= -14.0 : 
	set(a): 
		start_offset_y = snapped( a, Vector2(0.0,25.0) )
		_update_railing()
@export var h_start_tile 	:= Vector2(72, 0) :
	set(a): 
		h_start_tile = snapped( a, Vector2(8.0,0.0) )
		_update_railing()
@export var h_end_tile 		:= Vector2(56, 0) :
	set(a): 
		h_end_tile = snapped( a, Vector2(8.0,0.0) )
		_update_railing()
@export var v_start_tile 	:= Vector2(48, 0):
	set(a): 
		v_start_tile = snapped( a, Vector2(8.0,0.0) )
		_update_railing()
@export var v_end_tile 		:= Vector2(64, 0):
	set(a): 
		v_end_tile = a
		_update_railing()

@export_category("Collision Setup")
@export var v_start_col_offset 		:= Vector2(4.0,2.5)
@export var v_end_col_offset 		:= Vector2(4.0,0.0)
@export var h_start_col_offset 		:= Vector2(-3.0,4.0)
@export var h_end_col_offset 		:= Vector2(-9.0,4.0)

var tile_size := Vector2(8,25)

@export_category("Run")
@export_tool_button("Update Railing") var update : Callable = _add_collision
		
func _init() -> void:
	add_to_group("navigation_polygon_source_geometry_group")
		
func _ready() -> void:
	_update_railing()
		
func _add_collision():
	if not is_instance_valid( my_col ):
		my_col = CollisionShape2D.new()
		add_child( my_col, true)
		my_col.z_index = 1000
	_update_collision_pos()

func _update_railing():
	_add_collision()
	queue_redraw()

func _update_collision_pos() -> void:
	var seg = SegmentShape2D.new()
	
	if orientation == 1:
		seg.a = Vector2.ZERO 			+ v_start_col_offset
		seg.b = Vector2(0, size * 8 ) 	+ v_end_col_offset
	if orientation == 0:
		seg.a = Vector2.ZERO 			+ h_start_col_offset
		seg.b = Vector2(size * 15, 0 ) 	+ h_end_col_offset
	
	if is_instance_valid( my_col ):
		my_col.shape = seg
		my_col.debug_color = col_color

func _draw() -> void:
	if orientation == 0:
		var offset 		:= start_offset_x
		var offset_y 	:= start_offset_y
		for i in size:
			var tile : AtlasTexture = rail_atlas.duplicate()
			
			if i == 0:
				tile.region.position = h_start_tile
				draw_texture( tile, Vector2(offset, offset_y) )
				offset += 8.0
			elif i == size - 1:
				tile.region.position = h_end_tile;
				draw_texture( tile, Vector2(offset, offset_y) )
				offset += 8.0
			else:
				tile.region.position = Vector2(0, 0);
				tile.region.size = Vector2(16, 25);
				draw_texture( tile, Vector2(offset, offset_y) )
				offset += 16.0
				
	if orientation == 1:
		var offset 		:= start_offset_x
		var offset_y 	:= start_offset_y
		for i in size:
			var tile : AtlasTexture = rail_atlas.duplicate()
			
			if i == 0:
				tile.region.position = v_start_tile
				draw_texture( tile, Vector2(offset, offset_y) )
				offset_y += 8.0
			elif i == size - 1:
				tile.region.position = v_end_tile;
				draw_texture( tile, Vector2(offset, offset_y) )
				offset_y += 8.0
			else:
				tile.region.position = Vector2(16, 0);
				#tile.region.size = Vector2(16, 25);
				draw_texture( tile, Vector2(offset, offset_y) )
				offset_y += 8.0
