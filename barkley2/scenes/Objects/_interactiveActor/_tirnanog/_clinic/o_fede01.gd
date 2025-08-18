extends B2_InteractiveActor
## Fede, member of the GAMING KLATCH
# the script for fede, a dude in the doctor's office
#Variables
	#fedeState
		#0 = not talked to Fede
		#1 = (not used)
		#2 = talked to Fede, guessed at the identity of the Game
		#3 = you failed the quest one way or another, he awaits "the knife"
		#4 = you accepted the Printed Invitation and can look for Milagros
		#5 = said you don't have the time to help, quest can still be activated by talking to again
#
	#fedeGame
		#0 = haven't guessed at the game
		#(string) = gets set to whatever game you chose

@export var cinema0 : B2_CinemaSpot
@export var cinema1 : B2_CinemaSpot

## Made with B2_TOOL_DWARF_CONVERTER
func _ready() -> void:
	if B2_Playerdata.Quest("govMedicine") == 2:
		queue_free()
		
	_setup_actor()
	_setup_interactiveactor()
	
	if B2_Database.time_check("fedeSurgery") == "after":
		B2_Playerdata.Quest("fedeStance", "laying");
	elif B2_Database.time_check("fedeDiagnose") == "after":
		B2_Playerdata.Quest("fedeStance", "sitting");
		position = cinema1.position
	else:
		B2_Playerdata.Quest("fedeStance", "standing");
		position = cinema0.position
	
	ANIMATION_STAND 						= "sitting"
	ANIMATION_SOUTH 						= ""
	ANIMATION_SOUTHEAST 					= ""
	ANIMATION_SOUTHWEST 					= ""
	ANIMATION_WEST 							= ""
	ANIMATION_NORTH 						= ""
	ANIMATION_NORTHEAST 					= ""
	ANIMATION_NORTHWEST 					= ""
	ANIMATION_EAST 							= ""
	ANIMATION_STAND_SPRITE_INDEX 			= [0, 0, 0, 0, 0, 0, 0, 0]
	ActorAnim.animation 					= "sitting"
	
	cinema_set( B2_Playerdata.Quest("fedeStance") )
