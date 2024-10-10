@tool
@icon("res://barkley2/assets/b2_original/images/merged/s_solid8.png")
extends Node
class_name B2_TOOL_COLLISION_CONVERTER

## Simple tool to convert o_solid objects into Tilemaplayer collisions.
@export var collision_layer : TileMapLayer
@export_file("collision_tileset.tres") var collision_tileset := "res://barkley2/resources/collision_tileset.tres"

@export var col_object_name := "o_solid"
@export var col_object_warn := ["o_semisolid", "o_rigid", "_tri"]

@export_category("Exec")
@export var simulate 			:= true					## Dont change anything, just check if everything is working fine
@export var remove_nodes 		:= false
@export var start_conversion 	:= false :				## Start the conversion process.
	set(b):
		lets_goooo()

func lets_goooo():
	if not is_instance_valid(collision_layer):
		print("col layer not set. quitting...")
		return
		
	print("Starting...")
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
	collision_layer.tile_set = load( collision_tileset )
	
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
	
