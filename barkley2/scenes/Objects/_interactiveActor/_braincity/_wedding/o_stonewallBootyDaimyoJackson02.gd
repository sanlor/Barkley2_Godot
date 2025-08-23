extends B2_InteractiveActor

# Event for Stonewall 'Booty Daimyo' Jackson in Brain City. Part of Wedding Quest
# and Brain City Booty Bass

@export var o_polyWedding02 : B2_InteractiveActor
@export var o_guillaumeWedding02 : B2_InteractiveActor
@export var o_wayneWedding02 : B2_InteractiveActor
@export var o_garciaWedding02 : B2_InteractiveActor
@export var o_capnJaneWedding02 : B2_InteractiveActor
@export var o_dinahWedding02 : B2_InteractiveActor
@export var o_zalmoxisWedding02 : B2_InteractiveActor
@export var o_borisWedding02 : B2_InteractiveActor
@export var o_wizardWedding02 : B2_InteractiveActor

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

func execute_event_user_0():
	## Wedding is over, deactivate them all
	if B2_Playerdata.Quest("polyWedding") == 1:
		B2_Playerdata.Quest("polyWedding", 3);
		o_polyWedding02.queue_free()

	## Have Guillaume.
	if B2_Playerdata.Quest("guillaumeWedding") == 1:
		B2_Playerdata.Quest("guillaumeWedding", 3);
		o_guillaumeWedding02.queue_free()

	## Have Wayne.
	if B2_Playerdata.Quest("wayneWedding") == 1:
		B2_Playerdata.Quest("wayneWedding", 3);
		o_wayneWedding02.queue_free()

	## Have Garcia.
	if B2_Playerdata.Quest("garciaWedding") == 1:
		B2_Playerdata.Quest("garciaWedding", 3);
		o_garciaWedding02.queue_free()

	## Have Cap'n Jane.
	if B2_Playerdata.Quest("janeWedding") == 1:
		B2_Playerdata.Quest("janeWedding", 3);
		o_capnJaneWedding02.queue_free()

	## Have Dinah.
	if B2_Playerdata.Quest("dinahWedding") == 1:
		B2_Playerdata.Quest("dinahWedding", 3);
		o_dinahWedding02.queue_free()

	## Have Zalmoxis.
	if B2_Playerdata.Quest("zalmoxisWedding") == 1: 
		B2_Playerdata.Quest("zalmoxisWedding", 3);
		o_zalmoxisWedding02.queue_free()

	## Have Boris.
	if B2_Playerdata.Quest("borisWedding") == 1:
		B2_Playerdata.Quest("borisWedding", 3);
		o_borisWedding02.queue_free()

	## Have WIZARD.
	if B2_Playerdata.Quest("wizardWedding") == 1:
		B2_Playerdata.Quest("wizardWedding", 3);
		o_wizardWedding02.queue_free() 

	## It's over, finally ##  
	B2_Playerdata.Quest("weddingQuest", 3);
