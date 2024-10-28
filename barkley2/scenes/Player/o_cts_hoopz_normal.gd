extends B2_InteractiveActor_Player

func _ready() -> void:
	B2_CManager.o_cts_hoopz = self
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
	ActorAnim.animation 					= "s_cts_hoopz_stand"
	
	## USEAT Animations
	useat_map[Vector2.DOWN] =  					"action_S"
	useat_map[Vector2.DOWN + Vector2.LEFT] =  	"action_SW"
	useat_map[Vector2.LEFT] =  					"action_W"
	useat_map[Vector2.UP + Vector2.LEFT] =  	"action_NW"
	useat_map[Vector2.UP] =  					"action_N"
	useat_map[Vector2.UP + Vector2.RIGHT] =  	"action_NE"
	useat_map[Vector2.RIGHT] =  				"action_E"
	useat_map[Vector2.DOWN + Vector2.RIGHT] =  	"action_SE"
