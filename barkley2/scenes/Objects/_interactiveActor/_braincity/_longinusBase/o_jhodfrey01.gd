extends B2_InteractiveActor

func _ready() -> void:
	_setup_actor()
	_setup_interactiveactor()
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
	ANIMATION_STAND_SPRITE_INDEX 	= [ 1, 1, 0, 0, 0, 0, 0, 1 ]
	ActorAnim.animation 		= ANIMATION_STAND

func execute_event_user_2():
	# ///Destroy Variable in DSL Events
	queue_free()
