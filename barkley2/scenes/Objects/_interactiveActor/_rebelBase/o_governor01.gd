extends B2_InteractiveActor

## Made with B2_TOOL_DWARF_CONVERTER
func _ready() -> void:
	visible = false
	
	_setup_actor()
	_setup_interactiveactor()

	ANIMATION_STAND 						= "s_governor_crawl_right01"
	ANIMATION_SOUTH 						= " s_governor_crawlsniff_right01"
	ANIMATION_SOUTHEAST 					= " s_governor_crawlsniff_right01"
	ANIMATION_SOUTHWEST 					= " s_governor_crawlsniff_right01"
	ANIMATION_WEST 							= " s_governor_crawlsniff_right01"
	ANIMATION_NORTH 						= " s_governor_crawl_right01"
	ANIMATION_NORTHEAST 					= " s_governor_crawl_right01"
	ANIMATION_NORTHWEST 					= " s_governor_crawl_right01"
	ANIMATION_EAST 							= " s_governor_crawlsniff_right01"
	ANIMATION_STAND_SPRITE_INDEX 			= [1, 1, 0, 0, 0, 0, 0, 1]
	ActorAnim.animation 					= "s_governor_crawl_right01"
