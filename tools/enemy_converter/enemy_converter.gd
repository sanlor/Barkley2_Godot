@tool
extends Node2D

## Scene used to "assemble" enemies, using Gamemaker data
@export_category("Paths")
@export var obj_folder_path 		:= "/home/sanlo/Documents/GitHub/Barkley2_Original/barkley_2/Barkley2.gmx/objects" # "Y:/tmp/barkley_2/Barkley2.gmx/objects"
@export var spr_folder_path 		:= "/home/sanlo/Documents/GitHub/Barkley2_Original/barkley_2/Barkley2.gmx/sprites" # "Y:/tmp/barkley_2/Barkley2.gmx/sprites"
@export var img_folder_path 		:= "res://barkley2/assets/b2_original/images/merged/"
@export var temp_enemy_folder		:= "res://barkley2/scenes/Objects/_enemies/_temp/"

@export_category("Export")
@export var save_to_disk				:= false ## After convertion, save to disk

@export_category("Node stuff")
@export var target						: String
@export var assume_sprite_name			:= true
@export var sprite_name					:= ""
@export var anim_node_name 				:= "ActorAnim" 	## Animation node name.
@export var col_node_name 				:= "ActorCol" 	## Collision node name.
@export var actor_navigation_name		:= "ActorNav"

@export_category("Enemy stuff")

@export_category("Tool Setup")
@export var animations 		: Array[B2_TOOL_GML_SPRITE_CONVERTER_ROOT]

@export_category("Run tool")
@export var print_debug_stuff		:= false
@export var stop_at_warnings		:= true ## Stop convertion if a warning is emited.
@export_tool_button("Start Convertion") var start_conversion 	: Callable = lets_goooo		## Start the conversion process.

var actor_node 			: B2_EnemyCombatActor
var animatedsprite 		: AnimatedSprite2D
var spr_frames 			: SpriteFrames
		
var collision_node		: CollisionShape2D
var interaction_area	: Area2D
		
var obj_data : Dictionary
var spr_data : Dictionary

func lets_goooo() -> void:
	if not target:
		push_error("No target.")
		return
	
	## Ex.: o_enemy_catfish_small
	var target_name := target
	if not target_name.begins_with("o_enemy"):
		push_warning("Target name does not follow the usual pattern: %s" % target_name)
		if stop_at_warnings:
			return
	
	## Get parset Object
	obj_data = parse_gmx_object( target_name )
	
	spr_data = parse_gmx_sprite( obj_data["spriteName"] )
	
	if obj_data.is_empty() or spr_data.is_empty():
		push_error("Something is wrong with data convertion. Aborting...")
		return
	
	actor_node = B2_EnemyCombatActor.new()
		
	actor_node.name					= target_name
	actor_node.actor_animations 	= B2_Actor_Animations.new()
	animatedsprite 					= AnimatedSprite2D.new()
	spr_frames 						= SpriteFrames.new()
	spr_frames.remove_animation("default")
	
	actor_node.ActorAnim = animatedsprite
	animatedsprite.use_parent_material = true
	animatedsprite.name = anim_node_name
	
	## Setup node for physics bullshit.
	actor_node.gravity_scale = 0.0
	actor_node.physics_material_override = load( "res://barkley2/resources/B2_Enemies/enemy_physics_material.tres" ) ## Default material for all enemies.
	actor_node.mass = 100.0
	actor_node.lock_rotation = true
	actor_node.linear_damp = 10.0
	
	## Chiiiiiiiiiill
	await get_tree().process_frame
	
	if not save_to_disk:
		add_child.call_deferred( actor_node, true )
		actor_node.set_owner.call_deferred( self )
	
	## Make default anim
	make_animated_sprite( make_anim_stand_define("default", 0, obj_data["spriteName"], 999) )
	
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
				
			
			if script_line.begins_with("scr_entity_animation_define("):
				scr_entity_animation_define( script_line )
			elif script_line.begins_with('Animation("define", '):
				Animation_parser( script_line )
			elif script_line.begins_with("scr_entity_look("):
				pass
			elif script_line.begins_with("scr_entity_set_walk("):
				scr_entity_set_walk( script_line )
			elif script_line.begins_with("scr_entity_set_look("):
				scr_entity_set_look( script_line )
			elif script_line.begins_with("scr_entity_set_look_walk_mirror("):
				scr_entity_set_look_walk_mirror( script_line )
			elif script_line.begins_with("deathSound"):
				actor_node.sound_death = script_line.get_slice("=", 1).get_slice('"',1).trim_suffix(";")
			elif script_line.begins_with("damageSound"):
				actor_node.sound_damage = script_line.get_slice("=", 1).get_slice('"',1).trim_suffix(";")
			elif script_line.begins_with('guard[? "sndAlertSound"]'):
				actor_node.sound_alert = script_line.get_slice("=", 1).get_slice('"',1).trim_suffix(";")
			else:
				if print_debug_stuff:
					print( "Doing nothing with line: %s" % script_line )
			
			index += 1
		
	actor_node.add_child.call_deferred( animatedsprite, true )
	if not save_to_disk:		animatedsprite.set_owner.call_deferred( self )
	else:						animatedsprite.set_owner.call_deferred( actor_node )
	
	animatedsprite.centered = false
	
	set_placeholder_collision()
	set_placeholder_nav()
	set_audio_emiter()
	set_particules()
		
	## Chill out
	await get_tree().process_frame
	
	if save_to_disk:
		var path := temp_enemy_folder
		var script = make_script()
		var s_error = ResourceSaver.save(script, path + actor_node.name + ".gd")
		if s_error != OK:
			push_error("An error occurred while saving the script to disk. Error ", s_error)
		actor_node.set_script( load(path + actor_node.name + ".gd") )
				
		actor_node.ActorAnim 				= animatedsprite
		actor_node.ActorCol 				= collision_node
		
		var scene := PackedScene.new()
		var result = scene.pack( actor_node )
		if result == OK:
			print("Saving actor to %s." % path)
			var error = ResourceSaver.save(scene, path + actor_node.name + ".tscn")
			if error != OK:
				push_error("An error occurred while saving the scene to disk. Error ", error)
				
		## Chill out
		await get_tree().process_frame
		
		## Instantiate new node.
		var e = load( path + actor_node.name + ".tscn" ).instantiate()
		add_child( e, true )
		e.owner = self
			
	print("Conversion finished!")

func make_script() -> GDScript:
	var script := GDScript.new()
	var code := ""
	code += 'extends B2_InteractiveActor\n\n'
	code += '## Made with EnemyConverter (%s)\n' % Time.get_datetime_string_from_system()
	code += 'func _ready() -> void:\n'
	code += '	pass'
	script.set_source_code( code )
	return script

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
	
	var walk_north := B2_TOOL_GML_SPRITE_CONVERTER_ANIMATION_DEFINE.new()
	walk_north.animationName 		= split_script[1]
	walk_north.sprite				= split_script[1]
	walk_north.startImage 			= 0
	walk_north.numberOfFrames 		= 999 ## 999 means all avaiable sprites
	walk_north.animationSpeed 		= 0
	make_animated_sprite( walk_north )
	
	var walk_south := B2_TOOL_GML_SPRITE_CONVERTER_ANIMATION_DEFINE.new()
	walk_south.animationName 		= split_script[2]
	walk_south.sprite				= split_script[2]
	walk_south.startImage 			= 0
	walk_south.numberOfFrames 		= 999 ## 999 means all avaiable sprites
	walk_south.animationSpeed 		= 0
	make_animated_sprite( walk_south )
	
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

func Animation_parser(dirty_script : String):
	var clean_script = dirty_script.trim_prefix('Animation("define", ')
	scr_entity_animation_define( "scr_entity_animation_define(" + clean_script )

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
			col.set_owner.call_deferred( self )
		else:
			col.set_owner.call_deferred( actor_node )
		actor_node.ActorCol = col
		collision_node = col
		
func set_audio_emiter():
	var audio := AudioStreamPlayer2D.new()
	audio.bus = "Audio"
	audio.max_distance = 350
	audio.name = "ActorAudioPlayer"
	actor_node.ActorAudioPlayer = audio
	actor_node.add_child(audio)
	if not save_to_disk:	audio.set_owner.call_deferred( self )
	else:					audio.set_owner.call_deferred( actor_node )
		
func set_particules():
	var part := GPUParticles2D.new()
	part.name = "ActorSmokeEmitter"
	actor_node.ActorSmokeEmitter = part
	actor_node.add_child(part)
	if not save_to_disk:	part.set_owner.call_deferred( self )
	else:					part.set_owner.call_deferred( actor_node )
		
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
		
		if not save_to_disk:			nav.set_owner.call_deferred( self )
		else:							nav.set_owner.call_deferred( actor_node )
