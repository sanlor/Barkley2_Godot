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
@export_category("Paths")
@export var obj_folder_path 	:= "Y:/tmp/barkley_2/Barkley2.gmx/sprites"
@export var img_folder_path 	:= "res://barkley2/assets/b2_original/images/merged/"

@export_category("Node stuff")
@export var anim_node_name 	:= "ActorAnim" 	## Animation node name.
@export var create_col_node := true
@export var col_node_name 	:= "ActorCol" 	## Collision node name.
@export var create_actor_interact := true
@export var int_node_name	:= "ActorInteract"
@export var int_node_shape	:= Vector2(20,36)
@export var update_anim_node := false ## Do not create a AnimatedSprite2D, just update an existing one.
@export var clear_previous_anim_from_existing_node := false ## clear all anims from the existing node.

@export_category("Tool Setup")
@export var animations 		: Array[B2_TOOL_GML_SPRITE_CONVERTER_ROOT]

@export_category("Run tool")
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

## Which sprite index is used for the standing animation.
var ANIMATION_STAND_SPRITE_INDEX 	:= [ 0, 0, 0, 0, 0, 0, 0, 0 ] # N, NE, E, SE, S, SW, W, NW

func _ready() -> void:
	if start_at_runtime and not Engine.is_editor_hint():
		lets_goooo()
	else:
		push_error( "B2_TOOL_GML_SPRITE_CONVERTER still exists on the %s node." % get_parent().name )
	
func run_safety_check() -> bool:
	if animations.is_empty():
		print("No animation convert. methods.")
		return false
	if update_anim_node:
		if not get_parent().has_node(anim_node_name):
			print("No node to update.")
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
	
	if update_anim_node:
		animatedsprite 		= get_parent().get_node(anim_node_name) as AnimatedSprite2D
		spr_frames 			= animatedsprite.sprite_frames
		if clear_previous_anim_from_existing_node:
			spr_frames.clear_all()
	else:
		animatedsprite 		= AnimatedSprite2D.new()
		spr_frames 			= SpriteFrames.new()
	
	animatedsprite.use_parent_material = true
	animatedsprite.name = anim_node_name
	
	# for each Converter resource set up.
	for anim in animations:
		if anim is B2_TOOL_GML_SPRITE_CONVERTER_SET_LOOK:
			var stand := B2_TOOL_GML_SPRITE_CONVERTER_ANIMATION_DEFINE.new()
			stand.animationName 		= anim.sprite
			stand.sprite				= anim.sprite
			stand.startImage 			= 0
			stand.numberOfFrames 		= 999 ## 999 means all avaiable sprites
			stand.animationSpeed 		= 0
			make_animated_sprite( stand )
			
			## scr_entity_set_look(sprite, N, NE, E, SE, S, SW, W, NW);
			ANIMATION_STAND = anim.sprite
			ANIMATION_STAND_SPRITE_INDEX = [anim.subN, anim.subNE, anim.subE, anim.subSE, anim.subS, anim.subSW, anim.subW, anim.subNW ]
		
		elif anim is B2_TOOL_GML_SPRITE_CONVERTER_ANIMATION_DEFINE:
			make_animated_sprite(anim)
				
		elif anim is B2_TOOL_GML_SPRITE_CONVERTER_SET_LOOK_WALK_MIRROR:
			# check scr_entity_set_look_walk_mirror()
			var standing := B2_TOOL_GML_SPRITE_CONVERTER_ANIMATION_DEFINE.new()
			standing.animationName 			= anim.standing_sprite # "default" #anim.standing_sprite
			standing.sprite					= anim.standing_sprite
			standing.startImage 			= 0
			standing.numberOfFrames 		= 999 ## 999 means all avaiable sprites
			standing.animationSpeed 		= 0
			make_animated_sprite( standing )
			ANIMATION_STAND = anim.standing_sprite # "default"
			
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
			
			ANIMATION_EAST 					= anim.southeast_sprite
			ANIMATION_SOUTHEAST 			= anim.southeast_sprite
			ANIMATION_SOUTH 				= anim.southeast_sprite
			ANIMATION_SOUTHWEST				= anim.southeast_sprite
			ANIMATION_WEST					= anim.southeast_sprite
			ANIMATION_STAND_SPRITE_INDEX 	= [ 1, 1, 0, 0, 0, 0, 0, 1 ]
			print_data_for_lazy_devs()
				
		elif anim is B2_TOOL_GML_SPRITE_CONVERTER_SET_WALK:
			# scr_entity_set_walk()
			var std : B2_TOOL_GML_SPRITE_CONVERTER_SET_LOOK = anim.animation_stand
			
			make_animated_sprite( make_anim_stand_define( "walk_S", 	0, anim.animation_south, 				999 ) )
			make_animated_sprite( make_anim_stand_define( "walk_SE", 	0, anim.animation_southeast , 			999 ) )
			make_animated_sprite( make_anim_stand_define( "walk_SW", 	0, anim.animation_southwest, 			999 ) )
			make_animated_sprite( make_anim_stand_define( "walk_W", 	0, anim.animation_west, 				999 ) )
			make_animated_sprite( make_anim_stand_define( "walk_N", 	0, anim.animation_north, 				999 ) )
			make_animated_sprite( make_anim_stand_define( "walk_NE", 	0, anim.animation_northeast, 			999 ) )
			make_animated_sprite( make_anim_stand_define( "walk_NW", 	0, anim.animation_northwest, 			999 ) )
			make_animated_sprite( make_anim_stand_define( "walk_E", 	0, anim.animation_east, 				999 ) )
			
			ANIMATION_NORTH 			= "walk_N" 		# anim.animation_north.animationName
			ANIMATION_NORTHEAST 		= "walk_NE" 	# anim.animation_northeast.animationName
			ANIMATION_NORTHWEST			= "walk_NW" 	# anim.animation_northwest.animationName
			ANIMATION_EAST 				= "walk_E" 		# anim.animation_east.animationName
			ANIMATION_SOUTHEAST 		= "walk_SE" 	# anim.animation_southeast.animationName
			ANIMATION_SOUTH 			= "walk_S" 		# anim.animation_south.animationName
			ANIMATION_SOUTHWEST			= "walk_SW" 	# anim.animation_southwest.animationName
			ANIMATION_WEST				= "walk_W" 		# anim.animation_west.animationName
			
			## scr_entity_set_look(sprite, N, NE, E, SE, S, SW, W, NW);
			ANIMATION_STAND = std.sprite
			ANIMATION_STAND_SPRITE_INDEX = [std.subN, std.subNE, std.subE, std.subSE, std.subS, std.subSW, std.subW, std.subNW ]
			make_animated_sprite( make_anim_stand_define( "stand_NE", 	std.subNE, 	std.sprite, 1 ) )
			make_animated_sprite( make_anim_stand_define( "stand_N", 	std.subN, 	std.sprite, 1 ) )
			make_animated_sprite( make_anim_stand_define( "stand_NW", 	std.subNW, 	std.sprite, 1 ) )
			make_animated_sprite( make_anim_stand_define( "stand_E", 	std.subE, 	std.sprite, 1 ) )
			make_animated_sprite( make_anim_stand_define( "stand_W", 	std.subW, 	std.sprite, 1 ) )
			make_animated_sprite( make_anim_stand_define( "stand_SE", 	std.subSE, 	std.sprite, 1 ) )
			make_animated_sprite( make_anim_stand_define( "stand_S", 	std.subS, 	std.sprite, 1 ) )
			make_animated_sprite( make_anim_stand_define( "stand_SW", 	std.subSW, 	std.sprite, 1 ) )
			
			print_data_for_lazy_devs()
		elif anim is B2_TOOL_GML_SPRITE_CONVERTER_ANIMATION_DEFINE_TEXT:
			# lots of scr_entity_animation_define() scripts.
			var text : PackedStringArray = anim.animation_define_text.split( "\n", false )
			for line in text:
				line = line.strip_edges( true, true ) # handle spaces at the beggining and end.
				if line.begins_with( "scr_entity_animation_define(" ):
					# found a script
					var script := line.trim_prefix("scr_entity_animation_define(").trim_suffix(");")
					var split_script := script.split(",", true)
					
					var speed := 0
					if split_script[4].contains("ANIMATION_DEFAULT_SPEED") or split_script[4].contains("spd"):
						speed = 5
					
					var anim_def := B2_TOOL_GML_SPRITE_CONVERTER_ANIMATION_DEFINE.new()
					anim_def.animationName 			= str( split_script[0] ).strip_edges( true, true ).trim_suffix('"').trim_prefix('"')
					anim_def.sprite					= str( split_script[1] ).strip_edges( true, true ).trim_suffix('"').trim_prefix('"')
					anim_def.startImage 			= int( split_script[2] )
					anim_def.numberOfFrames 		= int( split_script[3] )
					anim_def.animationSpeed 		= speed
					make_animated_sprite( anim_def )
					
				elif line.begins_with( "//" ):
					# its probablu a comment
					print( "Comment: ", line )
				else:
					print( "Unknown command: ", line )

		else:
			print("Unknow class %s." % anim.get_class())
			
	# Dont need to add anything if its just updating the node.
	if not update_anim_node:
		add_sibling.call_deferred( animatedsprite, true )
	animatedsprite.set_owner.call_deferred( get_parent() )
	
	#var sprite_data := animatedsprite.get_meta( "default" ) as Dictionary
	animatedsprite.centered = false
	#animatedsprite.offset = -Vector2( int( sprite_data["xorig"] ), int( sprite_data["yorigin"] ) )
	
	if create_col_node:
		set_placeholder_collision()
		
	if create_actor_interact:
		set_placeholder_interact()
	
	get_parent().adjust_sprite_offset()
	print("Conversion finished!")
	
func make_anim_stand_define(animname : String, startimage : int, spr := animname, n := 999) -> B2_TOOL_GML_SPRITE_CONVERTER_ANIMATION_DEFINE:
	var anim := B2_TOOL_GML_SPRITE_CONVERTER_ANIMATION_DEFINE.new()
	anim.animationName 			= animname
	anim.sprite					= spr
	anim.startImage 			= startimage
	anim.numberOfFrames 		= n ## 999 means all avaiable sprites
	anim.animationSpeed 		= 0
	return anim

func print_data_for_lazy_devs():
	print_rich("[color=Green] Cheat sheet :p  - paste this to the parent´s script[/color]")
	print( 'func _ready() -> void:')
	print( '	ANIMATION_STAND 						= "%s"' % str(ANIMATION_STAND))
	print( '	ANIMATION_SOUTH 						= "%s"' % str(ANIMATION_SOUTH))
	print( '	ANIMATION_SOUTHEAST 					= "%s"' % str(ANIMATION_SOUTHEAST))
	print( '	ANIMATION_SOUTHWEST 					= "%s"' % str(ANIMATION_SOUTHWEST))
	print( '	ANIMATION_WEST 							= "%s"' % str(ANIMATION_WEST))
	print( '	ANIMATION_NORTH 						= "%s"' % str(ANIMATION_NORTH))
	print( '	ANIMATION_NORTHEAST 					= "%s"' % str(ANIMATION_NORTHEAST))
	print( '	ANIMATION_NORTHWEST 					= "%s"' % str(ANIMATION_NORTHWEST))
	print( '	ANIMATION_EAST 							= "%s"' % str(ANIMATION_EAST))
	print( '	ANIMATION_STAND_SPRITE_INDEX 			= "%s"' % str(ANIMATION_STAND_SPRITE_INDEX))
	print( '	ActorAnim.animation 					= "%s"' % str(ANIMATION_STAND))
	print("\n")

	
func make_animated_sprite(anim : B2_TOOL_GML_SPRITE_CONVERTER_ANIMATION_DEFINE, ):
	assert(anim.animationName != ""	, "Name is Empty")
	assert(anim.sprite != ""		, "Sprite is Empty")
	
	if spr_frames.has_animation(anim.animationName):
		push_warning("skiping animation %s. it already exists." % anim.animationName)
		## Overwrite it?
		#return 
	
	var sprite_data 	:= parse_gmx( anim.sprite )
	var curr_frame 		:= anim.startImage as int
	var max_frames 		:= sprite_data["frames"].size() as int
	
	var _path = img_folder_path + "/" + anim.sprite + ".png"
	assert( FileAccess.file_exists(_path), "File doesnt exist. it really should." )
	var texture 	: Texture2D = ResourceLoader.load(_path, "Texture2D")
	
	if not spr_frames.has_animation( anim.animationName ):
		spr_frames.add_animation( anim.animationName )
	else:
		spr_frames.clear( anim.animationName )
	
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
	
	## set initial offset
	animatedsprite.offset = -Vector2( int( sprite_data["xorig"] ), int( sprite_data["yorigin"] ) )
	
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
		#print("Parse Successful for %s. " % filename)
		return sprite_data
	
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
		
func set_placeholder_interact():
	var can_add := true
	for c in get_parent().get_children():
		if c is Area2D:
			if c.name == int_node_name:
				can_add = false
	if can_add:
		var inter := Area2D.new()
		inter.name = int_node_name
		
		var int_shape 	:= CollisionShape2D.new()
		var rect_shape 	:= RectangleShape2D.new()
		
		rect_shape.size = int_node_shape
		int_shape.shape = rect_shape
		inter.add_child( int_shape, true )
		
		add_sibling.call_deferred( inter, true )
		int_shape.set_owner.call_deferred( get_parent() )
		inter.set_owner.call_deferred( get_parent() )
