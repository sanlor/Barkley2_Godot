extends B2_AI
class_name B2_AI_Player

## Player AI. Receives user inputs and puppeters the parent node (o_hoopz).
func step() -> void:
	if actor:
		if B2_Input.player_has_control:
			actor.apply_curr_input( Input.get_vector("Left","Right","Up","Down") )
			actor.apply_curr_aim( actor.get_global_mouse_position() )
			
			_input_process()

func _input_process() -> void:
	if B2_Input.player_has_control:
		ranged_attack_trigger.emit( 	Input.is_action_pressed("Action") 		)
		
		if Input.is_action_just_pressed("Holster"):		aim_trigger.emit( true )
		elif Input.is_action_just_released("Holster"):	aim_trigger.emit( false )
		
		if Input.is_action_just_pressed( "Roll" ):		roll_trigger.emit( true )
		if Input.is_action_just_pressed("Item Use"):	jump_trigger.emit( true )
		
		if B2_Input.can_switch_guns:
			if Input.is_action_just_pressed("Weapon >"):
				B2_Gun.next_band_gun()
			if Input.is_action_just_pressed("Weapon <"):
				B2_Gun.prev_band_gun()
			if Input.is_action_just_pressed("Gun'sbag"):
				
				B2_Gun.toggle_gunbag()
