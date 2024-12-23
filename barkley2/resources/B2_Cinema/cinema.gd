@icon("res://barkley2/assets/b2_original/images/merged/icon_camera.png")
extends CanvasLayer
class_name B2_CinemaPlayer

## Check Cinema() script. Cinema("run", script_start) is also important
## NOTE This node is resposible for Conversations, Dialog Tree, Cinematics, Events and Coronavirus.
# 07-10-24 Its now an Autoload.
# 12-10-24 Now its not. CManager is the autoload now.

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
@export var debug_breakout		:= true
@export var debug_unhandled 	:= true
@export var print_comments		:= false
@export var print_line_report 	:= false ## details about the current script line.

@export_category("Cinema Config")
@export var async_camera_move 	:= false ## Script does not wait for the movement to finish if this is enabled.
@export var async_actor_move	:= false ## Script does not wait for the movement to finish if this is enabled.

signal created_new_fade
signal set_interactivity(enabled : bool)

#signal event_started
#signal event_ended

# used for the "CREATE" event
## NOTE need a dynamic way to load these.
var object_map := {
	"o_tutorial_popups01" : 	preload("res://barkley2/scenes/Objects/_interactiveActor/_tutorial/_tutorial/o_tutorial_popups01.tscn"),
	"oBossName" : 				preload("res://barkley2/scenes/Objects/System/o_boss_name.tscn"),
	"o_hoopz_black":			preload("res://barkley2/scenes/Objects/_cutscenes/_sceneBranding/o_hoopz_black.tscn"),
}

var event_caller	: Node2D ## The node that called the play_cutscene() function.

var camera						: Camera2D
var all_nodes					:= []
var array_dirty					:= false

#var room := ""

## Children process
var dslCinKid := []

## Breakout stuff
var show_breakout := false
var breakout_data := {
	"value" 		: "money", # what is shown in the breakbox
	"prev_value" 	: 0, # what is shown in the breakbox
}

func _ready() -> void:
	pass
	
func setup_camera( _camera : Camera2D ):
	camera = _camera

func get_camera_on_tree() -> Camera2D:
	var nodes_in_tree = get_tree().current_scene.get_children() ## get all siblings.
	for c in nodes_in_tree:
		if c is Camera2D:
			return c
			
	# No camera loaded. Create a new one
	var _cam := B2_Camera_Hoopz.new()
	# set its initial position
	if is_instance_valid(B2_CManager.o_hoopz):
		_cam.position = B2_CManager.o_hoopz.position
	elif is_instance_valid(B2_CManager.o_cts_hoopz):
		_cam.position = B2_CManager.o_cts_hoopz.position
	else:
		_cam.position.x = B2_RoomXY.this_room_x
		_cam.position.y = B2_RoomXY.this_room_y
	
	get_tree().current_scene.add_child( _cam )
	return _cam
	
func update_pathfinding():
	var room_node = get_parent()
	if room_node is B2_ROOMS:
		room_node.update_pathfind()
	else:
		push_warning("Who am I...? what am I...? (Meaning, the Cinema node is not where its suposed to be. Cant update pathfinding.)")
	
func load_hoopz_actor():
	var hoopz_lookup := get_tree().current_scene.get_children()
	for n in hoopz_lookup:
		if n.name == "o_hoopz":
			n.queue_free()
	# if real is loaded, load fake hoopz.
	if not is_instance_valid(B2_CManager.o_cts_hoopz): 
		B2_CManager.o_cts_hoopz = B2_CManager.o_cts_hoopz_scene.instantiate()
		
	if is_instance_valid(B2_CManager.o_hoopz):
		B2_CManager.o_cts_hoopz.position 	= B2_CManager.o_hoopz.position
		B2_CManager.o_hoopz.queue_free()
	else:
		B2_CManager.o_cts_hoopz.position.x 	= B2_RoomXY.this_room_x
		B2_CManager.o_cts_hoopz.position.y 	= B2_RoomXY.this_room_y
	
	get_tree().current_scene.add_child( B2_CManager.o_cts_hoopz, true )
	
	# make the actor face the event_object
	var _dir := B2_CManager.o_cts_hoopz.position.direction_to( event_caller.position ).round() as Vector2
	match _dir: # Its messy, but it works.
		Vector2.UP + Vector2.LEFT:		B2_CManager.o_cts_hoopz.cinema_look( "NORTHWEST" )
		Vector2.UP + Vector2.RIGHT: 	B2_CManager.o_cts_hoopz.cinema_look( "NORTHEAST" )
		Vector2.DOWN + Vector2.LEFT: 	B2_CManager.o_cts_hoopz.cinema_look( "SOUTHWEST" )
		Vector2.DOWN + Vector2.RIGHT: 	B2_CManager.o_cts_hoopz.cinema_look( "SOUTHEAST" )

		Vector2.UP: 		B2_CManager.o_cts_hoopz.cinema_look( "NORTH" )
		Vector2.LEFT: 		B2_CManager.o_cts_hoopz.cinema_look( "WEST" )
		Vector2.DOWN: 		B2_CManager.o_cts_hoopz.cinema_look( "SOUTH" )
		Vector2.RIGHT: 		B2_CManager.o_cts_hoopz.cinema_look( "EAST" )
	
func load_hoopz_player(): #  Cinema() else if (argument[0] == "exit")
	var hoopz_lookup := get_tree().current_scene.get_children()
	for n in hoopz_lookup:
		if n.name == "o_cts_hoopz":
			n.queue_free()
			
	# if fake is loaded, load real hoopz.
	if not is_instance_valid(B2_CManager.o_hoopz):
		B2_CManager.o_hoopz = B2_CManager.o_hoopz_scene.instantiate() as B2_Player
		
	if is_instance_valid(B2_CManager.o_cts_hoopz):
		B2_CManager.o_hoopz.position = B2_CManager.o_cts_hoopz.position
		B2_CManager.o_cts_hoopz.queue_free()
	else:
		B2_CManager.o_hoopz.position.x = B2_RoomXY.this_room_x
		B2_CManager.o_hoopz.position.y = B2_RoomXY.this_room_y
		
	get_tree().current_scene.add_child( B2_CManager.o_hoopz, true )
	
func end_cutscene():
	await get_tree().process_frame
	load_hoopz_player()
		
	all_nodes.clear()
	
	## Release player lock
	B2_Input.cutscene_is_playing 	= false
	B2_Input.can_fast_forward 		= false
	B2_Input.player_has_control 	= true
	
	print_rich("[color=pink]Finished Cinema() Script.[/color]")
	
	## NOTE Below is trash. needs improving.
	camera.set_safety( true )
	camera.follow_player( B2_CManager.o_hoopz )
	B2_Input.player_follow_mouse.emit( true )
	B2_Input.camera_follow_mouse.emit( true )
	
	# actors may moved during the cutscene, update the PF.
	update_pathfinding()
	if is_instance_valid(B2_CManager.o_hud):
		B2_CManager.o_hud.show_hud()
	
	B2_CManager.event_ended.emit() # Peace out.
	queue_free()
	
func apply_cutscene_mask( cutscene_script : B2_Script, cutscene_mask : Array ):
	if cutscene_script is B2_Script_Legacy:
		for m : B2_Script_Mask in cutscene_mask:
			cutscene_script.original_script = cutscene_script.original_script.replace( m.target_string, m.desired_string )
			print("Replaced ", m.target_string, " with ", m.desired_string)
	else:
		push_error("Mask not applied.")
	pass
	
func play_cutscene( cutscene_script : B2_Script, _event_caller : Node2D, cutscene_mask = [] ) -> bool:
	if not is_instance_valid(camera):
		camera = get_camera_on_tree()
		
	assert(camera != null, "Camera not setup. Fix it.")
	assert(cutscene_mask is Array, "Whops, outdate node called the cinema function wrong.")
	## Apply mask, to replace string from the cutscene.
	if not cutscene_mask.is_empty():
		apply_cutscene_mask( cutscene_script, cutscene_mask )
		
	#print(cutscene_script.original_script)
	event_caller = _event_caller
	B2_Screen.set_cursor_type( B2_Screen.TYPE.POINT )
	
	## lock player control
	B2_Input.cutscene_is_playing 	= true
	B2_Input.can_fast_forward 		= true
	B2_Input.player_has_control 	= false
	
	B2_Input.player_follow_mouse.emit( false )
	B2_Input.camera_follow_mouse.emit( false )
	
	B2_CManager.event_started.emit()
	
	camera.set_safety( false )
	
	# Chill out. Avoid loading invalid nodes.
	await get_tree().process_frame
	
	load_hoopz_actor()
	
	#room = B2_RoomXY.get_current_room()
	all_nodes = get_all_nodes()
	
	# Frame Camera
	var init_frame_target : Vector2 = B2_CManager.o_cts_hoopz.position # _event_caller.position
	#if frame_await:
		#await camera.cinema_frame( 	init_frame_target, "CAMERA_SLOW" ) 	# sync movement
	#else:
		#camera.cinema_frame( 		init_frame_target, "CAMERA_SLOW" ) 	# async movement
	camera.follow_actor( [ B2_CManager.o_cts_hoopz ], "CAMERA_NORMAL" )
	
	# this should be here?
	update_pathfinding()
	if is_instance_valid(B2_CManager.o_hud):
		B2_CManager.o_hud.hide_hud()
	
	# This is the script parser. It parsers scripts.
	# Basically this emulates the Cinema("run") and Cinema("process").
	if cutscene_script is B2_Script_Legacy:
		print_rich("[color=pink]Started Cinema() Script.[/color]")
		# Split the script into separate lines
		var split_script 	: PackedStringArray = cutscene_script.original_script.split( "\n", true )
		var script_size 	:= split_script.size()
		var curr_line 		:= 0
		var loop_finished 	:= true
		
		## Data for CHOICE and REPLY
		var last_talker_portrait			:= ""
		var is_selecting_choices 			:= false
		var choice_question					:= ""
		var choices_labels					:= []
		var choices_strings					:= []
		
		#for line : String in split_script:
		while loop_finished or curr_line == script_size:
			if curr_line >= script_size:
				# push_warning("Cinema script exited unexpectedly. It should always finish with the EXIT command.")
				loop_finished = true
				break # exit the loop
				
			var line : String = split_script[ curr_line ]
			
			if line.is_empty():
				#push_warning("Empty line. I THINK this means end of event.")
				## ^^^^ Yes, it is.
				## ^^^^ No its not always, smartass. CHOICE and REPLY expect the empty line no show the question.
				if is_selecting_choices:
					var dialogue_choice = B2_DialogueChoice.new()
					add_child( dialogue_choice )
					var choice_portrait = "Mysteriouse Youngster" ## last_talker_portrait  ## DEBUG
					
					dialogue_choice.set_portrait( choice_portrait ) ## Is this correct? Is the protrait always hoopz?
					dialogue_choice.set_title( choice_question ) ## Add the question itself
					for question : String in choices_strings:
						dialogue_choice.add_choice( question ) ## Add choices
					dialogue_choice.display_choices()
					var choice_selected : int = await dialogue_choice.choice_selected
					
					# override LINE
					line = "GOTO | %s" % str( choices_labels[ choice_selected ] )
					
					## Cleanup.
					last_talker_portrait			= ""
					is_selecting_choices 			= false
					choice_question					= ""
					choices_labels					= []
					choices_strings					= []
				else:
					loop_finished = true
					break # exit the loop
			
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
						if new_line.is_empty():
							## Empty line, carry on.
							continue
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
					choices_labels.append( 	parsed_line[1].strip_edges(true,true) )
					choices_strings.append( parsed_line[2].strip_edges(true,true) )
				"CHOICE":
					is_selecting_choices = true
					choice_question = parsed_line[1].strip_edges(true,true) as String
				"WAIT":
					## Holy shit. it took me 3 months to figure this out. WAIT | 0 sets the Async actions. I think...
					# check Cinema()
					# check o_wait
					## Goddamit wilmer! sometimes "wait" doesnt have a time attached. assume it means 0.0
					if parsed_line.size() > 1:
						if float( parsed_line[1] ) <= 0.0:
							# wait for the childrens movement to finish
							if debug_wait: print( "Wait: KID WAIT : %s nodes." % dslCinKid.size()  )
							# So, if wait is 0, then we sould wait for any pending actions to finish
							# cinema_kids() check the dslCinKid array and returns when all actions are finished.
							# This... THIS TOOK 3 WEEKS TO FIGURE OUT. Goddamit.
							await cinema_kids()
							if debug_wait: print( "Wait: KID WAIT Finished" )
						else:
							await get_tree().create_timer( float( parsed_line[1] ) ).timeout
							#await get_tree().process_frame
							if debug_wait: print("Wait: ", float( parsed_line[1] ) )
					else:
						# same as "if float( parsed_line[1] ) <= 0.0:"
						if debug_wait: print( "Wait: KID WAIT : %s nodes." % dslCinKid.size()  )
						await cinema_kids()
						if debug_wait: print( "Wait: KID WAIT Finished" )
				"EXIT":
					print("EXIT at line %s." % curr_line)
					loop_finished = true
					break # exit the loop
				"DIALOG", "MYSTERY":
					if debug_dialog: print( parsed_line[1], " ", parsed_line[2])
					var dialogue := B2_Dialogue.new()
					add_child( dialogue, true )
					# parse talker´s name
					if parsed_line[1].contains("="):
						var talker_split = parsed_line[1].split("=")
						var talker_name := Text.pr( talker_split[0].strip_edges(true,true) )
						var talker_port := talker_split[1].strip_edges(true,true)
						if talker_port == "P_NAME": talker_port = "s_port_hoopz" ## TEMP HACK
						dialogue.set_portrait(talker_port, false)
						# Set the dialogue, with the variable injection
						dialogue.set_text( Text.qst( parsed_line[2].strip_edges(true,true) ), talker_name )
						last_talker_portrait = talker_port
					else:
						var talker_port := parsed_line[1].strip_edges(true,true)
	
						if B2_Gamedata.portrait_from_name.has( talker_port ):
							dialogue.set_portrait( talker_port, true )
						if talker_port == "P_NAME":  ## TEMP HACK
							dialogue.set_portrait( "s_port_hoopz", false )
							# Set the dialogue, with the variable injection
						dialogue.set_text( Text.qst( parsed_line[2].strip_edges(true,true) ), talker_port )
						last_talker_portrait = talker_port
						
					await dialogue.display_dialog()
					dialogue.queue_free()
				"SHAKE":
					if debug_unhandled: print( "Unhandled mode: ", parsed_line )
				"ITEM":
					if debug_unhandled: print( "Unhandled mode: ", parsed_line )
				"NOTIFY":
					var text := parsed_line[ 1 ] as String
					await B2_Screen.show_notify_screen( text )
					
				"NOTIFYALT":
					if debug_unhandled: print( "Unhandled mode: ", parsed_line )
				"PLAYSET":
					var actor = get_node_from_name( all_nodes, parsed_line[ 1 ] )
					assert( is_instance_valid(actor), "No actor named %s on the tree. remember to add it." % parsed_line[ 1 ] )
					actor.cinema_playset( str(parsed_line[ 2 ]), str(parsed_line[ 3 ]) )
					
					cinema_kid( actor ) ## Used to wait for animations to finish
					
				"SET":
					var actor 		= get_node_from_name( all_nodes, parsed_line[ 1 ] )
					assert( is_instance_valid(actor), "No actor named %s on the tree. remember to add it." % parsed_line[ 1 ] )
					var anim_name 	:= str( parsed_line[ 2 ] )
					actor.cinema_set( anim_name )
					if debug_set: print("SET: ", parsed_line[1], " - ", str(parsed_line[ 2 ]) )
				"QUEST":
					# this is confusing. This can set quest states, change states, like quest += 1 and fuck arounf with monei and time. weird
					var quest_stuff := parsed_line[ 1 ].split(" ", false)
					var qstNam = quest_stuff[0]
					var qstTyp = quest_stuff[1]
					var qstVal = quest_stuff[2]
					
					if qstVal.contains("@"): ## Not sure how this is used.
						# if (string_pos("@", qstVal) > 0) qstVal = Cinema("parse", qstVal);
						## Now I know! Its a variable injection, to add arbitrary values to quest variables.
						# What a beautifull mess.
						
						qstVal = qstVal.replace("@", "")
						if qstVal.begins_with("money_"):
							qstVal = qstVal.trim_prefix("money_")
							if not B2_Database.money.has(qstVal):
								push_error("B2_Database.money doesn have the data regarding the variable %s." % qstVal)
							qstVal = B2_Database.money.get(qstVal, "69420")
						elif qstVal.begins_with("time_"):
							qstVal = qstVal.trim_prefix("time_")
							push_warning("Time function is not implemented.")
						else:
							breakpoint
					else:
						qstVal = float( qstVal )
						
					if qstTyp == "+=":
						B2_Playerdata.Quest(qstNam, B2_Playerdata.get_quest_state(qstNam, 0) + qstVal )
					elif qstTyp == "-=":
						B2_Playerdata.Quest(qstNam, B2_Playerdata.get_quest_state(qstNam, 0) - qstVal )
					else:
						B2_Playerdata.Quest(qstNam, float(qstVal) )
					
					if debug_quest: print( "Quest: ", quest_stuff )
				"BREAKOUT":
					# This is a small Info box above the dialog box, showing money or stuff like that
					if parsed_line.size() == 2:
						if parsed_line[1] == "clear":
							show_breakout = false
							breakout_data.clear()
							if debug_breakout: print("Breakout: clear")
						else:
							# invalid amount of arguments
							breakpoint
						
					elif parsed_line.size() == 3:
						if parsed_line[1] == "add":
							show_breakout = true
							if breakout_data.has("value"):
								breakout_data["prev_value"] = B2_Playerdata.Quest( breakout_data.get("value") )
								breakout_data["value"] = parsed_line[2]
							else:
								breakout_data["prev_value"] = B2_Playerdata.Quest( parsed_line[2] )
								breakout_data["value"] = parsed_line[2]
						if debug_breakout: print("Breakout: add %s." % parsed_line[2])
					elif parsed_line.size() == 4:
						# argument not implemented.
						breakpoint
					else:
						# too many arguments.
						breakpoint
						
					print( breakout_data )
					#if debug_unhandled: print( "Unhandled mode: ", parsed_line )
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
						o_fade._seconds 	= float( parsed_line[ 2 ] )# * 0.5 ## 0.5 is DEBUG
					elif parsed_line.size() == 3:
						o_fade._fade 		= float( parsed_line[ 1 ] )
						o_fade._seconds 	= float( parsed_line[ 2 ] )
						o_fade.z_index 		= int( parsed_line[ 3 ] ) # i think this is disabled on the original code.
					else:
						# weird amount of arguments
						breakpoint
					o_fade._event = self # used to listen to signals. _event should never be null
					
					add_child( o_fade, true )
					#add_sibling( o_fade, true )
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
					var event_object = get_node_from_name(all_nodes, parsed_line[1]) # This can be a Node or an CanvasLayer
					if event_object != null:
						var event_id := int(parsed_line[2]) # had some issues with empty spaces here. Now, string > int > string
						if not event_object.has_method( "execute_event_user_%s" % event_id ):
							# node has no execute_event_user_n method. remember to add it
							push_error( "Node %s has no 'execute_event_user_%s' method. remember to add it" % [ parsed_line[1], event_id ] )
						else:
							event_object.call( "execute_event_user_%s" % event_id )
							if "wait_anim" in event_object: # certain nodes can run a stupid animation and need to wait for it to finish. 
								if event_object.wait_anim:
									if event_object.has_signal("event_finished"):
										print("waiting for event %s signal from node %s." % [event_id, event_object])
										await event_object.event_finished # Dont forget to emit the signal after every event user.
									else:
										push_error("Whops! you forgoto to add the signal to the node, dumbass.")
									
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
					Create( parsed_line )
					#if debug_unhandled: print( "Unhandled mode: ", parsed_line )
				"CREATE_WAIT":
					if debug_unhandled: print( "Unhandled mode: ", parsed_line )
				"SURPRISEAT":
					# USEAT(argument[0], "surprise", "surpriseHold", 1.25);
					# Check script USEAT() and SURPRISEAT.
					# the parsed_line[ 1 ] can be either a destination or a string. WTF.
					var subject = get_node_from_name( all_nodes, parsed_line[ 1 ], false )
					
					if is_instance_valid( subject ): ## WARNING Need to check if the cinema script ways for the anim to finish.
						await B2_CManager.o_cts_hoopz.cinema_surpriseat( subject ) 		# its a node.
					else:
						await B2_CManager.o_cts_hoopz.cinema_surpriseat( str(parsed_line[ 1 ]).strip_edges() ) 	# its a direction, like NORTH.
					pass
				"USEAT":
					# Check script USEAT().
					# the parsed_line[ 1 ] can be either a destination or a string. WTF.
					var subject = get_node_from_name( all_nodes, parsed_line[ 1 ], false )
					
					if is_instance_valid( subject ): ## WARNING Need to check if the cinema script ways for the anim to finish.
						await B2_CManager.o_cts_hoopz.cinema_useat( subject ) 		# its a node.
					else:
						await B2_CManager.o_cts_hoopz.cinema_useat( str(parsed_line[ 1 ] ).strip_edges() ) 	# its a direction, like NORTH.
					
				"FOLLOWFRAME":
					var speed 			: String = parsed_line[ 1 ]
					var follow_array 	: Array = Array()
					var args := parsed_line.size() - 2 # parsed_line[ 1 ] and [ 2 ] should be ignored.
					
					for i : int in args:
						follow_array.append( get_node_from_name( all_nodes, parsed_line[ 2 + i ], false ) )
					
					camera.follow_actor( follow_array, speed )
					
				"FRAME":
					# this is a weird one. The original code doesnt have this function FOLLOWFRAME. There is a FOLLOWFRAME() script, however.
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
						
						#if parsed_line[0] == "FRAME":
						cinema_kid( camera )
					else:
						if debug_moveto: print("FRAME: destination_object is invalid: ", move_array )
				"LOOKAT":
					# Look torward someone.
					var actor 					= get_node_from_name( all_nodes,	parsed_line[1] )
					var actor2					= get_node_from_name( all_nodes,	parsed_line[2] )
					
					actor.cinema_lookat( actor2 )
				"LOOK":
					# Look torward a direction.
					## NOTE Im not sure if this is working
					var actor 					= get_node_from_name( all_nodes,	parsed_line[1] )
					if actor != null:
						actor.cinema_look( parsed_line[2] )
					else:
						push_error("Actor %s not found in the current tree." % parsed_line[1])
				"MOVETO":
					# oh, what the fuck. The original game has pathfinding in the movement system.
					# check scr_event_action_move_to_point and o_move.
					# fuck. also check scr_path_set, scr_path_delete, scr_path_update. fuck fuck, this is way more complicated.
					## TODO implement Astar2DGrid on the root node or a standalone class.
					
					var target					= parsed_line[2].strip_edges()
					var actor 					= get_node_from_name( all_nodes,	parsed_line[1] )
					var destination_object 		= get_node_from_name( all_nodes, 	target )
					
					# Make sure that the actors and cinemaspots exists
					# NOTE the destination object may not exist, sometimes a position can be placed here (680 550 for example)
					# assume that if destination_object is invalid, its a position.
					if actor != null:
						if destination_object != null:
							var speed 					= parsed_line[3]
							actor.cinema_moveto( destination_object, speed ) 		## Async movement
							cinema_kid( actor )
							
						elif target.contains(" "):
							## Assume its a position
							var speed 					= parsed_line[3]
							var target_pos := Vector2( float( target.split(" ")[0] ), float( target.split(" ")[1] ) )
							actor.cinema_moveto( target_pos, speed ) 		## Async movement
							cinema_kid( actor )
						else:
							print( str_to_var(parsed_line[2]) )
							print("MOVETO: destination_object is invalid: ",parsed_line[2])
					else:
						if debug_moveto: print("MOVETO: actor is invalid: ",parsed_line[1])
						
					if debug_moveto: print("MOVETO: ", parsed_line[1], " - ", parsed_line[2] )
				"MOVE":
					var target_x					= float(parsed_line[2])
					var target_y					= float(parsed_line[3])
					var actor 					= get_node_from_name( all_nodes,	parsed_line[1] ) as Node2D
					
					var speed 					= parsed_line[4]
					var target_pos : Vector2 = actor.position + Vector2( target_x, target_y )
					actor.cinema_moveto( target_pos, speed ) 		## Async movement
					cinema_kid( actor )
					
					#if debug_unhandled: print( "Unhandled mode: ", parsed_line )
				"SOUNDSTOP":
					B2_Sound.stop_loop() ## CRITICAL current implementation ignores the actual sound name.
				"Destroy":
					# Remove actor. simple.
					var actor = get_node_from_name( all_nodes,	parsed_line[1] )
					actor.queue_free()
					array_dirty = true
					
				## B2 has some stupid ACE script execution
				# Check Cinema() line 588
				"Misc":
					Misc( parsed_line )
				"Camera":
					Camera( parsed_line )
				"Create":
					Create( parsed_line )
				"Shake":
					Shake( parsed_line )
				"Emote":
					## Emote(emotetype, target object?, xoffset?, yoffset?)
					## Create an emote at a specific place.
					#  Argument0 = Emote Type = ! ? anime
					#  Argument1 = Target Object (optional, default hoopz)
					#  Argument2 = X Offset (optional, default 0)
					#  Argument3 = Y Offset (optional, default 0)
					
					var emote_type 		: String = parsed_line[1]
					var emote_target 	:= B2_CManager.o_cts_hoopz # This is the default
					var xoffset 		:= 0.0
					var yoffset			:= 0.0
					var emote_node		:= preload("res://barkley2/scenes/_event/Misc/o_effect_emotebubble_event.tscn").instantiate() as AnimatedSprite2D
					
					if parsed_line.size() > 2: emote_target = get_node_from_name( all_nodes, parsed_line[2] )
					if parsed_line.size() > 3: xoffset = float( parsed_line[3] )
					if parsed_line.size() > 4: xoffset = float( parsed_line[4] )
					
					assert( is_instance_valid(emote_target), "Invalid node. Check %s." % parsed_line )
					
					## TODO 15/10/24 add other arguments, current solution only take 1 argument.
					## 03/11/24 fixed, i think.
					emote_node.type 	= emote_type
					emote_node.offset	+= Vector2( xoffset, yoffset )
					emote_node.position = ( emote_target.position ) - Vector2( 0, 10 )
					get_tree().current_scene.add_child( emote_node, true )
				"BodySwap":
					B2_CManager.BodySwap( str( parsed_line[1] ).strip_edges() )
				"Teleport":
					var room_string := ""
					for _str : String in parsed_line:
						if _str == "Teleport": continue # Lazy way to skip the first line.
						room_string += _str + "," # Should make a string like this: r_fct_reroute01,544,368,1
					B2_RoomXY.warp_to( room_string, 0.0, false )
					await B2_RoomXY.fadeout_finished
				"scr_savedata_save":
					B2_Playerdata.SaveGame()
				_:
					if debug_unhandled: print( "Unhandled text: ", parsed_line[0] )
			
			# Jump to next line
			curr_line += 1
			
			if print_line_report:
				print( str(curr_line), " - ", parsed_line )
				
			if array_dirty:
				# some invalid node was foing in the array
				all_nodes.clear()
				all_nodes = get_all_nodes()
				
		end_cutscene()
		
	return true

func get_all_nodes() -> Array:
	if get_tree().current_scene != null:
		return get_tree().current_scene.get_children()
	else:
		return []

# add a node to the array.
# This is used to keep track of actor movement, to wait for something to finish before starting another.
func cinema_kid( kid : Node2D ) -> void:
	dslCinKid.append(kid)
	
# Wait for every child action to finish, them clear the queue
func cinema_kids() -> void:
	for i in dslCinKid:
		if is_instance_valid(i):
			await i.check_actor_activity()
	dslCinKid.clear()
	return

func cleanup_line( line : String ) -> PackedStringArray:
	var parsed_line : PackedStringArray = line.split( "|", false )
	# Cleanup
	for i in range( parsed_line.size() ):
		parsed_line[i] = parsed_line[i].strip_edges( true, true )
		if parsed_line[i].is_empty(): ## Avoid issues with emtpy lines after trimming.
			continue
		parsed_line[i] = parsed_line[i].split("//", false, 1)[ 0 ] ## Strip comments
		parsed_line[i].strip_edges( true, true ) ## cleanup for empty spaces
	return parsed_line

func parse_if( line : String ) -> bool:
	# clean the conditions
	var condidion_line : PackedStringArray = line.split( " ", false )
	
	var str_var 	: String 		= condidion_line[ 1 ] # 0 is the IF
	var comparator 	: String 		= condidion_line[ 2 ]
	var cond_value 		 			= int( condidion_line[ 3 ] )
	
	# this should return false (if quest var is invalid) or some value.
	var quest_var = B2_Playerdata.Quest( str_var, null, 0 ) ## WARNING Quest defaults must be set. Ints or Strings?
	## Overides
	if str_var == "body":
		quest_var = B2_Playerdata.Quest( str_var, null, "hoopz" )
		cond_value = str(condidion_line[ 3 ]).strip_edges()
		
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
			"<":
				return quest_var < cond_value
			">":
				return quest_var > cond_value
			_:
				push_error("Unknown operation ", comparator)
				return false
	else:
		return false
	
func Cinema_run():
	pass
func Cinema_process():
	pass
	
func get_node_from_name( _array, _name, warn := true ) -> Object:
	var node : Object
	for item in _array:
		if is_instance_valid(item):
			if item is Object:
				if item.name == _name:
					node = item
					break
		else:
			if warn: # sometimes a warning is not needed.
				#push_warning( "Ops, invalid node on the array. -> ", item, "  _  ", _name)
				array_dirty = true
	if not is_instance_valid(node):
		#if warn:
		#push_warning("Target %s not found. Bummer. This is normal with the USEAT action." % _name)
		print_debug("Target %s not found. Bummer. This is normal with the USEAT action." % _name)
		pass ## Too many warnings
	return node
	
func Shake( parsed_line :PackedStringArray ):
	var misc_arguments := parsed_line.size() - 2
	match parsed_line[1]:
		"add":
			if misc_arguments == 2:
				camera.add_shake( float(parsed_line[2]), float(parsed_line[3]) )
			else:
				camera.add_shake( float(parsed_line[2]), float(parsed_line[3]), float(parsed_line[4]), float(parsed_line[5]), float(parsed_line[6]) )
		"remove":
			pass
		"edit":
			pass
		"clear":
			pass
	
func Misc( parsed_line :PackedStringArray ):
	# Check Misc() script.
	var misc_arguments := parsed_line.size() - 2
	# print("Misc: %s arguments." % str(misc_arguments) )
	
	match parsed_line[1]:
		## What a mess.
		"set": ## 1 = object | 2 = object / x | 3 = y
			var obj1 = get_node_from_name( all_nodes, str(parsed_line[2]) )
			var obj2 = get_node_from_name( all_nodes, str(parsed_line[3]) )
			
			if parsed_line.size() > 4: ## Its a direct position
				obj1.position = Vector2( float(parsed_line[3]), float(parsed_line[4]) )
				
			elif all_nodes.has(obj1): ## Its an object
				if all_nodes.has(obj2):
					obj1.position = obj2.position
				else:
					push_error("obj2 invalid: ", obj2, " - ", parsed_line)
			else:
				push_error("obj1 invalid: ", obj1, " - ", parsed_line)
		"shadow":
			if debug_unhandled: print( "Unhandled mode: ", parsed_line )
		"visible":
			var subject = get_node_from_name( all_nodes, parsed_line[ 2 ], false )
			if is_instance_valid(subject):
				if int( parsed_line[ 3 ] ) == 0:
					subject.visible = false
				else: 
					subject.visible = true
			else:
				print( "Command failed: ", parsed_line )
			#if debug_unhandled: print( "Unhandled mode: ", parsed_line )
		"entity settings":
			if debug_unhandled: print( "Unhandled mode: ", parsed_line )
		"music":
			# I think its only this. In my implementation, the parsed_line[3] will be ignored
			B2_Music.play( parsed_line[2] )
			#if debug_unhandled: print( "Unhandled mode: ", parsed_line )
		"automatic animation":
			if debug_unhandled: print( "Unhandled mode: ", parsed_line )
		"flip":
			var subject = get_node_from_name( all_nodes, parsed_line[ 2 ], false )
			if is_instance_valid(subject):
				# -1 means flip. 1 means normal.
				var flip : bool = str( parsed_line[ 2 ] ).strip_edges() == "-1" # true if line == -1
				subject.force_flip( flip )
			else:
				push_error("Subject invalid (for some reason): ", parsed_line)
			#if debug_unhandled: print( "Unhandled mode: ", parsed_line )
		"flipx": ## Special case for walking interactive actors
			if debug_unhandled: print( "Unhandled mode: ", parsed_line )
		"alpha": ## 1 = object | 2 = alpha | 3 = time
			var subject = get_node_from_name( all_nodes, parsed_line[ 2 ], false )
			var alpha 	:= float(parsed_line[ 3 ])
			var time 	:= float(parsed_line[ 4 ])
			var tween := create_tween()
			tween.tween_property(subject, "modulate:a", alpha, time) # await maybe?
			
		"backwards":
			if debug_unhandled: print( "Unhandled mode: ", parsed_line )
		"dialogY": # Looks like this is used only in the tutorial
			if float( parsed_line[ 2 ] ) == -1:
				B2_Config.dialogY = 140.0
			else:
				B2_Config.dialogY = float( parsed_line[ 2 ] )
			#if debug_unhandled: print( "Unhandled mode: ", parsed_line )
		"dnaCyber":
			## change player status to be more Cyyyyyber. 
			#var amt = real(argument[1]);
 			#scr_savedata_put("player.humanism.bio", scr_savedata_get("player.humanism.bio") - amt);
 			#scr_savedata_put("player.humanism.cyber", scr_savedata_get("player.humanism.cyber") + amt);
			print_rich("[color=orange]Player Humanism changed ( %s )! Too bad it doesnt do anything yet.[/color]" % parsed_line[ 2 ])
			if debug_unhandled: print( "Unhandled mode: ", parsed_line )
		"manchurian":
			if debug_unhandled: print( "Unhandled mode: ", parsed_line )
		_:
			print("Misc() - GOOFED! Unknown command > " + str(parsed_line[1]) + " <")
	
func Camera( parsed_line : PackedStringArray ):
	# Check Camera() script
	var misc_arguments := parsed_line.size() - 2
	# print("Camera: %s arguments." % str(misc_arguments) )
	
	match parsed_line[1]:
		## Camera("enable", camera)
		"enable":
			if debug_unhandled: print( "Unhandled mode: ", parsed_line )
		## Creates a new camera to be used. Initially disabled.
		## Objects must have camera_target_x, camera_target_y, camera_speed
		## Camera("create", x, y, object_to_follow)
		"create":
			if debug_unhandled: print( "Unhandled mode: ", parsed_line )
		## Camera("transition", new_camera)
		"transition":
			if debug_unhandled: print( "Unhandled mode: ", parsed_line )
		## Camera("snap", object) - Instantly moves camera to spot
		## Camera("snap", x, y) - Instantly moves camera to spot
		"snap":
			var dest := get_node_from_name( all_nodes, parsed_line[ 2 ] )
			if is_instance_valid(dest):
				if dest is Node2D:
					camera.cinema_snap( dest.position )
				else:
					push_error("%s has no position avaiable." % parsed_line[ 2 ])
			else:
				push_error("%s is not valid." % parsed_line[ 2 ])
			
		## Deletes other camera move events
		## Camera("safe check")
		"safe check":
			if debug_unhandled: print( "Unhandled mode: ", parsed_line )
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
		add_sibling( object, true )
	else:
		push_error("object %s not in object_map dictionary. you dun goofed." % str( parsed_line[1] ) )
