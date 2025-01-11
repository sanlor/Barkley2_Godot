@tool
extends Node
class_name B2_TOOL_ROOM_CONVERTER

@export var convert_cinema_spots 	:= true
@export var convert_door_light 		:= true
@export var convert_door	 		:= true

@export_category("Collision")
@export var convert_collision 		:= true
@export var col_object_name 		:= "o_solid"
@export var semicol_object_name 	:= "o_semisolid"
@export var col_object_warn 		:= ["o_rigid", "_tri"]

@export_category("Dangerous")
@export var known_packed_scenes 	: Array[PackedScene]
@export var known_packed_scenes_exceptions : Array[String] = ["o_doorlight_", "o_cinema"]
@export var convert_known_nodes		:= false ## Attempt to search the game files for nodes with the same name. might fuck thins up.

@export_category("Exec")
@export var simulate 			:= true					## Dont change anything, just check if everything is working fine
@export var remove_nodes 		:= false
@export var start_conversion 	:= false :				## Start the conversion process.
	set(b):
		lets_goooo()
		
func _ready() -> void:
	#lets_goooo()
	pass
	
func lets_goooo():
	if convert_cinema_spots: 	cinemaspot()
	if convert_collision: 		collision()
	if convert_door:			regular_door()
	if convert_door_light:		door_light()
	if convert_known_nodes:		fuck_around_with_nodes()

func get_clean_nodes() -> Array:
	return get_parent().get_children()
func door_light():
	print("starting doorlight convertion...")
	var all_nodes := get_clean_nodes()
	
	var to_delete := Array()
	for node in all_nodes:
		if node.name.contains( "o_doorlight_" ) and node is Marker2D:
			print("Workng on %s" % node.name)
			var door_scene : B2_DoorLight = preload("res://barkley2/scenes/Objects/_doors/o_doorlight.tscn").instantiate()
			door_scene.show_door_light = false
			
			match node.name.split(" - ", false, 1)[-1]:
				"o_doorlight_down":
					door_scene.type = B2_DoorLight.DOOR_TYPE.UP
				"o_doorlight_up":
					door_scene.type = B2_DoorLight.DOOR_TYPE.DOWN
				"o_doorlight_left":
					door_scene.type = B2_DoorLight.DOOR_TYPE.LEFT
				"o_doorlight_right":
					door_scene.type = B2_DoorLight.DOOR_TYPE.RIGHT
				_:
					push_warning("Weird door %s" % node.name)
					door_scene.type = B2_DoorLight.DOOR_TYPE.UP
					
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
		
	print("finished doorlight convertion...")

func regular_door():
	print("starting door convertion...")
	var all_nodes := get_clean_nodes()
	
	for node in all_nodes:
		if node.name.contains( "o_door_" ) and node is Marker2D:
			## TODO code to convert stuff.
			pass
	
func collision():
	print("starting collision convertion...")
	# assume no collision node
	
	var solid_name 	:= "layer - collision"
	var semi_solid_name	:= "layer - collision 2"
	
	var all_nodes := get_parent().get_children()
	for c in all_nodes: # check for existing collision node.
		if c.name == solid_name and c.name == semi_solid_name:
			return
	
	var collision_layer := TileMapLayer.new()
	collision_layer.name 		= solid_name
	collision_layer.z_index 	= 1000
	add_sibling.call_deferred(collision_layer, true)
	collision_layer.set_owner.call_deferred( get_parent() )
	
	var semi_collision_layer := TileMapLayer.new()
	semi_collision_layer.name 		= semi_solid_name
	semi_collision_layer.z_index 	= 1000
	add_sibling.call_deferred(semi_collision_layer, true)
	semi_collision_layer.set_owner.call_deferred( get_parent() )
	
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
	collision_layer.tile_set 	= load( "res://barkley2/resources/collision_tileset.tres" )
	semi_collision_layer.clear()
	semi_collision_layer.tile_set 	= load( "res://barkley2/resources/collision_tileset.tres" )
	
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
		
	print("Finished. %s changes made." % str(changes) )

func fuck_around_with_nodes():
	var p_scenes : Array = FileSearch.search_dir( "res://barkley2/scenes/", "", true )
	
	var all_nodes : Array
	for c in get_parent().get_children():
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
			
		add_sibling( node, true )
		node.owner = get_parent()
		
		if remove_nodes: c.queue_free()
