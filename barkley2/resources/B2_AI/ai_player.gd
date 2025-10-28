## Player AI. Receives user inputs and puppeters the parent node (o_hoopz).
extends B2_AI
class_name B2_AI_Player

@export var force_player_control := false

## Mainly, this disables the default "_ready" function.
func _ready() -> void:
	pass

func step() -> void:
	if actor:
		## Analog input processing.
		if B2_Input.player_has_control or force_player_control:
			## Movement input (Normalized)
			actor.apply_curr_input( Input.get_vector("Left","Right","Up","Down") )
			
			## Aiming input (Normalized)
			if B2_Input.is_using_gamepad():
				var g_input := 		Input.get_vector("Aim_Left","Aim_Right","Aim_Up","Aim_Down")
				if g_input:			actor.apply_curr_aim( g_input )
				else:				actor.apply_curr_aim( Vector2.ZERO ) ## <- Is this needed?
			else: # Mouse aiming requires additional processing to be normalized.
				actor.apply_curr_aim( actor.get_aim_origin().direction_to( actor.get_global_mouse_position() ) )
			
		_input_process()

## Button input processing
func _input_process() -> void:
	if B2_Input.player_has_control or force_player_control:
		ranged_attack_trigger.emit( 	Input.is_action_pressed("Action") 		)
		
		if Input.is_action_just_pressed("Holster"):		aim_trigger.emit( true )
		elif Input.is_action_just_released("Holster"):	aim_trigger.emit( false )
		
		if Input.is_action_just_pressed( "Roll" ):		roll_trigger.emit( true )
		if Input.is_action_just_pressed("Item Use"):	jump_trigger.emit( true )
		
		if B2_Input.can_switch_guns:
			if Input.is_action_just_pressed("throw_gun"):
				if actor.has_method("throw_gun"):
					actor.throw_gun() ## Fix this
				else: print_rich("[color=yellow]%s: Method 'throw_gun' not found.[/color]")
			if Input.is_action_just_pressed("Weapon >"):				B2_Gun.next_band_gun()
			if Input.is_action_just_pressed("Weapon <"):				B2_Gun.prev_band_gun()
			if Input.is_action_just_pressed("Gun'sbag"):				B2_Gun.toggle_gunbag()
