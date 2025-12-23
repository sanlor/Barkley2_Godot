## Player AI. Receives user inputs and puppeters the parent node (o_hoopz).
extends B2_AI
class_name B2_AI_Player

const AIM_SPEED := 0.1

@export var force_player_control := false

var g_input := Vector2.ZERO

## Mainly, this disables the default "_ready" function.
func _ready() -> void:
	pass

func step() -> void:
	if actor:
		## Analog input processing.
		if B2_Input.player_has_control or force_player_control:
			## Movement input (Normalized)
			var curr_input : Vector2 = Input.get_vector("Left","Right","Up","Down")
			actor.apply_curr_input( curr_input )
			
			## Aiming input (Normalized)
			if B2_Input.is_using_gamepad():
				var gamepad_input := Input.get_vector("Aim_Left","Aim_Right","Aim_Up","Aim_Down")
				if gamepad_input == Vector2.ZERO and curr_input != Vector2.ZERO:	## Check is the player is moving and not aiming.
					g_input = g_input.slerp( curr_input, AIM_SPEED )				## Allow the movement input do influence the aiming when not aiming.
				else:
					g_input = g_input.slerp( gamepad_input, AIM_SPEED )				## Player is aiming, use only the aim input.
					
				if g_input:			actor.apply_curr_aim( (g_input * 100.0).normalized() )
				else:				actor.apply_curr_aim( curr_input ) ## <- Is this needed? # 23/12/25 changed from Vector2.ZERO to curr_input.
			else: # Mouse aiming requires additional processing to be normalized.
				g_input = g_input.slerp( actor.get_aim_origin().direction_to( actor.get_global_mouse_position() ), AIM_SPEED )
				# oooh mister fancy guy, using slerp() and shit. must be a math wizard or something.
				actor.apply_curr_aim( g_input )
			
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
