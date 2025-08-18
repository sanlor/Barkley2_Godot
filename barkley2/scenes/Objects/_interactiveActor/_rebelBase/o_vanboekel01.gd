extends B2_InteractiveActor

@onready var timer: Timer = $Timer
var prision := false

## Made with B2_TOOL_DWARF_CONVERTER
func _ready() -> void:
	if get_room_name() == "r_pri_prisonInside01":
		if B2_Playerdata.Quest("rebelsArrest") == 0:
			queue_free()
	else:
		prision = true
	
	_setup_actor()
	_setup_interactiveactor()

	ANIMATION_STAND 						= "pause"
	ANIMATION_SOUTH 						= ""
	ANIMATION_SOUTHEAST 					= ""
	ANIMATION_SOUTHWEST 					= ""
	ANIMATION_WEST 							= ""
	ANIMATION_NORTH 						= ""
	ANIMATION_NORTHEAST 					= ""
	ANIMATION_NORTHWEST 					= ""
	ANIMATION_EAST 							= ""
	ANIMATION_STAND_SPRITE_INDEX 			= [0, 0, 0, 0, 0, 0, 0, 0]
	ActorAnim.animation 					= "pause"

func _on_timer_timeout() -> void:
	timer.start( randf_range(2.0,8.0) )
	if prision:
		cinema_playset( "pri_play", "pri_pause" )
	else:
		cinema_playset( "play", "pause" )
