#@icon("res://barkley2/assets/b2_original/images/merged/icon_parent.png")
@icon("res://barkley2/assets/b2_original/images/merged/icon_camera.png")
extends CanvasLayer
class_name B2_Cinema

## Check Cinema() script. Cinema("run", script_start) is also important

## DEBUG
@export var debug_comments 		:= false
@export var debug_dialog 		:= false
@export var debug_wait 			:= false
@export var debug_sound 		:= false
@export var debug_moveto 		:= false
@export var debug_unhandled 	:= false

@export var cutscene_script : B2_Script

# used for the "CREATE" event
var object_map := {
	"o_tutorial_popups01" : null,
}

const O_CTS_HOOPZ 	= preload("res://barkley2/scenes/Player/o_cts_hoopz.tscn")
const O_HOOPZ 		= preload("res://barkley2/scenes/Player/o_hoopz.tscn")

# Loaded actors, part of the original scr_event_hoopz_switch_cutscene() script.
var o_cts_hoopz 	: B2_Actor 			= null
var o_hoopz 		: CharacterBody2D 	= null ## TODO Create a B2_CombatActor class

@export var camera				: Camera2D
var all_nodes					:= []

func _ready() -> void:
	pass
	
func load_hoopz():
	# if real is loaded, load fake hoopz.
	o_cts_hoopz = O_CTS_HOOPZ.instantiate()
	if is_instance_valid(o_hoopz):
		o_cts_hoopz.position = o_hoopz.position
		o_hoopz.queue_free()
	add_sibling(o_cts_hoopz, true)
	print("o_cts_hoopz loaded.")
	
func end_cutscene():
	# if fake is loaded, load real hoopz.
	o_hoopz = O_HOOPZ.instantiate()
	if is_instance_valid(o_hoopz):
		o_hoopz.position = o_cts_hoopz.position
		o_cts_hoopz.queue_free()
	add_sibling(o_hoopz, true)
	print("o_hoopz loaded.")
	
	all_nodes.clear()
	all_nodes = get_parent().get_children()
	
	#await camera.cinema_moveto( [ o_hoopz ], "CAMERA_NORMAL" )
	camera.follow_player( o_hoopz )
	
func play_cutscene():
	load_hoopz()
	all_nodes = get_parent().get_children()
	
	if cutscene_script is B2_Script_Legacy:
		# Split the script into separate lines
		var split_script : PackedStringArray = cutscene_script.original_script.split( "\n", false )
		
		for line : String in split_script:
			var parsed_line : PackedStringArray = line.split( "|", false )
			
			# Cleanup
			for i in range( parsed_line.size() ):
				parsed_line[i] = parsed_line[i].strip_edges( true, true )
				parsed_line[i] = parsed_line[i].split("//", false, 1)[0] ## Strip comments
			match parsed_line[0]:
				"REPLY":
					if debug_unhandled: print( "Unhandled mode: ", parsed_line )
				"CHOICE":
					if debug_unhandled: print( "Unhandled mode: ", parsed_line )
				"WAIT":
					await get_tree().create_timer( float( parsed_line[1] ) ).timeout
					if debug_wait: print("Wait: ", float( parsed_line[1] ) )
				"EXIT":
					print("EXIT")
					break # exit the loop
				"DIALOG", "MYSTERY":
					if debug_dialog: print( parsed_line[1], " ", parsed_line[2])
					var dialogue := B2_Dialogue.new()
					add_child(dialogue)
					# parse talker´s name
					if parsed_line[1].contains("="):
						var talker_split = parsed_line[1].split("=")
						var talker_name := talker_split[0].strip_edges(true,true)
						var talker_port := talker_split[1].strip_edges(true,true)
						dialogue.set_portrait(talker_port, false)
						dialogue.set_text( parsed_line[2].strip_edges(true,true), talker_name )
					else:
						dialogue.set_portrait( parsed_line[1].strip_edges(true,true), true )
						dialogue.set_text( parsed_line[2].strip_edges(true,true) )
						
					await dialogue.display_dialog()
					dialogue.queue_free()
				"SHAKE":
					if debug_unhandled: print( "Unhandled mode: ", parsed_line )
				"ITEM":
					if debug_unhandled: print( "Unhandled mode: ", parsed_line )
				"NOTIFY":
					if debug_unhandled: print( "Unhandled mode: ", parsed_line )
				"NOTIFYALT":
					if debug_unhandled: print( "Unhandled mode: ", parsed_line )
				"PLAYSET":
					var actor = get_node_from_name( all_nodes, parsed_line[ 1 ] )
					actor.cinema_playset( str(parsed_line[ 2 ]), str(parsed_line[ 3 ]) )
					
				"SET":
					var actor = get_node_from_name( all_nodes, parsed_line[ 1 ] )
					actor.cinema_set( str(parsed_line[ 2 ]) )
				"GOTO":
					if debug_unhandled: print( "Unhandled mode: ", parsed_line )
				"QUEST":
					if debug_unhandled: print( "Unhandled mode: ", parsed_line )
				"BREAKOUT":
					if debug_unhandled: print( "Unhandled mode: ", parsed_line )
				"FADE":
					if debug_unhandled: print( "Unhandled mode: ", parsed_line )
				"SOUND":
					if parsed_line.size() > 2:
						# Loops
						B2_Sound.play( parsed_line[1], 0.0, false, int( parsed_line[2] ) )
						if debug_sound: print(parsed_line[1], " with %s loops" % parsed_line[2])
					else:
						B2_Sound.play( parsed_line[1], 0.0, false )
						if debug_sound: print(parsed_line[1])
				"EVENT":
					if debug_unhandled: print( "Unhandled mode: ", parsed_line )
				"NOTE":
					if debug_unhandled: print( "Unhandled mode: ", parsed_line )
				"SHOP":
					if debug_unhandled: print( "Unhandled mode: ", parsed_line )
				"LOCKPICK":
					if debug_unhandled: print( "Unhandled mode: ", parsed_line )
				"CHATROULETTE":
					if debug_unhandled: print( "Unhandled mode: ", parsed_line )
				"CREATE":
					if debug_unhandled: print( "Unhandled mode: ", parsed_line )
				"CREATE_WAIT":
					if debug_unhandled: print( "Unhandled mode: ", parsed_line )
				"FRAME":
					var move_points := parsed_line.size() - 2 # first 2 are the action and speed.
					var move_array : Array[Node2D] = []
					
					for point in move_points:
						var dest := get_node_from_name( all_nodes, parsed_line[ 2 + point ] )
						if dest == null:
							if debug_moveto: print("FRAME: destination_object is invalid: ", dest, " - ", parsed_line[ 2 + point ] )
						move_array.append( dest )
					
					if not move_array.is_empty():
						# if debug_moveto: print("FRAME: destination_object is valid: ", move_array )
						var speed 					= parsed_line[1]
						await camera.cinema_moveto( move_array, speed )
					else:
						if debug_moveto: print("FRAME: destination_object is invalid: ", move_array )
				"LOOKAT":
					if debug_unhandled: print( "Unhandled mode: ", parsed_line )
				"LOOK":
					if debug_unhandled: print( "Unhandled mode: ", parsed_line )
				"MOVETO":
					var actor 					= get_node_from_name( all_nodes,	parsed_line[1] )
					var destination_object 		= get_node_from_name( all_nodes, 	parsed_line[2] )
					# Make sure that the actors and cinemaspots exists
					if actor != null:
						# if debug_moveto: print("MOVETO: actor is valid: ",parsed_line[1])
						if destination_object != null:
							# if debug_moveto: print("MOVETO: destination_object is valid: ",parsed_line[2])
							var speed 					= parsed_line[3]
							await actor.cinema_moveto( destination_object, speed )
						else:
							if debug_moveto: print("MOVETO: destination_object is invalid: ",parsed_line[2])
					else:
						if debug_moveto: print("MOVETO: actor is invalid: ",parsed_line[1])
				"MOVE":
					if debug_unhandled: print( "Unhandled mode: ", parsed_line )
					
				## B2 has some stupid ACE script execution
				# Check Cinema() line 588
				"Misc":
					Misc( parsed_line )
				"Camera":
					Camera( parsed_line )
				"Create":
					Create( parsed_line )
				_:
					if debug_unhandled: print( "Unhandled text: ", parsed_line[0] )
		
		print( "Finished Animation" )
		end_cutscene()

func get_node_from_name( _array, _name ) -> Node2D:
	var node : Node2D
	for item in _array:
		if item is Node2D:
			if item.name == _name:
				node = item
	return node
	
func Misc( parsed_line :PackedStringArray ):
	# Check Misc() script.
	var misc_arguments := parsed_line.size() - 2
	print("Misc: %s arguments." % str(misc_arguments) )
	
	match parsed_line[1]:
		"set": ## 1 = object | 2 = object / x | 3 = y
			var obj1 = get_node_from_name( all_nodes, str(parsed_line[2]) )
			var obj2 = get_node_from_name( all_nodes, str(parsed_line[3]) )
			if all_nodes.has(obj1):
				if all_nodes.has(obj2):
					obj1.position = obj2.position
				else:
					push_error("obj2 invalid: ", obj2)
			else:
				push_error("obj1 invalid: ", obj1)
		"shadow":
			pass
		"visible":
			pass
		"entity settings":
			pass
		"music":
			pass
		"automatic animation":
			pass
		"flip":
			pass
		"flipx": ## Special case for walking interactive actors
			pass
		"alpha": ## 1 = object | 2 = alpha | 3 = time
			pass
		"backwards":
			pass
		"dialogY":
			pass
		"dnaCyber":
			pass
		"manchurian":
			pass
		_:
			print("Misc() - GOOFED! Unknown command > " + str(parsed_line[1]) + " <")
	
func Camera( parsed_line : PackedStringArray ):
	# Check Camera() script
	var misc_arguments := parsed_line.size() - 2
	print("Camera: %s arguments." % str(misc_arguments) )
	
	match parsed_line[1]:
		## Camera("enable", camera)
		"enable":
			pass
		## Creates a new camera to be used. Initially disabled.
		## Objects must have camera_target_x, camera_target_y, camera_speed
		## Camera("create", x, y, object_to_follow)
		"create":
			pass
		## Camera("transition", new_camera)
		"transition":
			pass
		## Camera("snap", object) - Instantly moves camera to spot
		## Camera("snap", x, y) - Instantly moves camera to spot
		"snap":
			pass
		## Deletes other camera move events
		## Camera("safe check")
		"safe check":
			pass
		_:
			print("Camera() - Unknown command >" + str( parsed_line[1] ) + "<")
		
func Create( parsed_line : PackedStringArray ):
	# Check Create() script
	var misc_arguments := parsed_line.size() - 2
	print("Create: %s arguments." % str(misc_arguments) )
	
	if object_map.has( parsed_line[1] ):
		var obj_scene : PackedScene = object_map[ parsed_line[1] ]
		var object : Node2D = obj_scene.instantiate()
		if misc_arguments > 1:
			object.position.x = float( parsed_line[2] )
		if misc_arguments > 2:
			object.position.y = float( parsed_line[3] )
		add_sibling( object )
	else:
		push_error("object %s not in object_map dictionary. you dun goofed." % str( parsed_line[1] ) )
