## Cherlindria, the source for the market crashing deposit
extends B2_InteractiveActor

##VARIABLES
#cherlindriaState
	#0 - haven't talked to her
	#1 - talked to her
#knowCherlindria
	#0 - haven't heard about Cherlindria
	#1 - have heard aboout her, know she's in the Hoosegow
	#2 - met her
#cherlindriaDossierCheck
	#0 - you don't have the Top Secret Dossier
	#1 - you DO have the Top Secret Dossier
#operationX
	#0 - haven't started the Operation Yet
	#1 - need to go get the Urine
	#2 - impersonating the governor
	#3 - told to go find Slag in The Social
	#4 - told to go to Lafayette in the FoOpBa
	#5 - told to go infiltrate the prison and talk to Cherlindria
	#6 - told to bring the Cashier's Cheque to Chandragupta
	#7 - told to confront and best the Guilderbergs
	#8 - must deposit the Cheque into the First Bank of Cuchulainn

## Made with B2_TOOL_DWARF_CONVERTER
func _ready() -> void:
	# Not in prison after liberation #
	if get_room_name() == "r_pri_prisonInside01" and B2_Playerdata.Quest("prisonLiberated") == 3:
		queue_free()

	# In rebel base after liberation #
	if get_room_name() == "r_pea_caveRebel01" and B2_Playerdata.Quest("prisonLiberated") != 3:
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

## Check for notes
func execute_event_user_1():
	if B2_Note.has_note("Sealed Secret Dossier") or B2_Note.has_note("Resealed Secret Dossier") or B2_Note.has_note("Re-resealed Secret Dossier") or B2_Note.has_note("Re-re-resealed Secret Dossier"):
		B2_Playerdata.Quest("cherlindriaDossierCheck", 1)
	else:
		B2_Playerdata.Quest("cherlindriaDossierCheck", 0)
