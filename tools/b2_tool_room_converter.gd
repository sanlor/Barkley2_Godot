@tool
extends Node
class_name B2_TOOL_ROOM_CONVERTER

@export var convert_cinema_spots 	:= true
@export var convert_door_light 		:= true
@export var convert_door	 		:= true

@export_category("Collision")
@export var convert_collision 		:= true
@export var col_object_name 		:= "o_solid"
@export var col_object_warn 		:= ["o_semisolid", "o_rigid", "_tri"]

@export_category("Dangerous")
@export var convert_known_nodes		:= false ## Attempo to search the game files for nodes with the same name. might fuck thins up.

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
					
			door_scene.position 				= node.position
			door_scene.teleport_destination 	= node.get_meta( "code" ) ## garbage setup
			
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
	var collision_layer := TileMapLayer.new()
	collision_layer.name 		= "layer - collision"
	collision_layer.z_index 	= 100
	add_sibling.call_deferred(collision_layer, true)
	collision_layer.set_owner.call_deferred( get_parent() )
	
	var all_nodes := get_parent().get_children()
	print( "Total of %s nodes." % str(all_nodes.size() ) )
	#print(all_nodes)
	var col_nodes := Array()
	var warn_nodes := Array()
	for n in all_nodes:
		#if n is Marker2D:
		if n.name.contains("o_solid"):
			col_nodes.append(n)
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
				
	if remove_nodes:
		for n in col_nodes:
			n.queue_free()
		col_nodes.clear()
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
