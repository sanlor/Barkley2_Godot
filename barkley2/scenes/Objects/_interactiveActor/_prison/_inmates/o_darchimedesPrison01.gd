extends B2_InteractiveActor

## NOTE!!!!! This stupid actor is responsible to remove a exploded toilet.
# Check o_broken_terlet01
# Check oPrisonToiletHole

@export var o_broken_terlet01 : AnimatedSprite2D

#VARIABLES
#prisonDistress
	#0 = the Prison quest hasn't been initiated
	#1 = the first "rumblings" have been experienced
	#2 = flavor response for the terlet
	#3 = the second "rumblings" have been experienced
	#4 = flavor response for the terlet
	#5 = the third "rumblings" have been experienced
	#6 = you have the Cherry Bomb, or we've moved passed the distress point
#darchimedesPrisonQuest
	#0 = haven't heard of the plan to blast the terlet
	#1 = have heard of the plan
#darchimedesPrisonState
	 #0 = haven't talked to D'archimedes
	 #1 = have spoken once
#kunigundePrisonShank
	#0 = haven't agreed to shank D'archimedes
	#1 = have agreed to shank
	#2 = shanked D'archimedes
#sureshPrisonShank
	#0 = haven't agreed to shank D'archimedes
	#1 = have agreed to shank
	#2 = shanked D'archimedes

## Made with B2_TOOL_DWARF_CONVERTER
func _ready() -> void:
	if B2_Playerdata.Quest("prisonLiberated") == 3:
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

# Switch to broken
func execute_event_user_2():
	# Explode the toilet
	pass
	
# Switch to broken divider
func execute_event_user_3():
	pass
	
# This saves the note selected so it can be "given"
func execute_event_user_4():
	pass
