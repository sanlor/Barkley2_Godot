@tool
@icon("res://barkley2/assets/b2_original/images/merged/s_TreasureDwarfChained.png")
extends Node
class_name B2_TOOL_DWARF_CONVERTER


## Açsp can be used for InteractiveActor in general?
# Tool used to convert Dwarf objects, along with all possible animations.
# get the object
# read its contents and look for animations
# convert animations
# create necessary options
# get frustrated over multiple bug in my code.
# do it manually

enum TYPE{DWARF, DUERGAR}

@export_category("Paths")
@export var obj_folder_path 		:= "Y:/tmp/barkley_2/Barkley2.gmx/objects"
@export var spr_folder_path 		:= "Y:/tmp/barkley_2/Barkley2.gmx/sprites"
@export var img_folder_path 		:= "res://barkley2/assets/b2_original/images/merged/"
@export var dwarf_actor_file_path 	:= "res://barkley2/scenes/_tool_export/dwarf/"
@export var duergar_actor_file_path := "res://barkley2/scenes/_tool_export/duergar/"

@export_category("Export")
@export var save_to_disk				:= false ## After convertion, save to disk
@export var instantiate_right_after		:= false ## fater saving, instantiate right after.

@export_category("Node stuff")
@export var target						: Marker2D :
	set( _marker ): target = _marker; sprite_name = target.name.split(" - ", false, 1)[1]; sprite_name[0] = "s"
@export var node_type					:= TYPE.DWARF
@export var assume_sprite_name			:= true
@export var sprite_name					:= ""
#@export var assume_duergar_name			:= true
@export var duergar_name					:= ""
@export var anim_node_name 	:= "ActorAnim" 	## Animation node name.
@export var create_col_node := true
@export var col_node_name 	:= "ActorCol" 	## Collision node name.
@export var create_actor_interact := true
@export var int_node_name	:= "ActorInteract"
@export var int_node_shape	:= Vector2(20,36)
@export var create_actor_navigation := true
@export var actor_navigation_name	:= "ActorNav"

@export_category("Tool Setup")
@export var animations 		: Array[B2_TOOL_GML_SPRITE_CONVERTER_ROOT]

@export_category("Run tool")
@export var print_debug_stuff	:= false
@export var lazy_mode			:= false ## fixes the name, set pos to 0 and get ready to save. useful for bulk prop convertions
@export var simulation			:= false
@export var remove_target_node	:= false
@export var start_conversion 	:= false :		## Start the conversion process.
	set(b):
		lets_goooo()
		
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
		
var actor_node 			: B2_InteractiveActor
var animatedsprite 		: AnimatedSprite2D
var spr_frames 			: SpriteFrames
		
var collision_node		: CollisionShape2D
var interaction_area	: Area2D
		
var obj_data : Dictionary
var spr_data : Dictionary
		
func _ready() -> void:
	if not Engine.is_editor_hint():
		push_error( "B2_TOOL_DWARF_CONVERTER still exists on the %s node." % get_parent().name )
		#return
		#lets_goooo()
	
func lets_goooo():
	assert( is_instance_valid(target), "No target selected." )
	
	var target_name := target.name.split(" - ", false, 1)[ 1 ]
	
	obj_data = parse_gmx_object( target_name )
	
	if not obj_data["parentName"] == "oDuergar" and not obj_data["parentName"] == "InteractiveActor":
		push_error("Node not supported: ", obj_data["parentName"])
		return
	elif obj_data["parentName"] == "oDuergar":
		node_type = TYPE.DUERGAR
		print_rich("[color=cyan]We are working with a Duergar here.[/color]")
	elif obj_data["parentName"] == "InteractiveActor":
		node_type = TYPE.DWARF
		print_rich("[color=yellow]We are working with a Dwarf here.[/color]")
	else:
		## WTF?? what else could it be?
		breakpoint
		
	spr_data = parse_gmx_sprite( obj_data["spriteName"] )
	
	if obj_data.is_empty() or spr_data.is_empty():
		push_error("Something is wrong with data convertion. aborting...")
		return
	
	if node_type == TYPE.DWARF:
		actor_node = B2_InteractiveActor.new()
	elif node_type == TYPE.DUERGAR:
		actor_node = B2_Duergar.new()
	else:
		breakpoint
		
	actor_node.name		= target_name
	animatedsprite 		= AnimatedSprite2D.new()
	spr_frames 			= SpriteFrames.new()
	
	actor_node.ActorAnim = animatedsprite
	animatedsprite.use_parent_material = true
	animatedsprite.name = anim_node_name
	
	await get_tree().process_frame
	
	if not save_to_disk:
		add_sibling.call_deferred( actor_node, true )
		actor_node.set_owner.call_deferred( get_parent() )
	
	## Make default anim
	make_animated_sprite( make_anim_stand_define("default", 0, obj_data["spriteName"], 999) )
	ANIMATION_STAND = "default"
	
	## Only support the "create" script.
	for script_event : int in obj_data[ "script" ].size():
		var index := 0
		for script_line : String in obj_data[ "script" ][script_event] as Array:
			if script_line.is_empty():
				index += 1
				continue
			## Hey, the script didnt finish in the same line. append the next line to this one.
			if not script_line.ends_with(";"):
				if not script_line.ends_with("}"):
					if obj_data[ "script" ][script_event].size() <= index + 1: 
						breakpoint # array overflow.
					else:
						#print(obj_data[ "script" ][script_event].size(), " ", index)
						script_line += obj_data[ "script" ][script_event][ index + 1 ]
						obj_data[ "script" ][script_event][ index + 1 ] = ""
				
			#print(script_line)
			if script_line.begins_with("name = "):
				duergar_name = script_line.trim_prefix('name = "').trim_suffix('";')
				print_rich("[color=pink]Found Duergar name %s. is this correct?[/color]" % duergar_name)
			
			if script_line.begins_with("scr_entity_animation_define("):
				scr_entity_animation_define( script_line )
			elif script_line.begins_with("scr_entity_look("):
				pass
			elif script_line.begins_with("scr_entity_set_walk("):
				scr_entity_set_walk( script_line )
			elif script_line.begins_with("scr_entity_set_look("):
				scr_entity_set_look( script_line )
			elif script_line.begins_with("scr_entity_set_look_walk_mirror("):
				scr_entity_set_look_walk_mirror( script_line )
			else:
				if print_debug_stuff:
					print( "Doing nothing with line: %s" % script_line )
			
			index += 1
		
	if node_type == TYPE.DUERGAR:
		if duergar_name.is_empty():
			print		("CRITICAL ERROR: Duergar name was not found. Maybe it isnt even an Duergar.")
			push_error	("CRITICAL ERROR: Duergar name was not found. Maybe it isnt even an Duergar.")
			return
			
		
	## Guess what fucknut, duergars have some special code to set the animations.
	## Each part of the original game uses a different method of setting animations.
	if node_type == TYPE.DUERGAR:
		var sprIdl 	:= "s_%s01" % duergar_name
		var sprNE 	:= "s_%sNE" % duergar_name
		var sprSE 	:= "s_%sSE" % duergar_name
		var fake_script := "scr_entity_set_look_walk_mirror(%s,%s,%s);" % [sprIdl, sprNE, sprSE]
		scr_entity_set_look_walk_mirror(fake_script)
		
	actor_node.add_child.call_deferred( animatedsprite, true )
	if not save_to_disk:
		animatedsprite.set_owner.call_deferred( get_parent() )
	else:
		animatedsprite.set_owner.call_deferred( actor_node )
	
	#var sprite_data := animatedsprite.get_meta( "default" ) as Dictionary
	animatedsprite.centered = false
	#animatedsprite.offset = -Vector2( int( sprite_data["xorig"] ), int( sprite_data["yorigin"] ) )
	
	if create_col_node:
		set_placeholder_collision()
		
	if create_actor_interact:
		set_placeholder_interact()
	
	if create_actor_navigation:
		set_placeholder_nav()
		
	await get_tree().process_frame
	actor_node.is_interactive = create_actor_interact
	#actor_node.resize_mouse_detection_area = false # debug
	actor_node.adjust_sprite_offset()
	
	if save_to_disk:
		var path := ""
		if node_type == TYPE.DWARF: 
			path = dwarf_actor_file_path
		else:
			path = duergar_actor_file_path
			
		var script = make_script()
		var s_error = ResourceSaver.save(script, path + actor_node.name + ".gd")
		if s_error != OK:
			push_error("An error occurred while saving the script to disk. Error ", s_error)
		actor_node.set_script( load(path + actor_node.name + ".gd") )
				
		actor_node.mouse_detection_area 	= interaction_area
		actor_node.ActorAnim 				= animatedsprite
		actor_node.ActorCol 				= collision_node
		if node_type == TYPE.DUERGAR:
			actor_node.duergar_name = duergar_name
		
		var scene := PackedScene.new()
		var result = scene.pack( actor_node )
		if result == OK:
			print("Saving actor to %s." % path)
			var error = ResourceSaver.save(scene, path + actor_node.name + ".tscn")
			if error != OK:
				push_error("An error occurred while saving the scene to disk. Error ", error)
			
		if instantiate_right_after:
			var new_scene : B2_InteractiveActor = scene.instantiate()
			add_child( new_scene )
			new_scene.owner = get_parent()
			
	else:
		print_data_for_lazy_devs()
	print("Conversion finished!")
	
func scr_entity_set_look_walk_mirror( dirty_script : String ):
	var script := dirty_script.trim_prefix("scr_entity_set_look_walk_mirror(").trim_suffix(");")
	var split_script := script.split(",", true)
	
	# check scr_entity_set_look_walk_mirror()
	var standing := B2_TOOL_GML_SPRITE_CONVERTER_ANIMATION_DEFINE.new()
	standing.animationName 			= split_script[0] # "default" #anim.standing_sprite
	standing.sprite					= split_script[0]
	standing.startImage 			= 0
	standing.numberOfFrames 		= 999 ## 999 means all avaiable sprites
	standing.animationSpeed 		= 0
	make_animated_sprite( standing )
	ANIMATION_STAND = split_script[0] # "default"
	
	var walk_north := B2_TOOL_GML_SPRITE_CONVERTER_ANIMATION_DEFINE.new()
	walk_north.animationName 		= split_script[1]
	walk_north.sprite				= split_script[1]
	walk_north.startImage 			= 0
	walk_north.numberOfFrames 		= 999 ## 999 means all avaiable sprites
	walk_north.animationSpeed 		= 0
	make_animated_sprite( walk_north )
	
	ANIMATION_NORTH 		= split_script[1]
	ANIMATION_NORTHEAST 	= split_script[1]
	ANIMATION_NORTHWEST		= split_script[1]
	
	var walk_south := B2_TOOL_GML_SPRITE_CONVERTER_ANIMATION_DEFINE.new()
	walk_south.animationName 		= split_script[2]
	walk_south.sprite				= split_script[2]
	walk_south.startImage 			= 0
	walk_south.numberOfFrames 		= 999 ## 999 means all avaiable sprites
	walk_south.animationSpeed 		= 0
	make_animated_sprite( walk_south )
	
	ANIMATION_EAST 					= split_script[2]
	ANIMATION_SOUTHEAST 			= split_script[2]
	ANIMATION_SOUTH 				= split_script[2]
	ANIMATION_SOUTHWEST				= split_script[2]
	ANIMATION_WEST					= split_script[2]
	ANIMATION_STAND_SPRITE_INDEX 	= [ 1, 1, 0, 0, 0, 0, 0, 1 ]
	
func scr_entity_set_walk( dirty_script : String ):
	var script := dirty_script.trim_prefix("scr_entity_set_walk(").trim_suffix(");")
	var split_script := script.split(",", true)
	
	make_animated_sprite( make_anim_stand_define( "walk_S", 	0, split_script[0], 			999 ) )
	make_animated_sprite( make_anim_stand_define( "walk_SE", 	0, split_script[1] , 			999 ) )
	make_animated_sprite( make_anim_stand_define( "walk_SW", 	0, split_script[2], 			999 ) )
	make_animated_sprite( make_anim_stand_define( "walk_W", 	0, split_script[3], 			999 ) )
	make_animated_sprite( make_anim_stand_define( "walk_N", 	0, split_script[4], 			999 ) )
	make_animated_sprite( make_anim_stand_define( "walk_NE", 	0, split_script[5], 			999 ) )
	make_animated_sprite( make_anim_stand_define( "walk_NW", 	0, split_script[6], 			999 ) )
	make_animated_sprite( make_anim_stand_define( "walk_E", 	0, split_script[7], 			999 ) )
	
	ANIMATION_NORTH 			= "walk_N" 		# anim.animation_north.animationName
	ANIMATION_NORTHEAST 		= "walk_NE" 	# anim.animation_northeast.animationName
	ANIMATION_NORTHWEST			= "walk_NW" 	# anim.animation_northwest.animationName
	ANIMATION_EAST 				= "walk_E" 		# anim.animation_east.animationName
	ANIMATION_SOUTHEAST 		= "walk_SE" 	# anim.animation_southeast.animationName
	ANIMATION_SOUTH 			= "walk_S" 		# anim.animation_south.animationName
	ANIMATION_SOUTHWEST			= "walk_SW" 	# anim.animation_southwest.animationName
	ANIMATION_WEST				= "walk_W" 		# anim.animation_west.animationName
	
func scr_entity_set_look( dirty_script : String ):
	var script := dirty_script.trim_prefix("scr_entity_set_look(").trim_suffix(");")
	var split_script := script.split(",", true)
	
	var stand := B2_TOOL_GML_SPRITE_CONVERTER_ANIMATION_DEFINE.new()
	stand.animationName 		= split_script[0]
	stand.sprite				= split_script[0]
	stand.startImage 			= 0
	stand.numberOfFrames 		= 999 ## 999 means all avaiable sprites
	stand.animationSpeed 		= 0
	make_animated_sprite( stand )
	
	## scr_entity_set_look(sprite, N, NE, E, SE, S, SW, W, NW);
	ANIMATION_STAND = split_script[0]
	ANIMATION_STAND_SPRITE_INDEX = [
		int(split_script[1]), 
		int(split_script[2]), 
		int(split_script[3]), 
		int(split_script[4]), 
		int(split_script[5]), 
		int(split_script[6]), 
		int(split_script[7]), 
		int(split_script[8]) ]

func scr_entity_animation_define( dirty_script : String):
	var script := dirty_script.trim_prefix("scr_entity_animation_define(").trim_suffix(");")
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
	
	if spr_frames.has_animation(anim.animationName):
		push_warning("skiping animation %s. it already exists." % anim.animationName)
		## Overwrite it?
		#return 
	
	var sprite_data 	:= parse_gmx_sprite( anim.sprite.strip_edges() )
	var curr_frame 		:= anim.startImage as int
	var max_frames 		:= sprite_data["frames"].size() as int
	
	var _path = img_folder_path + "/" + anim.sprite.strip_edges() + ".png"
	assert( FileAccess.file_exists(_path), "File %s doesnt exist. it really should." % _path)
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
	#sprite_data.erase("frames")
	animatedsprite.set_meta(anim.animationName, sprite_data)
	
	## set initial offset
	animatedsprite.offset = -Vector2( int( sprite_data["xorig"] ), int( sprite_data["yorigin"] ) )

func print_data_for_lazy_devs():
	print_rich("[color=Green] Cheat sheet :p  - paste this to the parent´s script[/color]")
	print( 'func _ready() -> void:')
	if node_type == TYPE.DUERGAR: 
		print( '	duergar_name 							= "%s"' % str(duergar_name))
	print( '	ANIMATION_STAND 						= "%s"' % str(ANIMATION_STAND))
	print( '	ANIMATION_SOUTH 						= "%s"' % str(ANIMATION_SOUTH))
	print( '	ANIMATION_SOUTHEAST 					= "%s"' % str(ANIMATION_SOUTHEAST))
	print( '	ANIMATION_SOUTHWEST 					= "%s"' % str(ANIMATION_SOUTHWEST))
	print( '	ANIMATION_WEST 							= "%s"' % str(ANIMATION_WEST))
	print( '	ANIMATION_NORTH 						= "%s"' % str(ANIMATION_NORTH))
	print( '	ANIMATION_NORTHEAST 					= "%s"' % str(ANIMATION_NORTHEAST))
	print( '	ANIMATION_NORTHWEST 					= "%s"' % str(ANIMATION_NORTHWEST))
	print( '	ANIMATION_EAST 							= "%s"' % str(ANIMATION_EAST))
	print( '	ANIMATION_STAND_SPRITE_INDEX 			= %s' % str(ANIMATION_STAND_SPRITE_INDEX))
	print( '	ActorAnim.animation 					= "%s"' % str(ANIMATION_STAND))
	print("\n")

func parse_gmx_object(filename : String) -> Dictionary:
	var has_file := false
	for file : String in DirAccess.get_files_at(obj_folder_path):
		if file.trim_suffix(".object.gmx"):
			has_file = true
	if not has_file:
		print("There is no object called ", filename)
		return Dictionary()
	else:
		var parser := XMLParser.new()
		var error = parser.open( obj_folder_path + "/" + filename + ".object.gmx" )
		if error != OK:
			print( error, " - Couldnt parse the file ", obj_folder_path + "/" + filename + ".object.gmx" )
			return Dictionary()
			
		var write_text_to := ""
		var write_to_array := false
		var _obj_data := {}
		var kind := 0
		_obj_data["script"] = Array()
		
		while parser.read() != ERR_FILE_EOF:
			if parser.get_node_type() == XMLParser.NODE_ELEMENT:
				var node_name = parser.get_node_name()
				#print( node_name )
				if node_name == "spriteName":
					_obj_data[node_name] = null
					write_text_to = node_name
				
				# Verify if the parent is InteractiveActor
				if node_name == "parentName":
					_obj_data[node_name] = null
					write_text_to = node_name
					
				if node_name == "kind":
					#obj_data[node_name] = null
					write_text_to = node_name
				
				# Frame is the sprite frames
				elif node_name == "string":
					write_text_to = node_name
					
			if parser.get_node_type() == XMLParser.NODE_TEXT:
				if not write_text_to.is_empty():
					if write_text_to == "kind":
						kind = int( parser.get_node_data() )
						write_text_to = ""
					elif write_text_to == "string":
						var script_string := ( parser.get_node_data() as String ).split("\n", false)
						var parsed_script_string := PackedStringArray()
						for string : String in script_string:
							var p := string.strip_edges(true, true)
							if not p.is_empty():
								if not p.begins_with("//"):
									parsed_script_string.append( p )
							
						#_obj_data[kind] = parsed_script_string
						_obj_data["script"].append( parsed_script_string )
						write_text_to = ""
					else:
						_obj_data[write_text_to]  = parser.get_node_data()
						write_text_to = ""
					
		#print("Parse Successful for %s. " % filename)
		return _obj_data

func parse_gmx_sprite(filename : String) -> Dictionary:
	var has_file := false
	for file : String in DirAccess.get_files_at(spr_folder_path):
		if file.trim_suffix(".sprite.gmx"):
			has_file = true
	if not has_file:
		print("There is no sprite called 'filename'")
		return Dictionary()
	else:
		var parser := XMLParser.new()
		var error = parser.open( spr_folder_path + "/" + filename + ".sprite.gmx" )
		if error != OK:
			print( error, " - Couldnt parse the file ", spr_folder_path + "/" + filename + ".sprite.gmx" )
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

func make_script() -> GDScript:
	var script := GDScript.new()
	var code := ""
	if node_type == TYPE.DUERGAR: 
		code += 'extends B2_Duergar\n\n'
		code += '## Made with B2_TOOL_DWARF_CONVERTER\n'
		code += 'func _ready() -> void:\n'
		code += '	duergar_name 							= "%s"\n' % str(duergar_name)
	else:
		code += 'extends B2_InteractiveActor\n\n'
		code += '## Made with B2_TOOL_DWARF_CONVERTER\n'
		code += 'func _ready() -> void:\n'
	code += '	_setup_actor()\n'
	code += '	_setup_interactiveactor()\n\n'
	code += '	ANIMATION_STAND 						= "%s"\n' % str(ANIMATION_STAND)
	code += '	ANIMATION_SOUTH 						= "%s"\n' % str(ANIMATION_SOUTH)
	code += '	ANIMATION_SOUTHEAST 					= "%s"\n' % str(ANIMATION_SOUTHEAST)
	code += '	ANIMATION_SOUTHWEST 					= "%s"\n' % str(ANIMATION_SOUTHWEST)
	code += '	ANIMATION_WEST 							= "%s"\n' % str(ANIMATION_WEST)
	code += '	ANIMATION_NORTH 						= "%s"\n' % str(ANIMATION_NORTH)
	code += '	ANIMATION_NORTHEAST 					= "%s"\n' % str(ANIMATION_NORTHEAST)
	code += '	ANIMATION_NORTHWEST 					= "%s"\n' % str(ANIMATION_NORTHWEST)
	code += '	ANIMATION_EAST 							= "%s"\n' % str(ANIMATION_EAST)
	code += '	ANIMATION_STAND_SPRITE_INDEX 			= %s\n' % str(ANIMATION_STAND_SPRITE_INDEX)
	code += '	ActorAnim.animation 					= "%s"\n' % str(ANIMATION_STAND)
	script.set_source_code( code )
	return script

func set_placeholder_collision():
	## If there is a temp col already, skip it.
	var can_add := true
	for c in actor_node.get_children():
		if c is CollisionShape2D:
			if c.name == col_node_name:
				can_add = false
	if can_add:
		var col := CollisionShape2D.new()
		col.name = col_node_name
		
		actor_node.add_child.call_deferred( col, true )
		if not save_to_disk:
			col.set_owner.call_deferred( get_parent() )
		else:
			col.set_owner.call_deferred( actor_node )
		actor_node.ActorCol = col
		collision_node = col
		
func set_placeholder_nav():
	var can_add := true
	for c in actor_node.get_children():
		if c is NavigationAgent2D:
			if c.name == actor_navigation_name:
				can_add = false
	if can_add:
		var nav := NavigationAgent2D.new()
		nav.name = actor_navigation_name
		
		actor_node.add_child.call_deferred( nav, true )
		
		if not save_to_disk:
			nav.set_owner.call_deferred( get_parent() )
		else:
			nav.set_owner.call_deferred( actor_node )
	
func set_placeholder_interact():
	var can_add := true
	for c in actor_node.get_children():
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
		
		actor_node.add_child.call_deferred( inter, true )
		if not save_to_disk:
			int_shape.set_owner.call_deferred( 	get_parent() )
			inter.set_owner.call_deferred( 		get_parent() )
		else:
			int_shape.set_owner.call_deferred( 	actor_node )
			inter.set_owner.call_deferred( 		actor_node )
		actor_node.mouse_detection_area = inter
		interaction_area = inter
