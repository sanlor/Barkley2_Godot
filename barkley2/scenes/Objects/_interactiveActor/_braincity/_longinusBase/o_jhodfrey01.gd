extends B2_InteractiveActor

func _ready() -> void:
	## Animation
	ANIMATION_STAND				= "default"
	ANIMATION_SOUTH 			= "s_cts_jhodfreySE"
	ANIMATION_SOUTHEAST 		= "s_cts_jhodfreySE"
	ANIMATION_SOUTHWEST 		= "s_cts_jhodfreySE"
	ANIMATION_WEST 				= "s_cts_jhodfreySE"
	ANIMATION_NORTH 			= "s_cts_jhodfreyNE"
	ANIMATION_NORTHEAST 		= "s_cts_jhodfreyNE"
	ANIMATION_NORTHWEST 		= "s_cts_jhodfreyNE"
	ANIMATION_EAST 				= "s_cts_jhodfreyNE"
	ActorAnim.animation 		= ANIMATION_STAND

func execute_event_user_2():
	# ///Destroy Variable in DSL Events
	queue_free()
