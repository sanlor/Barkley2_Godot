@tool
extends Node
class_name B2_TOOL_GML_SPRITE_CONVERTER

# How to use this:
# create the Actor
# Add this node to the actor

## scr_entity_set_look_walk_mirror(standing_sprite, northeast_sprite, southeast_sprite);
# scr_entity_set_look_walk_mirror(s_zane01, s_zaneUP01, s_zaneDOWN01);
## scr_entity_look(object_looking, direction_cardinal)
# scr_entity_look(id, SOUTHEAST); //Can only call this function after scr_entity_set_look

## scr_entity_animation_define(animationName, sprite, startImage, numberOfFrames, animationSpeed)
# scr_entity_animation_define("default", s_zane01, 0, 1, 0);
# scr_entity_animation_define("lookdown", s_zane01, 1, 1, 0);
# scr_entity_animation_define("headshot", s_zaneHeadBlast01, 0, 14, ANIMATION_DEFAULT_SPEED);
# scr_entity_animation_define("deadOnGround", s_zaneHeadBlast01, 13, 1, ANIMATION_DEFAULT_SPEED);
@export var obj_folder_path 	:= "Y:/tmp/barkley_2/Barkley2.gmx/sprites"
@export var img_folder_path 	:= "res://barkley2/assets/b2_original/images/merged/"

@export var anim_node_name 	:= "ActorAnim" 	## Animation node name.
@export var create_col_node := true
@export var col_node_name 	:= "ActorCol" 	## Collision node name.

@export var animations 		: Array[B2_TOOL_GML_SPRITE_CONVERTER_ROOT]

@export var safety_check 		:= true			## Disallow the conversion if there is any issues.
@export var start_at_runtime 	:= false
@export var start_conversion 	:= false :		## Start the conversion process.
	set(b):
		lets_goooo()
		
var animatedsprite 		: AnimatedSprite2D
var spr_frames 			: SpriteFrames

var ANIMATION_STAND 		:= ""
var ANIMATION_SOUTH 		:= ""
var ANIMATION_SOUTHEAST 	:= ""
var ANIMATION_SOUTHWEST 	:= ""
var ANIMATION_WEST 			:= ""
var ANIMATION_NORTH 		:= ""
var ANIMATION_NORTHEAST 	:= ""
var ANIMATION_NORTHWEST 	:= ""
var ANIMATION_EAST 			:= ""

func _ready() -> void:
	if start_at_runtime and not Engine.is_editor_hint():
		lets_goooo()
	else:
		push_error( "B2_TOOL_GML_SPRITE_CONVERTER still exists on the %s node." % get_parent().name )
	
func run_safety_check() -> bool:
	if animations.is_empty():
		print("No animation convert. methods.")
		return false
	for c in get_parent().get_children():
		if c is AnimatedSprite2D:
			if c.name == anim_node_name:
				print("Animation already converted. Delete the node or release the safety.")
				return false
	
	return true
	
func lets_goooo():
	if safety_check:
		if not run_safety_check():
			print("Safety check failed.")
			return
	
	var lazy := false
	
	## Setup nodes and important resources
	var parent_name 		:= get_parent().name
	animatedsprite 		= AnimatedSprite2D.new()
	spr_frames 			= SpriteFrames.new()
	
	animatedsprite.name = anim_node_name
	
	# for each Converter resource set up.
	for anim in animations:
		if anim is B2_TOOL_GML_SPRITE_CONVERTER_ANIMATION_DEFINE:
			make_animated_sprite(anim)
				
		elif anim is B2_TOOL_GML_SPRITE_CONVERTER_SET_LOOK_WALK_MIRROR:
			# check scr_entity_set_walk_mirror()
			var standing := B2_TOOL_GML_SPRITE_CONVERTER_ANIMATION_DEFINE.new()
			standing.animationName 			= "default" #anim.standing_sprite
			standing.sprite					= anim.standing_sprite
			standing.startImage 			= 0
			standing.numberOfFrames 		= 999 ## 999 means all avaiable sprites
			standing.animationSpeed 		= 0
			make_animated_sprite( standing )
			ANIMATION_STAND = "default"
			
			var walk_north := B2_TOOL_GML_SPRITE_CONVERTER_ANIMATION_DEFINE.new()
			walk_north.animationName 		= anim.northeast_sprite
			walk_north.sprite				= anim.northeast_sprite
			walk_north.startImage 			= 0
			walk_north.numberOfFrames 		= 999 ## 999 means all avaiable sprites
			walk_north.animationSpeed 		= 0
			make_animated_sprite( walk_north )
			
			ANIMATION_NORTH 		= anim.northeast_sprite
			ANIMATION_NORTHEAST 	= anim.northeast_sprite
			ANIMATION_NORTHWEST		= anim.northeast_sprite
			
			var walk_south := B2_TOOL_GML_SPRITE_CONVERTER_ANIMATION_DEFINE.new()
			walk_south.animationName 		= anim.southeast_sprite
			walk_south.sprite				= anim.southeast_sprite
			walk_south.startImage 			= 0
			walk_south.numberOfFrames 		= 999 ## 999 means all avaiable sprites
			walk_south.animationSpeed 		= 0
			make_animated_sprite( walk_south )
			
			ANIMATION_EAST 				= anim.southeast_sprite
			ANIMATION_SOUTHEAST 		= anim.southeast_sprite
			ANIMATION_SOUTH 			= anim.southeast_sprite
			ANIMATION_SOUTHWEST			= anim.southeast_sprite
			ANIMATION_WEST				= anim.southeast_sprite
			
			print_data_for_lazy_devs()
				
		elif anim is B2_TOOL_GML_SPRITE_CONVERTER_SET_WALK:
			pass
		else:
			print("Unknow class %s." % anim.get_class())
			pass
				
	add_sibling.call_deferred( animatedsprite, true )
	animatedsprite.set_owner.call_deferred( get_parent() )
	
	var sprite_data := animatedsprite.get_meta( "default" ) as Dictionary
	animatedsprite.centered = false
	animatedsprite.offset = -Vector2( int( sprite_data["xorig"] ), int( sprite_data["yorigin"] ) )
	
	if create_col_node:
		set_placeholder_collision()
	print("Conversion finished!")
	pass
	
func print_data_for_lazy_devs():
	print("\n")
	print_rich("[color=Green] Cheat sheet :p  - paste this to the parent´s script[/color]")
	print( "func _ready() -> void:")
	print( "	ANIMATION_STAND 		:= ", ANIMATION_STAND)
	print( "	ANIMATION_SOUTH 		:= ",ANIMATION_SOUTH)
	print( "	ANIMATION_SOUTHEAST 	:= ",ANIMATION_SOUTHEAST)
	print( "	ANIMATION_SOUTHWEST 	:= ",ANIMATION_SOUTHWEST)
	print( "	ANIMATION_WEST 			:= ",ANIMATION_WEST)
	print( "	ANIMATION_NORTH 		:= ",ANIMATION_NORTH)
	print( "	ANIMATION_NORTHEAST 	:= ",ANIMATION_NORTHEAST)
	print( "	ANIMATION_NORTHWEST 	:= ",ANIMATION_NORTHWEST)
	print( "	ANIMATION_EAST 			:= ",ANIMATION_EAST)
	print( "	ActorAnim.animation 	= ",ANIMATION_STAND)
	print("\n")

	
func make_animated_sprite(anim : B2_TOOL_GML_SPRITE_CONVERTER_ANIMATION_DEFINE, ):
	assert(anim.animationName != ""	, "Name is Empty")
	assert(anim.sprite != ""		, "Sprite is Empty")
	
	var sprite_data 	:= parse_gmx( anim.sprite )
	var curr_frame 		:= anim.startImage as int
	var max_frames 		:= sprite_data["frames"].size() as int
	
	var _path = img_folder_path + "/" + anim.sprite + ".png"
	assert( FileAccess.file_exists(_path), "File doesnt exist. it really should." )
	var texture 	: Texture2D = ResourceLoader.load(_path, "Texture2D")
	
	spr_frames.add_animation(anim.animationName)
	
	var img_x 		:= sprite_data["width"] 	as int
	var img_y 		:= sprite_data["height"] 	as int
	
	# this is done because I had to merge the multiple individual sprites into one large one.
	# Use atlas to get the individual frames.
	for i in min(anim.numberOfFrames, max_frames): ## min is to handle the "999".
		var offset 		:= curr_frame

		var atlas 	:= AtlasTexture.new()
		var region 	:= Rect2( 
			Vector2( img_x * offset, 			0), 
			Vector2( img_x, 					img_y)
			)
		atlas.atlas 	= texture
		atlas.region 	= region
			
		spr_frames.add_frame( anim.animationName, atlas )
		
		# Handle wrap around (like, anim has 10 frames, start at 9 and the range is 5. it should go 9, 0, 1, 2, 3, 4).
		curr_frame = wrapi(curr_frame + 1, 0, max_frames)
	
	animatedsprite.sprite_frames = spr_frames
	
	## Very important. holds original data for the sprite. has important data related to sprite offset and collision mask.
	## Except for the sprite frames. fuck that.
	sprite_data.erase("frames")
	animatedsprite.set_meta(anim.animationName, sprite_data)
	pass
	
func parse_gmx(filename : String) -> Dictionary:
	var has_file := false
	for file : String in DirAccess.get_files_at(obj_folder_path):
		if file.trim_suffix(".sprite.gmx"):
			has_file = true
	if not has_file:
		print("There is no sprite called 'filename'")
		return Dictionary()
	else:
		var parser := XMLParser.new()
		var error = parser.open( obj_folder_path + "/" + filename + ".sprite.gmx" )
		if error != OK:
			print( error, " - Couldnt parse the file ", obj_folder_path + "/" + filename + ".sprite.gmx" )
			return Dictionary()
			
		var write_text_to := ""
		var write_to_array := false
		var sprite_data := {}
		var frame_array := []
		
		sprite_data["name"] = filename.trim_suffix(".sprite.gmx")
		
		while parser.read() != ERR_FILE_EOF:
			if parser.get_node_type() == XMLParser.NODE_ELEMENT:
				var node_name = parser.get_node_name()
				
				# X offset and  Y offset
				if node_name == "xorig" or node_name == "yorigin":
					sprite_data[node_name] = null
					write_text_to = node_name
					
				# the size of the sprite reported by the sprite
				if node_name == "width" or node_name == "height":
					sprite_data[node_name] = null
					write_text_to = node_name
				
				# Colision data # NOTE WTF is this info inside the sprite?
				if node_name == "bbox_left" or node_name == "bbox_right" or \
					node_name == "bbox_top" or node_name == "bbox_bottom":
						
					sprite_data[node_name] = null
					write_text_to = node_name
				
				# Frame is the sprite frames
				elif node_name == "frame":
					write_to_array = true
					
			if parser.get_node_type() == XMLParser.NODE_TEXT:
				if not write_text_to.is_empty():
					sprite_data[write_text_to]  = parser.get_node_data()
					write_text_to = ""
				if write_to_array:
					frame_array.append( parser.get_node_data() )
					write_to_array = false
						
		sprite_data["frames"] = frame_array
		print("Parse Successful for %s. " % filename)
		return sprite_data
	
#func get_sprite_frames( animationName : String, sprite_data : Dictionary ) -> SpriteFrames:
	#var spr_frames 			:= SpriteFrames.new()
			#
	#for frame : String in sprite_data["frames"]:
		#var t_frame = frame.trim_prefix("images\\")
		#var frame_suffix := t_frame.right(4) # get the last 4 characters. thats the file suffix (.png)
		#t_frame = t_frame.trim_suffix( frame_suffix )
		#
		#var split_frame := t_frame.rsplit("_", false, 1)
		## split_frame[0] is the file name
		## split_frame[1] is its offset
		#var _path = img_folder_path + "\\" + split_frame[0] + frame_suffix
		#
		#if not FileAccess.file_exists(_path):
			#push_error("File %s not found." % _path)
			#continue
		#
		## https://forum.godotengine.org/t/how-to-add-frames-from-a-sprite-sheet-in-code/5230/2
		## WARNING this is bullshit.
		#var texture 	: Texture2D = ResourceLoader.load(_path, "Texture2D")
		#var offset 		:= float( split_frame[1] )
		#var img_x 		:= sprite_data["width"] 	as int
		#var img_y 		:= sprite_data["height"] 	as int
		#
		#var atlas := AtlasTexture.new()
		#atlas.atlas = texture
		#atlas.region = Rect2( 
			#Vector2( img_x * offset, 			0), 
			#Vector2( img_x, 					img_y)
			#)
			#
		#if not spr_frames.has_animation(animationName):
			#spr_frames.add_animation(animationName)
			#
		#spr_frames.add_frame( animationName, atlas )
	#
	#return spr_frames
	
func set_placeholder_collision():
	## If there is a temp col already, skip it.
	var can_add := true
	for c in get_parent().get_children():
		if c is CollisionShape2D:
			if c.name == col_node_name:
				can_add = false
	if can_add:
		var col := CollisionShape2D.new()
		col.name = col_node_name
		
		add_sibling.call_deferred( col, true )
		col.set_owner.call_deferred( get_parent() )
