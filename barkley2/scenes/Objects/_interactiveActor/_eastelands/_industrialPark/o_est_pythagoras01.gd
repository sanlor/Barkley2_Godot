## PYTHAGORAS the wasteland machine
extends B2_InteractiveActor

@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

## TODO migrate most things, like the SFX for the machine being active.

## Made with B2_TOOL_DWARF_CONVERTER
func _ready() -> void:
	_setup_actor()
	_setup_interactiveactor()
	
	## The GOOF variables are a caveman device, do not frudge with them, thanks ##
	## Go into Dire Straits if left unchecked for too long after accepting the quest ##
	if B2_Playerdata.Quest("pythagorasStateGoof") == 4 and B2_Playerdata.Quest("pythagorasState") == 1:
		B2_Playerdata.Quest("pythagorasState", 4);

	## Expire if you took too long to flip the switch ##
	if B2_Playerdata.Quest("pythagorasStateGoof") == 5 and B2_Playerdata.Quest("pythagorasState") == 1:
		B2_Playerdata.Quest("pythagorasState", 5);

	## Killed by Clocktime ##
	if B2_ClockTime.time_gate() >= 10 and B2_Playerdata.Quest("pythagorasState") == 0:
		B2_Playerdata.Quest("pythagorasState", 7)
	elif B2_ClockTime.time_gate() >= 10 and B2_Playerdata.Quest("pythagorasState") != 2 and B2_Playerdata.Quest("pythagorasState") != 3 and B2_Playerdata.Quest("pythagorasState") != 6:
		B2_Playerdata.Quest("pythagorasState", 5);

	## Animation set ##
	if B2_Playerdata.Quest("pythagorasState") >= 2 and B2_Playerdata.Quest("pythagorasState") <= 3:
		ActorAnim.play( "healthy" )
		B2_Playerdata.Quest("pythagorasOnline", 1);
	elif B2_Playerdata.Quest("pythagorasState") >= 5:
		ActorAnim.play( "dead" );
		B2_Playerdata.Quest("pythagorasOnline", 0);
	else:
		ActorAnim.play( "dire" );
		B2_Playerdata.Quest("pythagorasOnline", 1);

	## Before first meeting start off "dead " in powersaving mode ##
	if B2_Playerdata.Quest("pythagorasState") == 0:
		ActorAnim.play( "dead" );
		B2_Playerdata.Quest("pythagorasOnline", 0);

	ANIMATION_STAND 						= "default"
	ANIMATION_SOUTH 						= ""
	ANIMATION_SOUTHEAST 					= ""
	ANIMATION_SOUTHWEST 					= ""
	ANIMATION_WEST 							= ""
	ANIMATION_NORTH 						= ""
	ANIMATION_NORTHEAST 					= ""
	ANIMATION_NORTHWEST 					= ""
	ANIMATION_EAST 							= ""
	ANIMATION_STAND_SPRITE_INDEX 			= [0, 0, 0, 0, 0, 0, 0, 0]
	ActorAnim.animation 					= "default"

## Get Max Feeber Zauber ##
func execute_event_user_0():
	#Zauber("gain", "cyber0"); # <- TODO
	breakpoint

## Get the zauber room return location ##
func execute_event_user_2():
	# global.zauberRoomName = room;
	# global.zauberRoomX = o_cts_hoopz.x;
	# global.zauberRoomY = o_cts_hoopz.y;
	breakpoint
