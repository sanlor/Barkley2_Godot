#@icon("res://barkley2/assets/b2_original/images/merged/icon_parent.png")
@icon("res://barkley2/assets/b2_original/images/merged/icon_camera.png")
extends CanvasLayer
class_name B2_Cinema

## Check Cinema() script. Cinema("run", script_start) is also important

## DEBUG
@export_category("Debug Stuff")
@export var debug_goto		 	:= false
@export var debug_comments 		:= false
@export var debug_dialog 		:= false
@export var debug_wait 			:= false
@export var debug_fade 			:= false
@export var debug_sound 		:= false
@export var debug_set 			:= false
@export var debug_moveto 		:= false
@export var debug_quest 		:= false
@export var debug_look	 		:= false
@export var debug_lookat 		:= false
@export var debug_event 		:= false
@export var debug_unhandled 	:= false
@export var print_comments		:= false
@export var print_line_report 	:= false ## details about the current script line.

@export_category("Cinema Config")
@export var async_camera_move 	:= false ## Script does not wait for the movement to finish if this is enabled.
@export var async_actor_move	:= false ## Script does not wait for the movement to finish if this is enabled.

@export_category("Cinema Setup")
@export var cutscene_script : B2_Script

signal created_new_fade

# used for the "CREATE" event
## NOTE need a dynamic way to load these.
var object_map := {
	"o_tutorial_popups01" : preload("res://barkley2/scenes/Objects/_interactiveActor/_tutorial/_tutorial/o_tutorial_popups01.tscn"),
}

const O_CTS_HOOPZ 	= preload("res://barkley2/scenes/Player/o_cts_hoopz.tscn")
const O_HOOPZ 		= preload("res://barkley2/scenes/Player/o_hoopz.tscn")

# Loaded actors, part of the original scr_event_hoopz_switch_cutscene() script.
var o_cts_hoopz 	: B2_Actor 			= null
var o_hoopz 		: CharacterBody2D 	= null ## TODO Create a B2_CombatActor class

@export var camera				: Camera2D
var all_nodes					:= []

## Children process
var dslCinKid := []

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
	#  Cinema() else if (argument[0] == "exit")
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
	
	## NOTE Below is trash. needs improving.
	camera.set_safety( true )
	camera.follow_mouse = true
	o_hoopz.follow_mouse = true
	
func play_cutscene():
	load_hoopz()
	camera.set_safety( false )
	camera.follow_mouse = false
	
	all_nodes = get_parent().get_children()
	
	# This is the script parser. It parsers scripts.
	# Basically this emulates the Cinema("run") and Cinema("process").
	if cutscene_script is B2_Script_Legacy:
		print_rich("[color=pink]Started Cinema() Script at %s msecs.[/color]" % Time.get_ticks_msec() )
		# Split the script into separate lines
		var split_script 	: PackedStringArray = cutscene_script.original_script.split( "\n", false )
		var script_size 	:= split_script.size()
		var curr_line 		:= 0
		var loop_finished 	:= true
		
		#for line : String in split_script:
		while loop_finished or curr_line == script_size:
			
			var line : String = split_script[ curr_line ]
			
			if line.begins_with('"'):
				# skip legacy "stuff"
				# Jump to next line
				curr_line += 1
				continue
				
			if line.begins_with("//"):
				if print_comments:
					print_rich( str(curr_line) + ": [color=yellow]" + line + "[/color]" )
				# Jump to next line
				curr_line += 1
				continue
			
			var parsed_line : PackedStringArray = cleanup_line( line )
				
			# Check for conditions.
			if parsed_line[0].begins_with("IF"):
				
				if parse_if( parsed_line[0] ):
					# remove the IF command
					parsed_line.remove_at( 0 )
				else:
					curr_line += 1
					print("IF: Condition failed. cool. hope this is expected. -> " + parsed_line[0])
					continue
				
			match parsed_line[0]:
				"GOTO":
					# loop the whole script trying to find the "label".
					var target_label : String = parsed_line[1] ## 1 is WRONG!
					var found_label := false
					for j in script_size:
						var new_line : String = split_script[ j ]
						var possible_label : String = cleanup_line( new_line ) [0] # Labels are always on the front
						if target_label == possible_label:
							# found the "label". jump to that line
							curr_line = j # REMEMBER: Empty lines are skipped.
							found_label = true
							if debug_goto: print_rich("[color=green]Goto: line ", curr_line, " - ", target_label, "[/color]" )
							break
						
					if not found_label:
						# "label" not found. push error
						push_error("GOTO: label " + target_label + " not found.")
					
				"REPLY":
					if debug_unhandled: print( "Unhandled mode: ", parsed_line )
				"CHOICE":
					if debug_unhandled: print( "Unhandled mode: ", parsed_line )
				"WAIT":
					## Holy shit. it took me 3 months to figure this out. WAIT | 0 sets the Async actions. I think...
					# check Cinema()
					# check o_wait
					if float( parsed_line[1] ) <= 0.0:
						# wait for the childrens movement to finish
						if debug_wait: print( "Wait: KID WAIT : %s nodes." % dslCinKid.size()  )
						# So, if wait is 0, then we sould wait for any pending actions to finish
						# cinema_kids() check the dslCinKid array and returns when all actions are finished.
						# This... THIS TOOK 3 WEEKS TO FIGURE OUT. Goddamit.
						await cinema_kids()
						#await get_tree().create_timer( 1.0 ).timeout
						if debug_wait: print( "Wait: KID WAIT Finished" )
					else:
						await get_tree().create_timer( float( parsed_line[1] ) ).timeout
						#await get_tree().process_frame
						if debug_wait: print("Wait: ", float( parsed_line[1] ) )
				"EXIT":
					print("EXIT")
					loop_finished = true
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
					if debug_set: print("SET: ", parsed_line[1], " - ", str(parsed_line[ 2 ]) )
				"QUEST":
					# this is confusing. This can set quest states, change states, like quest += 1 and fuck arounf with monei and time. weird
					var quest_stuff := parsed_line[ 1 ].split(" ", false)
					var qstNam = quest_stuff[0]
					var qstTyp = quest_stuff[1]
					var qstVal = quest_stuff[2]
					
					if qstVal.contains("@"): ## Not sure how this is used.
						# if (string_pos("@", qstVal) > 0) qstVal = Cinema("parse", qstVal);
						breakpoint
					else:
						qstVal = float( qstVal )
						
					if qstTyp == "+=":
						B2_Playerdata.Quest(qstNam, B2_Playerdata.get_quest_state(qstNam) + qstVal )
					elif qstTyp == "-=":
						B2_Playerdata.Quest(qstNam, B2_Playerdata.get_quest_state(qstNam) - qstVal )
					else:
						B2_Playerdata.Quest(qstNam, float(qstVal) )
					
					if debug_quest: print( "Quest: ", quest_stuff )
				"BREAKOUT":
					if debug_unhandled: print( "Unhandled mode: ", parsed_line )
				"FADE":
					# check scr_event_fade()
					# parsed_line[ 1 ] is type: 		// 1 is fade in, 0 is fade out. Fade in is black to transparent.
					# parsed_line[ 2 ] is seconds: 		// 1 second fade duration
					# parsed_line[ 3 ] is depth, but i this this is disabled. //depth for o_hud is -2510000 //Removed, should always be over hud?
					var o_fade : ColorRect = load("res://barkley2/scenes/_event/o_fade.tscn").instantiate()
					created_new_fade.emit()
					if parsed_line.size() == 2:
						o_fade._fade 		= float( parsed_line[ 1 ] )
					elif parsed_line.size() == 3:
						o_fade._fade 		= float( parsed_line[ 1 ] )
						o_fade._seconds 	= float( parsed_line[ 2 ] )
					elif parsed_line.size() == 3:
						o_fade._fade 		= float( parsed_line[ 1 ] )
						o_fade._seconds 	= float( parsed_line[ 2 ] )
						o_fade.z_index 		= int( parsed_line[ 3 ] ) # i think this is disabled on the original code.
					else:
						# weird amount of arguments
						breakpoint
					o_fade._event = self # used to listen to signals. _event should never be null
					
					add_child( o_fade, true )
					if debug_fade: 
						print( "Fade: ", str(curr_line), " - ", parsed_line )
				"SOUND":
					if parsed_line.size() > 2:
						# Loops
						B2_Sound.play( parsed_line[1], 0.0, false, int( parsed_line[2] ) )
						if debug_sound: print(parsed_line[1], " with %s loops" % parsed_line[2])
					else:
						B2_Sound.play( parsed_line[1], 0.0, false )
						if debug_sound: print(parsed_line[1])
				"EVENT":
					# now, this is what i call JaNkYH! Basically, it looks for all loaded objects withe the name "parsed_line[1]" and runs the "User Defined" function "parsed_line[2]"
					# thing is, how the fuck im going to make this work on godot? I cant change the original script.
					# basically, this just executes funciones on the fly.
					var event_object : Node = get_node_from_name(all_nodes, parsed_line[1])
					if event_object != null:
						if not event_object.has_method("execute_event_user_" + parsed_line[2]):
							# node has no execute_event_user_n method. remember to add it
							push_error( "Node %s has no execute_event_user_%s method. remember to add it" % [parsed_line[1],parsed_line[2]] )
						else:
							event_object.call( "execute_event_user_" + parsed_line[2] )
					else:
						push_warning("EVENT at line " + str(curr_line) + ": " + parsed_line[1] + " not found.")
					
					if debug_event: 
						print( "Executed EVENT: ", parsed_line )
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
						var speed 					= parsed_line[1]
						camera.cinema_moveto( move_array, speed )		## Async movement 
						cinema_kid( camera )
						
					else:
						if debug_moveto: print("FRAME: destination_object is invalid: ", move_array )
				"LOOKAT":
					if debug_unhandled: print( "Unhandled mode: ", parsed_line )
				"LOOK":
					## NOTE Im not sure if this is working
					var actor 					= get_node_from_name( all_nodes,	parsed_line[1] )
					actor.cinema_look( parsed_line[2] )
				"MOVETO":
					# oh, what the fuck. The original game has pathfinding in the movement system.
					# check scr_event_action_move_to_point and o_move.
					# fuck. also check scr_path_set, scr_path_delete, scr_path_update. fuck fuck, this is way more complicated.
					## TODO implement Astar2DGrid on the root node or a standalone class.
					
					var actor 					= get_node_from_name( all_nodes,	parsed_line[1] )
					var destination_object 		= get_node_from_name( all_nodes, 	parsed_line[2] )
					# Make sure that the actors and cinemaspots exists
					if actor != null:
						if destination_object != null:
							var speed 					= parsed_line[3]
							actor.cinema_moveto( destination_object, speed ) 		## Async movement
							cinema_kid( actor )
						else:
							if debug_moveto: print("MOVETO: destination_object is invalid: ",parsed_line[2])
					else:
						if debug_moveto: print("MOVETO: actor is invalid: ",parsed_line[1])
						
					if debug_moveto: print("MOVETO: ", parsed_line[1], " - ", parsed_line[2] )
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
			
			# Jump to next line
			curr_line += 1
			
			if print_line_report:
				print( str(curr_line), " - ", parsed_line )
			
		print( "Finished Animation" )
		end_cutscene()

# add a node to the array.
# This is used to keep track of actor movement, to wait for something to finish before starting another.
func cinema_kid( kid : Node2D ) -> void:
	dslCinKid.append(kid)
	
# Wait for every child action to finish, them clear the queue
func cinema_kids() -> void:
	for i in dslCinKid:
		await i.check_actor_activity()
	dslCinKid.clear()
	return

func cleanup_line( line : String ) -> PackedStringArray:
	var parsed_line : PackedStringArray = line.split( "|", false )
	# Cleanup
	for i in range( parsed_line.size() ):
		parsed_line[i] = parsed_line[i].strip_edges( true, true )
		parsed_line[i] = parsed_line[i].split("//", false, 1)[0] ## Strip comments
	return parsed_line

func parse_if( line : String ) -> bool:
	# clean the conditions
	var condidion_line : PackedStringArray = line.split( " ", false )
	
	var str_var 	: String 		= condidion_line[ 1 ] # 0 is the IF
	var comparator 	: String 		= condidion_line[ 2 ]
	var cond_value 	: int 			= int( condidion_line[ 3 ] )
	
	# this should return false (if quest var is invalid) or some value.
	var quest_var = B2_Playerdata.Quest( str_var, null )
	if not quest_var is bool:
		match comparator:
			"==":
				return quest_var == cond_value
			"!=":
				return quest_var != cond_value
			">=":
				return quest_var >= cond_value
			"<=":
				return quest_var <= cond_value
			_:
				push_error("Unknown operation ", comparator)
				return false
	else:
		return false
	
func Cinema_run():
	pass
func Cinema_process():
	pass
func get_node_from_name( _array, _name ) -> Node:
	var node : Node
	for item in _array:
		if item is Node:
			if item.name == _name:
				node = item
	return node
	
func Misc( parsed_line :PackedStringArray ):
	# Check Misc() script.
	var misc_arguments := parsed_line.size() - 2
	# print("Misc: %s arguments." % str(misc_arguments) )
	
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
	# print("Camera: %s arguments." % str(misc_arguments) )
	
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
		if object_map[ parsed_line[1] ] == null:
			push_error("object " + parsed_line[1] + " is null. fix this.")
			return
		
		var obj_scene : PackedScene = object_map[ parsed_line[1] ]
		#var object : Node2D = obj_scene.instantiate() # can also be a Canvas Layer
		var object = obj_scene.instantiate()
		if object is Node2D or object is Control:
			if misc_arguments > 1:
				object.position.x = float( parsed_line[2] )
			if misc_arguments > 2:
				object.position.y = float( parsed_line[3] )
		add_sibling( object )
	else:
		push_error("object %s not in object_map dictionary. you dun goofed." % str( parsed_line[1] ) )
