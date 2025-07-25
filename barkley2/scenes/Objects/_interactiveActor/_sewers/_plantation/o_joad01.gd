extends B2_InteractiveActor

# Joad the Dying Dwarf, gives Note or Scroll
#Variables
	#joadState
		#0 - never met
		#1 - dead, know him as "Dead Soldier"
		#2 - dead, know him as "Sgt. Joad"
		#3 - dead, only got Bloody Paper

## Very long script.
# NOTE headup animation seems wrong, but its like that in the original.

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
