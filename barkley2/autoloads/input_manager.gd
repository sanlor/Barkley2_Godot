extends Node

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
var can_fast_forward		:= false # Set to true during cutscenes and conversations
var is_fastforwarding		:= false # Set to true when you are FFWD

# Node responsible for the Input management.

func _physics_process(_delta: float) -> void:
	## DEBUG
	#if Input.is_action_just_pressed("Roll"):
		#B2_Screen.show_notify_screen("Big Butts")
	
	if Input.is_action_just_pressed("Action"):
		action_pressed.emit()
		
	if can_fast_forward and cutscene_is_playing:
		if Input.is_action_pressed("Holster"):
			ffwd( true )
		else:
			ffwd( false )
	else:
		# normalize engine speed.
		ffwd( false )

func ffwd( active : bool ):
	if active:
		Engine.time_scale = 10.0
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
