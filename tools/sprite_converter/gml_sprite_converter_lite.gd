@tool
@icon("res://barkley2/assets/b2_original/images/merged/s_fct_boot01.png")
extends Node
class_name B2_TOOL_GML_SPRITE_CONVERTER_LITE

enum TYPE{PROP,ENVIRON,ENVIRONSOLID,ENVIRONSEMISOLID,INTERACTIVE}

# How to use this:
# Add this node to an marker
# set its type, sprite name
# let ir rip
# delete it when done

@export_category("Paths")
@export var obj_folder_path 	:= "/home/sanlo/Documents/GitHub/Barkley2_Original/barkley_2/Barkley2.gmx/sprites" # "Y:/tmp/barkley_2/Barkley2.gmx/sprites"
@export var img_folder_path 	:= "res://barkley2/assets/b2_original/images/merged/"

@export_category("Node stuff")
@export var target						: Marker2D :
	set( _marker ): target = _marker; sprite_name = target.name.split(" - ", false, 1)[1]; sprite_name[0] = "s"
@export var node_type					:= TYPE.PROP
@export var assume_sprite_name			:= true
@export var sprite_name					:= ""
@export var collision_shape				:= B2_Environ.SHAPES.CIRCLE
@export var collision_circle_radius 	:= 10
@export var collision_square_size 		:= Vector2(10,10)

@export_category("Tool Setup")
@export var animations 		: Array[B2_TOOL_GML_SPRITE_CONVERTER_ROOT]

@export_category("Run tool")
@export var lazy_mode			:= false ## fixes the name, set pos to 0 and get ready to save. useful for bulk prop convertions
@export var simulation			:= false
@export var remove_target_node	:= false
@export var start_conversion 	:= false :		## Start the conversion process.
	
	set(b):
		lets_goooo()
		
var animatedsprite 	: AnimatedSprite2D
var spr_frames		: SpriteFrames

func _ready() -> void:
	if not Engine.is_editor_hint():
		push_error( "B2_TOOL_GML_SPRITE_CONVERTER still exists on the %s node." % get_parent().name )
		return
	name = "B2_TOOL_GML_SPRITE_CONVERTER_LITE"
	
func lets_goooo():
	if sprite_name.is_empty():
		push_error("Sprite name not set.")
		return
	if not is_instance_valid(target):
		push_error("Target not set.")
		return 
		
	var lazy := false
	
	## Setup nodes and important resources
	var target_name 		:= target.name
	
	var object : B2_Environ
	
	match node_type:
		TYPE.PROP:
			object = B2_EnvironProp.new()
			object.shape = collision_shape
		TYPE.ENVIRON:
			object = B2_Environ.new()
		TYPE.ENVIRONSOLID:
			object = B2_EnvironSolid.new()
			object.shape = collision_shape
		TYPE.ENVIRONSEMISOLID:
			object = B2_EnvironSemisolid.new()
			object.shape = collision_shape
			
			if collision_shape == B2_Environ.SHAPES.CIRCLE:
				object.circle_radius = collision_circle_radius
				
			elif collision_shape == B2_Environ.SHAPES.SQUARE:
				object.square_size = collision_square_size
		TYPE.INTERACTIVE:
			object = B2_EnvironInteractive.new()
	animatedsprite 		= object
	spr_frames			= SpriteFrames.new()
	
	var anim = make_anim_stand_define("default", 0, sprite_name)
	make_animated_sprite( anim )
	
	if simulation:
		add_child( animatedsprite, true )
		animatedsprite.set_owner.call_deferred( self )
		print( get_children() )
	else:
		animatedsprite.position = target.position
		animatedsprite.name = target_name
		animatedsprite.set_owner( get_parent() )
		if remove_target_node:
			target.replace_by( animatedsprite )
			target.queue_free()
		else:
			add_sibling( animatedsprite, true )
			if lazy_mode:
				animatedsprite.name = target_name.split(" - ", false, 1)[ 1 ]
				animatedsprite.position = Vector2.ZERO
			else:
				animatedsprite.name = target_name + "_Placeholder"
			animatedsprite.set_owner( get_parent() )
		
	#var sprite_data := animatedsprite.get_meta( "default" ) as Dictionary
	animatedsprite.centered = false
	

	#get_parent().adjust_sprite_offset()
	print("Conversion finished!")
	
func make_anim_stand_define(animname : String, startimage : int, spr := animname, n := 999) -> B2_TOOL_GML_SPRITE_CONVERTER_ANIMATION_DEFINE:
	var anim := B2_TOOL_GML_SPRITE_CONVERTER_ANIMATION_DEFINE.new()
	anim.animationName 			= animname
	anim.sprite					= spr
	anim.startImage 			= startimage
	anim.numberOfFrames 		= n ## 999 means all avaiable sprites
	anim.animationSpeed 		= 0
	return anim
	
func make_animated_sprite(anim : B2_TOOL_GML_SPRITE_CONVERTER_ANIMATION_DEFINE, ):
	assert(anim.animationName != ""	, "Name is Empty")
	assert(anim.sprite != ""		, "Sprite is Empty")
	
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
			can_add = false
	if can_add:
		var col := CollisionShape2D.new()
		add_sibling.call_deferred( col, true )
		col.set_owner.call_deferred( get_parent() )
