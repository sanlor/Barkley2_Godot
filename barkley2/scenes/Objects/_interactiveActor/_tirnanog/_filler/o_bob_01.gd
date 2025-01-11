extends B2_InteractiveActor

var weird_animation := false

## Made with B2_TOOL_DWARF_CONVERTER
func _ready() -> void:
	_setup_actor()
	_setup_interactiveactor()

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

func execute_event_user_5():
	pass

func _physics_process(_delta: float) -> void:
	if not weird_animation:
		
		match ActorAnim.frame:
			14:
				if randf() < 0.4:
					weird_animation = true
					ActorAnim.stop()
					await get_tree().create_timer( 3 * randf() ).timeout
					ActorAnim.play()
					ActorAnim.frame = 0
					weird_animation = false
			24:
				if randf() < 0.4:
					weird_animation = true
					ActorAnim.stop()
					await get_tree().create_timer( 3 * randf() ).timeout
					ActorAnim.play()
					ActorAnim.frame = 14
					weird_animation = false
