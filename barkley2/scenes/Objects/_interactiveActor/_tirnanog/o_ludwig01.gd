extends B2_InteractiveActor

## Made with B2_TOOL_DWARF_CONVERTER
func _ready() -> void:
	if B2_Playerdata.Quest("ludwigState") >= 5 or B2_Database.time_check("tnnCurfew") == "during":
		ActorAnim.animation = "gone"
		is_interactive = false
	if B2_Database.time_check("tnnCurfew") == "after":
		queue_free()
		
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

func execute_event_user_0():
	ActorAnim.animation = "gone"
	is_interactive = false
