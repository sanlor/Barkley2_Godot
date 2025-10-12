extends B2_InteractiveActor

@export var o_cinema6 : B2_CinemaSpot

## Rumi DSL
# rumiState == 1 means you said no to movies twice or insulted him, won't talk again
# rumi

## Made with B2_TOOL_DWARF_CONVERTER
func _ready() -> void:
	_setup_actor()
	_setup_interactiveactor()

	# Move to "home"
	if B2_Playerdata.Quest("cgremQuest") >= 1 or B2_Playerdata.Quest("zenobiaEncounter") >= 3:
		assert( o_cinema6 )
		global_position = o_cinema6.global_position

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
