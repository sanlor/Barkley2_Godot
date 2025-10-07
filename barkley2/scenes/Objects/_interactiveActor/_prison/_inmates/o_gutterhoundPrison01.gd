extends B2_InteractiveActor

##VARIABLES
	#gutterhoundQuest 
		#0 = Gutterhound hasn't been spoken to.
		#1 = You talked to him but haven't listened to Gutterhound's scheme.
		#2 = You refuse Gutterhound's offer.
		#3 = You've refused Gutterhound's offer twice. Can't get it again.
		#4 = Gutterhound's quest has been accepted.  Gutterhound and Marquee will remind Hoopz to get back to talk to Gutterhound
		#5 = You've nominated to hide in the safe house
		#6 = You've nominated to forgoe the safehouse
		#7 = Gutterhound robbed the bank WITH you
		#8 = Gutterhound robbed the bank WITHOUT you
#gutterhoundPrison
#0 = haven't talked to Gutterhound
#1 = have talked in prison but never met him before in TNN so the quest fails
#2 = have talked to in prison and gave pack of smokes

@export var o_cinema17 : B2_CinemaSpot

## Made with B2_TOOL_DWARF_CONVERTER
func _ready() -> void:
	assert( o_cinema17 )
	if B2_Playerdata.Quest("gutterhoundArrest") == 0: queue_free()
	if B2_Playerdata.Quest("gutterhoundPrisonEscape") == 1:
		position = o_cinema17.position
	elif B2_Playerdata.Quest("gutterhoundPrisonEscape") == 2: queue_free()

	# Deactivate if prison is liberated
	if B2_Playerdata.Quest("prisonLiberated") == 3: queue_free()
	
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
