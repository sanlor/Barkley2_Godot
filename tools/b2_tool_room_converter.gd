@tool
extends Node
class_name B2_TOOL_ROOM_CONVERTER

@export var convert_cinema_spots 	:= true
@export var convert_door_light 		:= true
@export var convert_door	 		:= true
@export var create_room_script		:= true

@export_category("Collision")
@export var convert_collision 		:= true
@export var col_object_name 		:= "o_solid"
@export var semicol_object_name 	:= "o_semisolid"
@export var wade_object_name 		:= "o_wading"
@export var col_object_warn 		:= ["o_rigid", "_tri"]

@export_category("Dangerous")
@export var known_packed_scenes 	: Array[PackedScene]
@export var known_packed_scenes_exceptions : Array[String] = ["o_doorlight_", "o_cinema", "B2_TOOL", "o_effect_smog"]
@export var convert_known_nodes		:= true ## Attempt to search the game files for nodes with the same name. might fuck thins up.

@export_category("Exec")
@export var simulate 					:= false					## Dont change anything, just check if everything is working fine
@export var remove_nodes 				:= true
@export var adjust_layer_z_index		:= true
@export var set_room_settings			:= true
@export_tool_button("start_conversion") var start_conversion 	: Callable = lets_goooo				## Start the conversion process.
		
		
func _ready() -> void:
	name = "B2_TOOL_ROOM_CONVERTER"
	
func lets_goooo():
	if create_room_script:		room_script()
	if convert_cinema_spots: 	cinemaspot()
	if convert_collision: 		collision()
	if convert_door:			regular_door()
	if convert_door_light:		door_light()
	if adjust_layer_z_index:	fix_z_index()
	if set_room_settings:		set_room()
	if convert_known_nodes:		fuck_around_with_nodes()

func set_room() -> void:
	var cleanup := []
	for l : Node in get_clean_nodes():
		if not get_parent().navigation_polygon:
			get_parent().navigation_polygon = NavigationPolygon.new()
		if l.name == "o_teleport_mark":
			get_parent().debug_create_player_scene_at_room_start = true
			get_parent().debug_player_scene_pos = l.position
			get_parent().load_debug_save_data = true
		elif l.name == "layer - collision":
			get_parent().collision_layer = l
		elif l.name == "layer - collision 2":
			get_parent().collision_layer_semi = l
		elif l.name == "layer - wading":
			get_parent().collision_wade = l
		elif l.name.ends_with( "o_room_pacify" ):
			get_parent().room_pacify = true
			cleanup.append(l)
		elif l.name.ends_with( "o_room_interior" ):
			get_parent().is_interior = true
			cleanup.append(l)
		elif l.name.contains( "o_teleport_mark" ):
			get_parent().teleport_spot = true
			get_parent().teleport_node = l
			get_parent().load_debug_save_data = true
		elif l.name == "o_effect_smog":
			get_parent().weather_fog = true
			cleanup.append(l)
		elif l.name == "o_effect_rain":
			get_parent().weather_rain = true
			cleanup.append(l)
		elif l.name.begins_with("o_effect_"):
			push_error("Weird effect found. doing nothing.")
	
	for l in cleanup:
		l.queue_free()

func room_script() -> void:
	#if not get_parent().get_script():
	const DEFAULTSCRIPT = preload("uid://b3w1qi846g3lr")
	var room_path := get_parent().scene_file_path.get_base_dir()
	ResourceSaver.save( DEFAULTSCRIPT, room_path + "/" + get_parent().name + ".gd" )
	get_parent().set_script( load( room_path + "/" + get_parent().name + ".gd" ) )
	#else:
	#	print("room_script(): Already has a script attached.")
	create_room_script = false

func fix_z_index() -> void:
	for l in get_clean_nodes():
		if l is TileMapLayer:
			if l.name.begins_with("layer"):
				l.z_index = -10
			if l.name.get_slice(" ", 1).to_int() < 0:
				l.z_index = 100
			if l.name == "layer - collision":
				l.z_index = 100
			if l.name == "layer - collision 2":
				l.z_index = 100
			if l.name == "layer - wading":
				l.z_index = 100

func get_clean_nodes() -> Array:
	return get_parent().get_children()
	
func door_light():
	print("starting doorlight convertion...")
	var all_nodes := get_clean_nodes()
	
	var to_delete := Array()
	for node in all_nodes:
		if node.name.contains( "o_doorlight_" ) and node is Marker2D:
			print("Workng on %s" % node.name)
			const O_DOORLIGHT_DOWN 	= preload("res://barkley2/scenes/Objects/_doors/o_doorlight_down.tscn")
			const O_DOORLIGHT_LEFT 	= preload("res://barkley2/scenes/Objects/_doors/o_doorlight_left.tscn")
			const O_DOORLIGHT_RIGHT = preload("res://barkley2/scenes/Objects/_doors/o_doorlight_right.tscn")
			const O_DOORLIGHT_UP 	= preload("res://barkley2/scenes/Objects/_doors/o_doorlight_up.tscn")
			
			var door_scene : B2_DoorLight# = preload("res://barkley2/scenes/Objects/_doors/o_doorlight.tscn").instantiate()
			
			match node.name.split(" - ", false, 1)[-1]:
				"o_doorlight_up":
					door_scene = O_DOORLIGHT_UP.instantiate()
				"o_doorlight_down":
					door_scene = O_DOORLIGHT_DOWN.instantiate()
				"o_doorlight_left":
					door_scene = O_DOORLIGHT_LEFT.instantiate()
				"o_doorlight_right":
					door_scene = O_DOORLIGHT_RIGHT.instantiate()
					
			door_scene.name = node.name.split(" - ", false, 1)[-1]
			door_scene.position 				= node.position
			door_scene.teleport_destination 	= node.get_meta( "code" ).trim_prefix("RoomXY(").trim_suffix(");") ## garbage setup
			
			# copy metadata
			for meta : String in node.get_meta_list():
				door_scene.set_meta( meta, node.get_meta( meta ) )
				
			add_sibling.call_deferred( door_scene, true )
			door_scene.set_owner.call_deferred( get_parent() )
			to_delete.append( node )
			
	if remove_nodes:
		for n in to_delete:
			n.queue_free()
		
	convert_door_light = false
	print("finished doorlight convertion...")

func regular_door():
	print("starting door convertion...")
	var all_nodes := get_clean_nodes()
	
	for node in all_nodes:
		if node.name.contains( "o_door_" ) and node is Marker2D:
			## TODO code to convert stuff.
			pass
	convert_door = false
	
func collision():
	print("starting collision convertion...")
	# assume no collision node
	
	var solid_name 			:= "layer - collision"
	var semi_solid_name		:= "layer - collision 2"
	var wade_solid_name		:= "layer - wading"
	
	var all_nodes := get_parent().get_children()
	for c in all_nodes: # check for existing collision node.
		if c.name == solid_name and c.name == semi_solid_name:
			return
	
	var collision_layer := TileMapLayer.new()
	collision_layer.name 		= solid_name
	collision_layer.z_index 	= 100
	add_sibling.call_deferred(collision_layer, true)
	collision_layer.set_owner.call_deferred( get_parent() )
	
	var semi_collision_layer := TileMapLayer.new()
	semi_collision_layer.name 		= semi_solid_name
	semi_collision_layer.z_index 	= 100
	add_sibling.call_deferred(semi_collision_layer, true)
	semi_collision_layer.set_owner.call_deferred( get_parent() )
	
	var wade_collision_layer := TileMapLayer.new()
	wade_collision_layer.name 		= wade_solid_name
	wade_collision_layer.z_index 	= 100
	add_sibling.call_deferred(wade_collision_layer, true)
	wade_collision_layer.set_owner.call_deferred( get_parent() )
	
	print( "Total of %s nodes." % str(all_nodes.size() ) )
	#print(all_nodes)
	var col_nodes 		:= Array()
	var semi_col_nodes 	:= Array()
	var warn_nodes 		:= Array()
	for n in all_nodes:
		#if n is Marker2D:
		if n.name.contains(col_object_name):
			col_nodes.append(n)
		elif n.name.contains(semicol_object_name) and not n.name.contains("_tri"):
			semi_col_nodes.append(n)
		else:
			for obj : String in col_object_warn:
				if n.name.contains( obj ):
					warn_nodes.append( n )
						
	if simulate:
		print("Simulation: Found %s colision nodes. Warinings are %s. Quitting." % [ str(col_nodes.size()), str(warn_nodes) ] )
		return
		
	print("writing changes...")
	collision_layer.clear()
	collision_layer.tile_set 		= load( "uid://n70843ohvm84" )
	semi_collision_layer.clear()
	semi_collision_layer.tile_set 	= load( "uid://cbgwi3h47ghpg" )
	wade_collision_layer.clear()
	wade_collision_layer.tile_set 	= load( "uid://m673wsth5kja" )
	
	for col in col_nodes:
		var pos 		:= col.global_position as Vector2i
		var local_pos 	:= collision_layer.local_to_map( pos )
		var size_x 		:= col.get_meta("scale").x as int
		var size_y 		:= col.get_meta("scale").y as int
		
		print("pos ",pos)
		print("local ",local_pos)
		print(" ")
		
		for x in size_x:
			for y in size_y:
				var target := Vector2i( local_pos.x + x, local_pos.y + y )
				collision_layer.set_cell( target, 25, Vector2i( 0, 0 ), 0)
				
	for col in semi_col_nodes:
		var pos 		:= col.global_position as Vector2i
		var local_pos 	:= collision_layer.local_to_map( pos )
		var size_x 		:= col.get_meta("scale").x as int
		var size_y 		:= col.get_meta("scale").y as int
		
		print("pos ",pos)
		print("local ",local_pos)
		print(" ")
		
		for x in size_x:
			for y in size_y:
				var target := Vector2i( local_pos.x + x, local_pos.y + y )
				semi_collision_layer.set_cell( target, 25, Vector2i( 2, 2 ), 0)
				
	if remove_nodes:
		for n in col_nodes:
			n.queue_free()
		col_nodes.clear()
		for n in semi_col_nodes:
			n.queue_free()
		semi_col_nodes.clear()
		
	convert_collision = false
	print("Task done.")
	print_rich("[color=pink] Warning nodes are %s.[/color]" % str(warn_nodes) )

func cinemaspot():
	print("starting cinemaspot convertion...")
	var cinemaspots 		:= Array()
	var cinemaspotnames 	:= Array()
	var _duplicate			:= false
	var tree_nodes = get_parent().get_children()
	print( "%s children total." % tree_nodes.size() )
	for n in tree_nodes:
		if n is Marker2D and n is not B2_CinemaSpot : # mess with markers only.
			var n_name : String = n.name.split(" - ", false, 1)[ 1 ] # split the name, get the second half. ex.: "P131 - o_cinema4" -> "o_cinema4"
			if n_name.begins_with("o_cinema"):
				if cinemaspotnames.has(n_name):
					_duplicate = true
				cinemaspots.append(n)
				cinemaspotnames.append(n_name)
	
	if simulate:
		print("Simulation: Found %s cinema markers. _duplicate state is %s. Quitting." % [ str(cinemaspots.size()), str(_duplicate) ] )
		return
		
	var changes := 0
	print("Writing changes to scene.")
	for c : Marker2D in cinemaspots:
		var c_spot 	:= B2_CinemaSpot.new()
		var n_name 	: String = c.name.split(" - ", false, 1)[ 1 ]
		var n_pos	:= c.global_position
		
		for meta : String in c.get_meta_list():
			c_spot.set_meta( meta, c.get_meta(meta) )
		
		c_spot.cinema_id = int( n_name.trim_prefix("o_cinema") )
		
		c.replace_by( c_spot )
		c_spot.owner = get_parent()
		c_spot.name = n_name
		c_spot.global_position = n_pos
		changes += 1
		
	convert_cinema_spots = false
	print("Finished. %s changes made." % str(changes) )

func fuck_around_with_nodes():
	var p_scenes : Array = FileSearch.search_dir( "res://barkley2/scenes/", "", true )
	
	var all_nodes : Array
	for c in get_parent().get_children():
		if c.name.begins_with("B2_TOOL"):
			continue
		if c is Marker2D:
			if c.name.begins_with("P"):
				all_nodes.append(c)
				
	# loop for each temp node
	for c : Marker2D in all_nodes:
		var real_name : String = c.name.split(" - ", false, 1)[ 1 ] 
		var scene_path := ""
		
		var skip := false
		for exceptions : String in known_packed_scenes_exceptions:
			if real_name.begins_with( exceptions ):
				print( "Node %s skipped." % real_name )
				skip = true
				break
		if skip: continue
		
		# Look for valid scene
		for s : String in p_scenes:
			if s.contains( real_name ) and s.ends_with(".tscn"):
				scene_path = s
				break
				
		if scene_path.is_empty(): # scene not found
			continue
			
		var scene : PackedScene = load( scene_path )
		var node = scene.instantiate()
		print(scene_path)
		node.name = real_name
		if node is Node2D:
			node.position = c.position
		for meta : String in c.get_meta_list():
			node.set_meta( meta, c.get_meta(meta) )
			
		var index := c.get_index()
		if remove_nodes: c.queue_free()
			
		add_sibling( node, true )
		node.owner = get_parent()
		get_parent().move_child( node, index )
		
		
