@tool
@icon("res://barkley2/assets/icon/door_up.png")
extends Node
class_name B2_O_DOOR_CONVERTER

## This tool fixes an earlier mistake that I made, converting o_doors to o_door_directions.

const O_DOORLIGHT_DOWN 		= preload("res://barkley2/scenes/Objects/_doors/o_doorlight_down.tscn")
const O_DOORLIGHT_LEFT 		= preload("res://barkley2/scenes/Objects/_doors/o_doorlight_left.tscn")
const O_DOORLIGHT_RIGHT 	= preload("res://barkley2/scenes/Objects/_doors/o_doorlight_right.tscn")
const O_DOORLIGHT_UP 		= preload("res://barkley2/scenes/Objects/_doors/o_doorlight_up.tscn")

@export var simulate := true
@export var remove_old_doors := false
@export var execute := false :
	set(e):
		_run_this_bitch()
		
func _ready() -> void:
	#_run_this_bitch()
	pass
		
func _run_this_bitch() -> void:
	var all_nodes := get_parent().get_children()
	print("Begining... %s kids...." % all_nodes.size())
	for node in all_nodes:
		var new_door : B2_DoorLight
		if ( node is not B2_DoorLight or node.is_in_group("delete") ) and node.name.begins_with("o_doorlight"):
			if node.name.begins_with("o_doorlight_up"):
				new_door = O_DOORLIGHT_UP.instantiate()
			if node.name.begins_with("o_doorlight_down"):
				new_door = O_DOORLIGHT_DOWN.instantiate()
			if node.name.begins_with("o_doorlight_left"):
				new_door = O_DOORLIGHT_LEFT.instantiate()
			if node.name.begins_with("o_doorlight_right"):
				new_door = O_DOORLIGHT_RIGHT.instantiate()
			
		if is_instance_valid(new_door):
			print("Found %s." % node.name)
			## Copy door data
			new_door.name 									= node.name
			new_door.locked									= node.locked
			new_door.locked_msg								= node.locked_msg
			new_door.enabled								= node.enabled
			new_door.show_door_light						= node.show_door_light
			new_door.door_offset							= node.door_offset
			new_door.debug_door_exit_marker					= node.debug_door_exit_marker
			new_door.debug_door_exit_marker_pos				= node.debug_door_exit_marker_pos
			#new_door.door_exit_marker_pos					= node.door_exit_marker_pos
			new_door.teleport_string						= node.teleport_string
			
			new_door.position								= node.position
			new_door.scale									= node.scale
			new_door.z_index								= node.z_index
			
			new_door.debug_teleport_destination				= node.debug_teleport_destination
			new_door.debug_teleport_create_o_hoopz			= node.debug_teleport_create_o_hoopz
			new_door.teleport_create_o_hoopz				= node.teleport_create_o_hoopz
			new_door.teleport_destination					= node.teleport_destination
			
			## Copy metadata
			for meta in node.get_meta_list():
				new_door.set_meta( meta, node.get_meta(meta) )
			
			if not simulate:
				var my_order := -1 ## Add at the same order.
				if remove_old_doors:
					my_order = node.get_index()
					node.queue_free()
					await get_tree().process_frame
				else:
					new_door.name += "_NEW"
					
				print("Adding %s..." % new_door.name)
				#add_sibling.call_deferred( new_door, true )
				add_sibling( new_door, true )
				new_door.owner = get_parent()
				await get_tree().process_frame
				get_parent().move_child( new_door, my_order )
			else:
				print_rich("[color=pink][b]%s would be created at %s[/b][/color]" % [new_door.name, new_door.position])
		#else:
			#print_rich("[color=black][b]Didn't find any valid o_doors[/b][/color]")
