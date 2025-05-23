extends B2_Duergar

# First Duergar.
# Need to create class B2_DuergarsActors
# Need to create something with to keepp track of the Duergars (like the original Duergar() script)

func _ready() -> void:
	_setup_actor()
	_setup_interactiveactor()
	
	ANIMATION_STAND 						= "s_roethlisbuergar01"
	ANIMATION_SOUTH 						= "s_roethlisbuergarSE"
	ANIMATION_SOUTHEAST 					= "s_roethlisbuergarSE"
	ANIMATION_SOUTHWEST 					= "s_roethlisbuergarSE"
	ANIMATION_WEST 							= "s_roethlisbuergarSE"
	ANIMATION_NORTH 						= "s_roethlisbuergarNE"
	ANIMATION_NORTHEAST 					= "s_roethlisbuergarNE"
	ANIMATION_NORTHWEST 					= "s_roethlisbuergarNE"
	ANIMATION_EAST 							= "s_roethlisbuergarSE"
	ANIMATION_STAND_SPRITE_INDEX 			= [1, 1, 0, 0, 0, 0, 0, 1]
	ActorAnim.animation 					= "s_roethlisbuergar01"
		
	if B2_Playerdata.Quest("tutorialProgress") >= 7:
		cinema_look( "NORTHEAST" )
		
	if B2_Playerdata.Quest("tutorialProgress") >= 11:
		is_interactive = false
