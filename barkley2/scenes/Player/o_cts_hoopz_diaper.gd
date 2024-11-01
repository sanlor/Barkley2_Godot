extends B2_InteractiveActor_Player
# Cutscene version of hoopz.
# check scr_event_hoopz_switch_cutscene()

func _ready() -> void:
	B2_CManager.o_cts_hoopz = self
	_setup_actor()
	_setup_interactiveactor()
	
	ANIMATION_STAND 						= "s_cts_hoopz_diaper_stand"
	ANIMATION_SOUTH 						= "walk_S"
	ANIMATION_SOUTHEAST 					= "walk_SE"
	ANIMATION_SOUTHWEST 					= "walk_SW"
	ANIMATION_WEST 							= "walk_W"
	ANIMATION_NORTH 						= "walk_N"
	ANIMATION_NORTHEAST 					= "walk_NE"
	ANIMATION_NORTHWEST 					= "walk_NW"
	ANIMATION_EAST 							= "walk_E"
											 # N, NE, E, SE, S, SW, W, NW
	ANIMATION_STAND_SPRITE_INDEX 			= [0, 1, 2, 3, 4, 3, 2, 1]
	ActorAnim.animation 					= "s_cts_hoopz_diaper_stand"

	## USEAT Animations
	useat_map[Vector2.DOWN] =  					"S"
	useat_map[Vector2.DOWN + Vector2.LEFT] =  	"SW"
	useat_map[Vector2.LEFT] =  					"W"
	useat_map[Vector2.UP + Vector2.LEFT] =  	"NW"
	useat_map[Vector2.UP] =  					"N"
	useat_map[Vector2.UP + Vector2.RIGHT] =  	"NE"
	useat_map[Vector2.RIGHT] =  				"E"
	useat_map[Vector2.DOWN + Vector2.RIGHT] =  	"SE"
	
