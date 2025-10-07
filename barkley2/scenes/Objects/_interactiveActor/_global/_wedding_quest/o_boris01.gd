# Boris, flautsman extraordinaire
extends B2_InteractiveActor

## Made with B2_TOOL_DWARF_CONVERTER
func _ready() -> void:
	# Activation conditions for prison #
	if get_room_name() == "r_pri_prisonInside01":
		# Orange jumpsuit #
		ActorAnim.animation = "prison"

		# Deactivate if prison is liberated
		if B2_Playerdata.Quest("prisonLiberated") == 3: queue_free()

		# Don't show up if he hasn't been arrested.
		if B2_Playerdata.Quest("borisArrest") == 0: queue_free()

	# Activation conditions for industrial park #
	elif get_room_area() == "wst":
		# Don't show up if you arrested him.
		if B2_Playerdata.Quest("borisArrest") == 1: queue_free()

		# Don't show up if you recruited him for the wedding quest.
		if B2_Playerdata.Quest("borisWedding") == 1 and B2_ClockTime.time_gate() >= 4 and B2_ClockTime.time_gate() <= 10: queue_free()

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
