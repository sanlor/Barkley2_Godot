# Suresh the Trash Loving Convict
extends B2_InteractiveActor

##VARIABLES
#prisonQuest (modified by o_prisonBedHoopz01)
#0 = have not advanced the quest at all
		#1 = starts when the cell doors close after the Bolthios Scene (must "restpause")
		#2 = on room load after restpausing in bed, initiate 20 minutes until state = 3
		#3 = Hoopz can now restpause to next hour
		#4 = Hoopz has restpaused, initiate 20 minutes until state = 5
		#5 = Hoopz can now restpause to next hour
		#6 = Hoopz has restpaused, initiate 20 minutes until state = 7
		#7 = Hoopz is at the end of his (gut) rope
#sureshPrisonShank
	#0 = haven't agreed to shank D'archimedes
	#1 = have agreed to shank D'archimedes
#shankPending
	#0 = you've not offended an MS-13 character
	#1 = you have offended them, Shank Scene is activated
	#2 = you've been shanked

## Made with B2_TOOL_DWARF_CONVERTER
func _ready() -> void:
	# Deactivate if prison is liberated
	if B2_Playerdata.Quest("prisonLiberated") == 3: queue_free()

	# Deactivate if he isn't arrested
	if B2_Playerdata.Quest("sureshArrest") != 1: queue_free()
	
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
