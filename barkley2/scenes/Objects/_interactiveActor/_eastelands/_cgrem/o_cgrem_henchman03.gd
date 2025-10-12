extends B2_InteractiveActor

@export var o_cinema4 : B2_CinemaSpot

## Made with B2_TOOL_DWARF_CONVERTER
func _ready() -> void:
	_setup_actor()
	_setup_interactiveactor()
	
	# Move to "home"
	if B2_Playerdata.Quest("cgremQuest") >= 1:
		assert( o_cinema4 )
		global_position = o_cinema4.global_position

	ANIMATION_STAND 						= "s_cgrem_henchman03_stand"
	ANIMATION_SOUTH 						= " s_cgrem_henchman03_SE"
	ANIMATION_SOUTHEAST 					= " s_cgrem_henchman03_SE"
	ANIMATION_SOUTHWEST 					= " s_cgrem_henchman03_SE"
	ANIMATION_WEST 							= " s_cgrem_henchman03_SE"
	ANIMATION_NORTH 						= " s_cgrem_henchman03_NE"
	ANIMATION_NORTHEAST 					= " s_cgrem_henchman03_NE"
	ANIMATION_NORTHWEST 					= " s_cgrem_henchman03_NE"
	ANIMATION_EAST 							= " s_cgrem_henchman03_SE"
	ANIMATION_STAND_SPRITE_INDEX 			= [1, 1, 0, 0, 0, 0, 0, 1]
	ActorAnim.animation 					= "s_cgrem_henchman03_stand"
