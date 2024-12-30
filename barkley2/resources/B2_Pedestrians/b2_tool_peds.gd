extends Node

@export var spritesheet := "res://barkley2/assets/b2_original/images/merged/s_pedestrian_tnn01.png"
@export var folder := "res://barkley2/resources/B2_Pedestrians/"
@export var sprite_size := Vector2(28, 56)
var spr_x_offset := sprite_size.x
var spr_y_offset := sprite_size.y

func _ready() -> void:
	for row in 15:
		for collum in 2:
			# each set of sprites contains 12 sprites, 4 walking for each direction.
			var spr_name			:= "s_ped_" + str( (row + 1) * (collum + 1) ).pad_zeros(2)
			#var spr_name			:= "s_ped_" + str( 00 ).pad_zeros(2)
			var spr_atlas			:= AtlasTexture.new()
			var spr_frames 			:= SpriteFrames.new()
			
			spr_atlas.atlas = load(spritesheet)
			spr_atlas.region.size = sprite_size
			
			spr_frames.add_animation( "walk_N" )
			spr_atlas.region.position = Vector2( (0 * spr_x_offset) + (336 * collum), row * spr_y_offset ) 
			spr_frames.add_frame("walk_N", spr_atlas.duplicate(), 1.0, 0 )
			spr_atlas.region.position = Vector2( (1 * spr_x_offset) + (336 * collum), row * spr_y_offset ) 
			spr_frames.add_frame("walk_N", spr_atlas.duplicate(), 1.0, 1 )
			spr_atlas.region.position = Vector2( (2 * spr_x_offset) + (336 * collum), row * spr_y_offset ) 
			spr_frames.add_frame("walk_N", spr_atlas.duplicate(), 1.0, 2 )
			spr_atlas.region.position = Vector2( (3 * spr_x_offset) + (336 * collum), row * spr_y_offset ) 
			spr_frames.add_frame("walk_N", spr_atlas.duplicate(), 1.0, 3 )
			
			spr_frames.add_animation( "walk_S" )
			spr_atlas.region.position = Vector2( (4 * spr_x_offset) + (336 * collum), row * spr_y_offset ) 
			spr_frames.add_frame("walk_S", spr_atlas.duplicate(), 1.0, 0 )
			spr_atlas.region.position = Vector2( (5 * spr_x_offset) + (336 * collum), row * spr_y_offset ) 
			spr_frames.add_frame("walk_S", spr_atlas.duplicate(), 1.0, 1 )
			spr_atlas.region.position = Vector2( (6 * spr_x_offset) + (336 * collum), row * spr_y_offset ) 
			spr_frames.add_frame("walk_S", spr_atlas.duplicate(), 1.0, 2 )
			spr_atlas.region.position = Vector2( (7 * spr_x_offset) + (336 * collum), row * spr_y_offset ) 
			spr_frames.add_frame("walk_S", spr_atlas.duplicate(), 1.0, 3 )
			
			spr_frames.add_animation( "walk_sideways" )
			spr_atlas.region.position = Vector2( (8 * spr_x_offset) + (336 * collum), row * spr_y_offset ) 
			spr_frames.add_frame("walk_sideways", spr_atlas.duplicate(), 1.0, 0 )
			spr_atlas.region.position = Vector2( (9 * spr_x_offset) + (336 * collum), row * spr_y_offset ) 
			spr_frames.add_frame("walk_sideways", spr_atlas.duplicate(), 1.0, 1 )
			spr_atlas.region.position = Vector2( (10 * spr_x_offset) + (336 * collum), row * spr_y_offset ) 
			spr_frames.add_frame("walk_sideways", spr_atlas.duplicate(), 1.0, 2 )
			spr_atlas.region.position = Vector2( (11 * spr_x_offset) + (336 * collum), row * spr_y_offset ) 
			spr_frames.add_frame("walk_sideways", spr_atlas.duplicate(), 1.0, 3 )
			
			spr_frames.add_animation( "stand" )
			spr_atlas.region.position = Vector2( (0 * spr_x_offset) + (336 * collum), row * spr_y_offset ) 
			spr_frames.add_frame( "stand", spr_atlas.duplicate(), 1.0, 0 )
			spr_atlas.region.position = Vector2( (4 * spr_x_offset) + (336 * collum), row * spr_y_offset )
			spr_frames.add_frame( "stand", spr_atlas.duplicate(), 1.0, 1 )
			spr_atlas.region.position = Vector2( (8 * spr_x_offset) + (336 * collum), row * spr_y_offset )
			spr_frames.add_frame( "stand", spr_atlas.duplicate(), 1.0, 2 )
			
			ResourceSaver.save( spr_frames, folder + spr_name + ".tres" )
