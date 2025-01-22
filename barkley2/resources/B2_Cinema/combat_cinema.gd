@icon("res://barkley2/assets/b2_original/images/merged/icon_camera_2.png")
extends CanvasLayer
class_name B2_Combat_CinemaPlayer

## Original system. Analogous to the B2_CinemaPlayer system, but for combat.
# I have no plans for this, just coding random ideas and changing as I go along. 21/01/25

const O_COMBAT_UI = preload("res://barkley2/scenes/Objects/System/o_combat_ui.tscn")

var camera : B2_Camera_Hoopz


## Setup enviroment, replace player character with actor and shiet.
func setup_combat( combat_script : B2_CombatScript, enemies : Array ) -> void:
	if not is_instance_valid(camera):
		camera = _get_camera_on_tree()
		
	assert(camera != null, "Camera not setup. Fix it.")
		
	B2_Screen.set_cursor_type( B2_Screen.TYPE.POINT )
	
	## lock player control
	B2_Input.cutscene_is_playing 	= true
	B2_Input.can_fast_forward 		= true
	B2_Input.player_has_control 	= false
	
	B2_CManager.event_started.emit()
	
	camera.set_camera_bound( false )
	
	# Chill out. Avoid loading invalid nodes.
	await get_tree().process_frame
	
	_load_combat_hoopz_actor()
	
	B2_Input.player_follow_mouse.emit( false )
	B2_Input.camera_follow_mouse.emit( false )
	
	_load_combat_ui()
	
	if is_instance_valid(B2_CManager.o_hud):
		B2_CManager.o_hud.hide_hud()
		
	print_rich("[color=pink]Started Combat_Cinema Script![/color]")
	
	## Move the camera do a specific location.
	for action : B2_CombatScriptActions in combat_script.combat_actions:
		if action is B2_CSA_Frame:
			if action.look_target == "torward_node":
				if action.use_node_array:
					for n in action.node_array:
						var node : Node2D = get_node( n )
						if action.wait_for_action_to_finish:
							await camera.cinema_frame( node.position, action.speed )
						else:
							camera.cinema_frame( node.position, action.speed )
				else:
					var node : Node2D = get_node( action.node )
					if action.wait_for_action_to_finish:
						await camera.cinema_frame( node.position, action.speed )
					else:
						camera.cinema_frame( node.position, action.speed )
			else:
				if action.wait_for_action_to_finish:
					await camera.cinema_frame( action.position, action.speed )
				else:
					camera.cinema_frame( action.position, action.speed )
			
		## Actor look to a certain direction or torward another node.
		if action is B2_CSA_Look_At:
			pass
			
		## Play a sound
		if action is B2_CSA_Sound:
			B2_Sound.play( action.sound_name, 0.0, false, action.sound_loop, action.sound_pitch )
			
		## wait for some time.
		if action is B2_CSA_Wait:
			if action.wait_time > 0.0:
				await get_tree().create_timer( action.wait_time ).timeout
			
		if action is B2_CSA_Begin_Battle:
			breakpoint
			pass
				
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

func _load_combat_ui() -> void:
	var o_combat_ui = O_COMBAT_UI.instantiate()
	get_tree().current_scene.add_child( o_combat_ui, true )
	B2_CManager.o_combat_ui = self

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
	
	get_tree().current_scene.add_child( B2_CManager.o_cbt_hoopz, true )
	
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
