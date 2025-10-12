# Meeting Sepideh and she talks about the Power Eggs
extends B2_InteractiveActor

#sepidehState
	#0 - Not talked to
	#1 - Declined Quest
	#2 - Accepted Quest
	#3 - No battery on me

@export var o_cinema6 : B2_CinemaSpot

## Made with B2_TOOL_DWARF_CONVERTER
func _ready() -> void:
	_setup_actor()
	_setup_interactiveactor()
	
	assert( o_cinema6 )
	
	## Machinist Sepideh
	# Go near the duergs if the drone has landed #
	if B2_Playerdata.Quest("sepidehDrone") == 4:
		global_position = o_cinema6.global_position
	
	if B2_Playerdata.Quest("sepidehCutscene") == 0:
		ActorAnim.play("default")
	else:
		ActorAnim.play("working")
	
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
