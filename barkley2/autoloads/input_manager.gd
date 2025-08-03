extends Node

## This autoload handles most of the game´s input, with the exception of combat inputs.
## NOTE maybe move combat inputs here?

var debug := true

enum CONTROL{KEYBOARD, GAMEPAD}
var curr_CONTROL := CONTROL.KEYBOARD

signal fastforward_request( is_active : bool )

var cutscene_is_playing 	:= false # Set to true during cutscenes and conversations
var player_has_control 		:= true # Set to false during cutscenes and conversations

signal action_pressed

## Player stuff
signal player_follow_mouse( enabled : bool )
signal camera_follow_mouse( enabled : bool )

# FFWD Stuff
var ff_time_scale			:= 5.5		# FFWD time scale, duh. Higher is faster. 10.0 is overkill.
var can_fast_forward		:= false 	# Set to true during cutscenes and conversations
var is_fastforwarding		:= false 	# Set to true when you are FFWD
var can_switch_guns			:= true	# if the player can swap guns (Should be disabled in menus)

# Node responsible for the Input management.

func _physics_process(_delta: float) -> void:
	## DEBUG
	#if Input.is_action_just_pressed("Roll"):
		#B2_Screen.show_notify_screen("Big Butts")
	
	if can_switch_guns:
		if Input.is_action_just_pressed("Weapon >"):
			B2_Gun.next_band_gun()
		if Input.is_action_just_pressed("Weapon <"):
			B2_Gun.prev_band_gun()
		if Input.is_action_just_pressed("Gun'sbag"):
			
			B2_Gun.toggle_gunbag()
			
			
	if Input.is_action_just_pressed("Action"):
		action_pressed.emit()
		
func _input(_event: InputEvent) -> void:
	if Input.is_action_pressed("Holster") or Input.is_action_just_released("Holster"):
		if (can_fast_forward and cutscene_is_playing) or Input.is_action_pressed("DEBUG_FF"):
			if Input.is_action_pressed("Holster"):
				ffwd( true )
			else:
				ffwd( false )
		else:
			# normalize engine speed.
			ffwd( false )

func ffwd( active : bool ):
	if active:
		Engine.time_scale = ff_time_scale
		if is_fastforwarding == false:
			# emit the signal only once per change
			fastforward_request.emit( true )
			B2_Shaders.toggle_ff_shader( true )
		is_fastforwarding = true
	else:
		Engine.time_scale = 1.0
		if is_fastforwarding == true:
			# emit the signal only once per change
			fastforward_request.emit( false )
			B2_Shaders.toggle_ff_shader( false )
		is_fastforwarding = false
