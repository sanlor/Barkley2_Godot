@icon("res://barkley2/assets/b2_original/images/merged/icon_camera_2.png")
extends CanvasLayer
class_name B2_Combat_CinemaPlayer
## Original system. Analogous to the B2_CinemaPlayer system, but for combat.
## I have no plans for this, just coding random ideas and changing as I go along. 21/01/25
## 23/02/25 Now a have a good Idea how do go on with this. Check https://sanlor.itch.io/rpg-combat-prototype

#region Debug Stuff
@export_category("Debug Stuff")
@export var debug_goto		 	:= false
@export var debug_comments 		:= false
@export var debug_dialog 		:= false
@export var debug_wait 			:= true
@export var debug_fade 			:= false
@export var debug_sound 		:= false
@export var debug_set 			:= false
@export var debug_moveto 		:= true
@export var debug_quest 		:= false
@export var debug_look	 		:= false
@export var debug_lookat 		:= false
@export var debug_event 		:= false
@export var debug_breakout		:= false
@export var debug_unhandled 	:= false
@export var debug_know			:= false
@export var debug_note			:= false
@export var print_comments		:= false
@export var print_line_report 	:= false ## details about the current script line.
#endregion

#const O_COMBAT_UI = preload("uid://c1a8fta51ill1")
const O_HUD 			= preload("uid://cc0u1jcebct86")
const O_HUD_MINIMAL 	= preload("uid://cyaw4x2juog4u")

signal battle_finished ## Called at the end of the battle, before queue itself out of the game.
signal action_finished ## Called at the end of the combat action.

## IDLE - Nobody is doing anything
## PLAYER_ACTION - player is selecting an action, depends on player input
## ENEMY_ACTION - Enemy is selecting an action, instant.
enum CBT_STATE{ IDLE, PLAYER_ACTION, ENEMY_ACTION, WON, LOST }
var curr_CBT_STATE := CBT_STATE.IDLE

## Universal action costs (player)
const MOVE_COST		:= 75
const DEFENSE_COST	:= 55
const ESCAPE_COST 	:= 90
const ITEM_COST 	:= 60

var camera 			: B2_Camera_Hoopz
var combat_ticker 	: Timer ## Timers use to keep control the passage of the time. check the _tick() func.

var ui					: CanvasLayer

var combat_manager		: B2_CombatManager
var action_queue		: Array[Array]	## All combat actions should be queued.
var ongoing_actions		: Array			## Actors doing specific actions.
var tick_lock := false		## Block the _tick() func, used to give time for the battlers to perform actions withouc recharging its action counter.

## Used during the tutorial.
var has_mini_hud := false

## Combat options - for MUTE, use "mus_blankTEMP"
var battle_music			: String = B2_Music.BATTLE_MUSIC.pick_random()
var end_battle_music		: String = B2_Music.END_BATTLE_MUSIC.pick_random()

## Setup enviroment, replace player character with actor and shiet.
func setup_combat( combat_script : B2_Script_Combat, enemies : Array[B2_EnemyCombatActor] ) -> void:
	# B2_Music.store_curr_music() ## is this needed? No, it is not. Its already done by B2_Music.start_combat().
	
	if is_instance_valid(B2_CManager.cinema_player):
		print_rich("[color=red]B2_Combat_CinemaPlayer: Waiting for the B2_CinemaPlayer to finish its script.[/color]")
		await B2_CManager.event_ended
	
	if not is_instance_valid(camera):
		camera = B2_CManager.camera # _get_camera_on_tree()
		
	assert(camera != null, "Camera not setup. Fix it.")
		
	B2_Screen.set_cursor_type( B2_Screen.TYPE.POINT )
	
	## lock player control
	B2_Input.cutscene_is_playing 	= true
	B2_Input.can_fast_forward 		= true
	B2_Input.player_has_control 	= false
	B2_Input.can_switch_guns		= false
	
	B2_CManager.event_started.emit()
	
	camera.set_camera_bound( false )
	
	# Chill out. Avoid loading invalid nodes.
	# await get_tree().process_frame # <-- No.
	
	# Load a version of Hoopz that is ready to do battle. (Avoid useless functions on the o_hoopz object)
	_load_combat_hoopz_actor()
	
	B2_Input.player_follow_mouse.emit( false )
	B2_Input.camera_follow_mouse.emit( false )
	
	#_load_combat_ui()
	
	if is_instance_valid(B2_CManager.o_hud):
		## 23-02-25 New UI needs this.
		#B2_CManager.o_hud.hide_hud()
		pass
		
	print_rich("[color=pink]Started Combat_Cinema Script![/color]")
	
	## NOTE Improve this. Maybe a default combat script?
	if not combat_script:
		## Forgot to add the combat script.
		breakpoint
		
	if not combat_script.combat_script:
		## Forgot to add the combat script.
		breakpoint
	
	if combat_script is B2_Script_Combat:
		print_rich("[color=pink]Started combat_cinema() Script.[/color]")
		# Split the script into separate lines
		var split_script 	: PackedStringArray = combat_script.combat_script.split( "\n", true )
		var script_size 	:= split_script.size()
		var curr_line 		:= 0
		var loop_finished 	:= true
		
		while loop_finished or curr_line == script_size:
			if curr_line >= script_size: ## End of the script
				loop_finished = true
				break # exit the loop
				
			var line : String = split_script[ curr_line ]
			
			if line.begins_with("//"):
				if print_comments:
					print_rich( str(curr_line) + ": [color=yellow]" + line + "[/color]" )
				curr_line += 1 # Jump to next line
				continue
			
			var parsed_line : PackedStringArray = B2_CManager.cleanup_line( line )
			
			match parsed_line[0]:
				"QUEUE_BATTLE_MUSIC":
					if parsed_line.size() > 1:
						battle_music = parsed_line[1].strip_edges()
					else:
						battle_music = ""
					print("B2_Combat_CinemaPlayer: battle_music set to %s." % battle_music)
				"QUEUE_END_BATTLE_MUSIC":
					if parsed_line.size() > 1:
						end_battle_music = parsed_line[1].strip_edges()
					else:
						battle_music = ""
					print("B2_Combat_CinemaPlayer: end_battle_music set to %s." % end_battle_music)
				"EXIT":
					print("EXIT")
					#if not keep_current_music:
					B2_Music.resume_stored_music()
					end_combat()
				"BEGIN":
					print("BEGIN")
					if battle_music:
						B2_Music.play_combat( 0.5, battle_music )
						
					start_combat( enemies )
					var result = await combat_manager.combat_ended
					## TODO handle the battle result
					
				"FRAME":
					B2_CManager.cinema_frame( parsed_line, self )
				"PLAYSET":
					var actor = get_node_from_name( parsed_line[ 1 ] )
					assert( is_instance_valid(actor), "No actor named %s on the tree. remember to add it." % parsed_line[ 1 ] )
					actor.cinema_playset( str(parsed_line[ 2 ]), str( parsed_line[ 3 ] ) )
					
					add_cinema_action( actor ) ## Used to wait for animations to finish
				"MOVE":
					## NOTE 27/02/25 Copied this from the cinema script, with small changes.
					var target					= parsed_line[2].strip_edges()
					var actor 					= get_node_from_name( parsed_line[1] )
					var destination_object 		= get_node_from_name( target )
					
					if actor:
						if destination_object:
							var speed 					= parsed_line[3]
							actor.cinema_moveto( destination_object.position, speed ) 		## Async movement
							add_cinema_action( actor )
							
						elif target.begins_with("Vector2"):
							## Assume its a position
							var speed 					= parsed_line[3]
							var target_pos := str_to_var( target ) as Vector2
							actor.cinema_moveto( target_pos, speed ) 		## Async movement
							add_cinema_action( actor )
						else:
							print("MOVETO: destination_object is invalid: ",parsed_line[2])
					else:
						if debug_moveto: print("MOVETO: actor is invalid: ",parsed_line[1])
						
					if debug_moveto: print("MOVETO: ", parsed_line[1], " - ", parsed_line[2] )
				"FOLLOWFRAME":
					var speed 			: String = parsed_line[ 1 ]
					var follow_array 	: Array = Array()
					var args := parsed_line.size() - 2 # parsed_line[ 1 ] and [ 2 ] should be ignored.
					
					for i : int in args:
						follow_array.append( get_node_from_name( parsed_line[ 2 + i ] ) )
					
					camera.follow_actor( follow_array, speed )
				"WAIT":
					## NOTE 27/02/25 Copied this from the cinema script, with small changes.
					if parsed_line.size() > 1:
						if float( parsed_line[1] ) <= 0.0:
							if debug_wait: print( "Wait: KID WAIT : %s nodes." % ongoing_actions.size()  )
							await check_cinema_action() ## FIXME stop using await
							if debug_wait: print( "Wait: KID WAIT Finished" )
						else:
							await get_tree().create_timer( float( parsed_line[1] ) ).timeout
							if debug_wait: print("Wait: ", float( parsed_line[1] ) )
					else:
						if debug_wait: print( "Wait: KID WAIT : %s nodes." % ongoing_actions.size()  )
						await check_cinema_action() ## FIXME stop using await
						if debug_wait: print( "Wait: KID WAIT Finished" )
				"DIALOG": ## NOTE This will be needed?
					pass
				"ACTIVATE_BLOCKER":
					var target = get_node_from_name( parsed_line[1].strip_edges() )
					if target:
						if target.has_method("activate_block"):
							target.call_deferred("activate_block")
						else: push_warning("Combat Cinema: invalid node %s." % target.name )
					else: push_warning("Combat Cinema: invalid node %s." % parsed_line[1] ) 
				"DEACTIVATE_BLOCKER":
					var target = get_node_from_name( parsed_line[1].strip_edges() )
					if target:
						if target.has_method("activate_block"):
							target.call_deferred("deactivate_block")
						else: push_warning("Combat Cinema: invalid node %s." % target.name )
					else: push_warning("Combat Cinema: invalid node %s." % parsed_line[1] ) 
				"MAKE_HUD":
					var hud = O_HUD.instantiate()
					get_tree().current_scene.add_child( hud, true )
					print_rich("[color=yellow]Combat Cinema: hud created.[/color]")
				"MAKE_MIN_HUD":
					var hud = O_HUD_MINIMAL.instantiate()
					get_tree().current_scene.add_child( hud, true )
					has_mini_hud = true
					print_rich("[color=yellow]Combat Cinema: min hud created.[/color]")
				"QUEST":
					B2_CManager.cinema_quest( parsed_line, debug_quest )
				"SOUND":
					B2_CManager.cinema_sound( parsed_line, debug_sound )
				"EMOTE": ## Create an emote at a specific place.
					#  Argument0 = Emote Type = ! ? anime
					#  Argument1 = Target Object (optional, default hoopz)
					#  Argument2 = X Offset (optional, default 0)
					#  Argument3 = Y Offset (optional, default 0)
					
					var emote_type 		: String = parsed_line[1]
					var emote_target 	:= B2_CManager.o_cbt_hoopz # This is the default
					var xoffset 		:= 0.0
					var yoffset			:= 0.0
					var emote_node		:= preload("uid://by4nbx8aj48rl").instantiate() as AnimatedSprite2D
					
					if parsed_line.size() > 2: emote_target = get_node_from_name( parsed_line[2] )
					if parsed_line.size() > 3: xoffset = float( parsed_line[3] )
					if parsed_line.size() > 4: xoffset = float( parsed_line[4] )
					
					assert( is_instance_valid(emote_target), "Invalid node. Check %s." % parsed_line )
					
					## NOTE 27/02/25 Copied this from the cinema script, with small changes.
					emote_node.type 	= emote_type
					emote_node.offset	+= Vector2( xoffset, yoffset )
					emote_node.position = ( emote_target.position ) - Vector2( 0, 10 )
					get_tree().current_scene.add_child( emote_node, true )
				"_":
					print_rich( "[color=red]Unhandled action %s.[/color]" % parsed_line )
			curr_line += 1
			if print_line_report:
				print( str(curr_line), " - ", parsed_line )
				
		#if action is B2_SA_Begin_Battle:
			#combat_manager = B2_CombatManager.new() ## Combat Manager Setup.
			#combat_manager.enemy_list 			= enemies
			#combat_manager.combat_cinema 		= self
			#combat_manager.player_character 	= B2_CManager.o_cbt_hoopz
			#combat_manager.start_battle()
			##breakpoint
			#
			#pass
				
func start_combat( enemies : Array[B2_EnemyCombatActor] ) -> void:
	combat_ticker = Timer.new(); add_child( combat_ticker, true ); combat_ticker.wait_time = 0.1; combat_ticker.ignore_time_scale = true	 	## Ticker setup.
	combat_manager = B2_CManager.combat_manager; combat_manager.combat_cinema = self;							## Combat manager setup.
	combat_ticker.timeout.connect( _tick_combat )															## Tick tock
	combat_manager.register_enemy_list( enemies )
	combat_manager.register_player( B2_CManager.o_cbt_hoopz )
	combat_ticker.start()
	combat_manager.tick_toggled.connect( toggle_combat_ticker )
	combat_manager.start_battle()
				
func toggle_combat_ticker( enabled : bool ) -> void:
	if enabled:
		combat_ticker.start()
	else:
		combat_ticker.stop()
				
func end_combat():
	combat_manager.tick_toggled.disconnect( toggle_combat_ticker )
	#await get_tree().process_frame
	_load_hoopz_player()
	
	## Release player lock
	B2_Input.cutscene_is_playing 	= false
	B2_Input.can_fast_forward 		= false
	B2_Input.player_has_control 	= true
	B2_Input.can_switch_guns 		= true
	
	print_rich("[color=pink]Combat Cinema: Finished Script.[/color]")
	
	## NOTE Below is trash. needs improving.
	if get_parent() is B2_ROOMS:
		camera.set_camera_bound( get_parent().camera_bound_to_map )
	else:
		camera.set_camera_bound( false )
	
	camera.manual_control 	= false
	camera.manual_target 	= null
	
	camera.follow_player( B2_CManager.o_hoopz )
	B2_Input.player_follow_mouse.emit( true )
	B2_Input.camera_follow_mouse.emit( true )
	
	# actors may moved during the cutscene, update the PF.
	if is_instance_valid(B2_CManager.o_hud) and not has_mini_hud:
		B2_CManager.o_hud.show_hud()
		
	elif is_instance_valid(B2_CManager.o_hud) and has_mini_hud: ## Remove mini hud from existence.
		B2_CManager.o_hud.queue_free()
	
	B2_CManager.event_ended.emit() # Peace out.
	
	queue_free()
			
func _get_camera_on_tree() -> Camera2D:
	var nodes_in_tree = get_tree().current_scene.get_children() ## get all siblings.
	for c in nodes_in_tree:
		if c is Camera2D:
			c.enabled = true
			return c
			
	if is_instance_valid( B2_CManager.camera ):
		B2_CManager.camera.enabled = true
		return B2_CManager.camera
		
	# No camera loaded. Create a new one
	var _cam := B2_Camera_Hoopz.new()
	_cam.name = "combat_cinema_created_camera"
	B2_CManager.camera = _cam
	# set its initial position
	if is_instance_valid(B2_CManager.o_hoopz):
		_cam.position = B2_CManager.o_hoopz.position
	elif is_instance_valid(B2_CManager.o_cbt_hoopz):
		_cam.position = B2_CManager.o_cbt_hoopz.position
	else:
		_cam.position.x = B2_RoomXY.this_room_x
		_cam.position.y = B2_RoomXY.this_room_y
	
	get_tree().current_scene.add_child( _cam )
	print(name + ": No camera on tree... Creating one.")
	return _cam

func get_node_from_name( node_name : String ) -> Object:
	var node : Object
	var all_nodes := get_tree().current_scene.get_children()
	for item in all_nodes:
		if is_instance_valid(item):
			if item is Object:
				if item.name == node_name:
					node = item
					break
	return node

# add a node to the array.
# This is used to keep track of actor movement, to wait for something to finish before starting another.
func add_cinema_action( act : Node2D ) -> void:
	ongoing_actions.append( act )
	
# Wait for every child action to finish, them clear the queue
func check_cinema_action() -> void:
	for i in ongoing_actions:
		if is_instance_valid(i):
			await i.check_actor_activity() ## FIXME stop using await
	ongoing_actions.clear()
	return

#func _load_combat_ui() -> void:
	#var o_combat_ui = O_COMBAT_UI.instantiate()
	#get_tree().current_scene.add_child( o_combat_ui, true )
	#B2_CManager.o_combat_ui = self

func _load_combat_hoopz_actor():
	var hoopz_lookup := get_tree().current_scene.get_children()
	for n in hoopz_lookup:
		if n.name == "o_hoopz":
			n.queue_free()
			
	# if real is loaded, load fake hoopz.
	if not is_instance_valid(B2_CManager.o_cbt_hoopz): 
		B2_CManager.o_cbt_hoopz = B2_CManager.o_cbt_hoopz_scene.instantiate()
		
	if is_instance_valid(B2_CManager.o_hoopz):
		B2_CManager.o_cbt_hoopz.position 	= B2_CManager.o_hoopz.position
		## ALERT need to copy other stuff too, like direction and such.
		B2_CManager.o_hoopz.queue_free()
	else:
		B2_CManager.o_cbt_hoopz.position.x 	= B2_RoomXY.this_room_x
		B2_CManager.o_cbt_hoopz.position.y 	= B2_RoomXY.this_room_y
	
	get_tree().current_scene.call_deferred( "add_child", B2_CManager.o_cbt_hoopz, true )
	
func _load_hoopz_player(): #  Cinema() else if (argument[0] == "exit")
	var hoopz_lookup := get_tree().current_scene.get_children()
	for n in hoopz_lookup:
		if n.name == "o_cbt_hoopz":
			n.queue_free()
			
	# if fake is loaded, load real hoopz.
	if not is_instance_valid(B2_CManager.o_hoopz):
		B2_CManager.o_hoopz = B2_CManager.o_hoopz_scene.instantiate() as B2_Player
		
	if is_instance_valid(B2_CManager.o_cbt_hoopz):
		B2_CManager.o_hoopz.position = B2_CManager.o_cbt_hoopz.position
		B2_CManager.o_cbt_hoopz.queue_free()
	else:
		B2_CManager.o_hoopz.position.x = B2_RoomXY.this_room_x
		B2_CManager.o_hoopz.position.y = B2_RoomXY.this_room_y
		
	get_tree().current_scene.add_child( B2_CManager.o_hoopz, true )

## Combat clock. Check the Combat manager to get the combat action stuff
func _tick_combat() -> void:
	if combat_manager:
		combat_manager.tick_combat()
	else:
		push_warning("Combat Manager not loaded. This should never happen.")
		
func _physics_process( _delta: float ) -> void:
	if combat_manager:
		combat_manager.process()
