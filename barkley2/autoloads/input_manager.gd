extends Node

## This autoload handles most of the game´s input, with the exception of combat inputs.
## NOTE maybe move combat inputs here?

var debug := true

signal fastforward_request( is_active : bool )
signal input_changed( CONTROL )

## Keeps track of which input method is being used.
enum CONTROL{KEYBOARD, GAMEPAD}
var curr_CONTROL := CONTROL.KEYBOARD

var cutscene_is_playing 	:= false :# Set to true during cutscenes and conversations
	set(c):
		cutscene_is_playing = c
		#print_rich( "[bgcolor=red][color=black]%s DEBUG: cutscene_is_playing set to %s.[/color][/bgcolor]" % [name, c] )
		#print_stack()
var player_has_control 		:= true :# Set to false during cutscenes and conversations
	set(p):
		player_has_control = p
		B2_SignalBus.player_input_permission_changed.emit()

signal action_pressed

# FFWD Stuff
var ff_time_scale			:= 6.5		# FFWD time scale, duh. Higher is faster. 10.0 is overkill.
var can_fast_forward		:= false :	# Set to true during cutscenes and conversations
	set(ff): # Reset FFWD
		if not ff:
			ffwd(false)
		can_fast_forward = ff
var is_fastforwarding		:= false 	# Set to true when you are FFWD
var can_switch_guns			:= true	# if the player can swap guns (Should be disabled in menus)

# Node responsible for the Input management.
# NOTE Some functions were moved to the B2_AI_Player

func _physics_process(_delta: float) -> void:
	## DEBUG
	#if Input.is_action_just_pressed("Roll"):
		#B2_Screen.show_notify_screen("Big Butts")
	if Input.is_action_just_pressed("Action"):
		action_pressed.emit()
		
func _input(event: InputEvent) -> void:
	## Allow the detection of which input is the player using. Gamepad or keyboard?
	# Keyboard check
	if event is InputEventMouseButton or event is InputEventKey: ## NOTE Mouse movement does not change the input.
		if curr_CONTROL != CONTROL.KEYBOARD:
			curr_CONTROL = CONTROL.KEYBOARD
			input_changed.emit(CONTROL.KEYBOARD)
	# Gamepad check
	elif event is InputEventJoypadButton or event is InputEventJoypadMotion:
		if curr_CONTROL != CONTROL.GAMEPAD:
			curr_CONTROL = CONTROL.GAMEPAD
			input_changed.emit(CONTROL.GAMEPAD)
		
	# Fast forward check.
	if Input.is_action_pressed("Holster") or Input.is_action_just_released("Holster"):
		if (can_fast_forward and cutscene_is_playing) or Input.is_action_pressed("DEBUG_FF") or B2_Debug.ENABLE_FREE_FFWD: ## DEBUG
			if Input.is_action_pressed("Holster"):
				ffwd( true )
			else:
				ffwd( false )
		else:
			# normalize engine speed.
			ffwd( false )

func is_using_gamepad() -> bool:
	return curr_CONTROL == CONTROL.GAMEPAD

func ffwd( active : bool ):
	if active:
		Engine.time_scale = ff_time_scale
		if is_fastforwarding == false:
			# emit the signal only once per change
			fastforward_request.emit( true )
			B2_Screen.toggle_ff_shader( true )
		is_fastforwarding = true
	else:
		Engine.time_scale = 1.0
		if is_fastforwarding == true:
			# emit the signal only once per change
			fastforward_request.emit( false )
			B2_Screen.toggle_ff_shader( false )
		is_fastforwarding = false
