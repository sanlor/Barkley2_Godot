extends B2_InteractiveActor

func _ready() -> void:
	## Animation
	ANIMATION_STAND			= "default"
	ANIMATION_SOUTH 		= "s_cts_jhodfreySE"
	ANIMATION_SOUTHEAST 	= "s_cts_jhodfreySE"
	ANIMATION_SOUTHWEST 	= "s_cts_jhodfreySE"
	ANIMATION_WEST 			= "s_cts_jhodfreySE"
	ANIMATION_NORTH 		= "s_cts_jhodfreyNE"
	ANIMATION_NORTHEAST 	= "s_cts_jhodfreyNE"
	ANIMATION_NORTHWEST 	= "s_cts_jhodfreyNE"
	ANIMATION_EAST 			= "s_cts_jhodfreyNE"
	animation = ANIMATION_STAND
