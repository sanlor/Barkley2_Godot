@tool
@icon("res://barkley2/assets/b2_original/images/merged/s_cinema_marker_0.png")
extends Node
class_name B2_TOOL_CONVERT_CINEMASPOT

## Simple too to convert cinema_spot markers with the actual cinemaspots

@export var simulate := true					## Dont change anything, just check if everything is working fine
@export var start_conversion 	:= false :		## Start the conversion process.
	set(b):
		lets_goooo()

func _ready() -> void:
	if not Engine.is_editor_hint():
		push_error( "B2_TOOL_CONVERT_CINEMASPOT still exists on the %s node." % get_parent().name )

func lets_goooo():
	print("starting...")
	var cinemaspots 		:= Array()
	var cinemaspotnames 	:= Array()
	var duplicate			:= false
	var tree_nodes = get_parent().get_children()
	print( "%s children total." % tree_nodes.size() )
	for n in tree_nodes:
		if n is Marker2D: # mess with markers only.
			var n_name : String = n.name.split(" - ", false, 1)[ 1 ] # split the name, get the second half. ex.: "P131 - o_cinema4" -> "o_cinema4"
			if n_name.begins_with("o_cinema"):
				if cinemaspotnames.has(n_name):
					duplicate = true
				cinemaspots.append(n)
				cinemaspotnames.append(n_name)
	
	if simulate:
		print("Simulation: Found %s cinema markers. Duplicate state is %s. Quitting." % [ str(cinemaspots.size()), str(duplicate) ] )
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
		
