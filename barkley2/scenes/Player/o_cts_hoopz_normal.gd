extends B2_InteractiveActor_Player

func _ready() -> void:
	B2_CManager.o_cts_hoopz 	= self
	disable_auto_flip_h 		= true
	ANIMATION_STAND 						= "s_cts_hoopz_stand"
	ANIMATION_SOUTH 						= "walk_S"
	ANIMATION_SOUTHEAST 					= "walk_SE"
	ANIMATION_SOUTHWEST 					= "walk_SW"
	ANIMATION_WEST 							= "walk_W"
	ANIMATION_NORTH 						= "walk_N"
	ANIMATION_NORTHEAST 					= "walk_NE"
	ANIMATION_NORTHWEST 					= "walk_NW"
	ANIMATION_EAST 							= "walk_E"
	ANIMATION_STAND_SPRITE_INDEX 			= [2, 1, 0, 7, 6, 5, 4, 3]
	ActorAnim.animation						= "s_cts_hoopz_stand"
	
	## USEAT Animations
	useat_map[Vector2.DOWN] =  					"S"
	useat_map[Vector2.DOWN + Vector2.LEFT] =  	"SW"
	useat_map[Vector2.LEFT] =  					"W"
	useat_map[Vector2.UP + Vector2.LEFT] =  	"NW"
	useat_map[Vector2.UP] =  					"N"
	useat_map[Vector2.UP + Vector2.RIGHT] =  	"NE"
	useat_map[Vector2.RIGHT] =  				"E"
	useat_map[Vector2.DOWN + Vector2.RIGHT] =  	"SE"
