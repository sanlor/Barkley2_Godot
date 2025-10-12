## Mekhanes, the Hiking Dwarf and Plot Resolver
extends B2_InteractiveActor

#VARIABLES - 
#operationX
	#0 - haven't started the Operation Yet
	#1 - need to go get the Urine
	#2 - impersonating the governor
	#3 - told to go find Slag in The Social
	#4 - told to go to Lafayette in the FoOpBa
	#5 - told to go infiltrate the prison and talk to Cherlindria
	#6 - told to bring the Cashier's Check to Chandragupta
	#7 - told to confront and best the Guilderbergs
	#8 - must deposit the check into the First Bank of Cuchulainn
#
#THESE ARE SET BY THE CREATE EVENT
#mekhanesSlag
	#1 - delivers Resealed Secret Dossier from Dr. Liu, says to go find Slag
#
#mekhanesLafayette
	#1 - delivers Re-re-resealed Secret Dossier, from Slag go find Lafayette
	#2 - exchanges Resealed for Re-resealed Dossier, says Slag lost his patience, go find Lafayette
#
#mekhanesChandragupta
	#1 - delivers Re-re-re-re-resealed Secret Dossier, says there was a prisoner named Cherlindria... she tried to escape, lost her life... told me to give you this... go find Chandragupta
	#2 - exchanges Resealed Secret Dossier to Re-resealed Dossier, says that Slag lost his patience, go find Chandragupta
	#3 - exchanges Re-resealed Secret Dossier for the Re-re-resealed Dossier, says that Lafayette said to FIND you and process the Dossier... go see Chandragupta
	#4 - the prisoner Cherlindria was executed... I was told exchange the Re-re-resealed Dossier to a Re-re-re-resealed Dossier.
#
#mekhanesRemind
	#1 - turns on the remind sorter for flavor dialog after getting the Dossier "catch up"

## Made with B2_TOOL_DWARF_CONVERTER
func _ready() -> void:
	_setup_actor()
	_setup_interactiveactor()
	
	# Activations
	if B2_Database.time_check("opX_slagSocial") == "during":
		if B2_Playerdata.Quest("mekhanesRemind") == 1 || B2_Playerdata.Quest("operationX") <= 2:
			B2_Playerdata.Quest("mekhanesSlag", 1)
		else: queue_free()
		
	elif B2_Database.time_check("opX_Foopba") == "during":
		if B2_Playerdata.Quest("mekhanesRemind") == 1 || B2_Playerdata.Quest("operationX") <= 2:
			B2_Playerdata.Quest("mekhanesLafayette", 1)
		elif B2_Playerdata.Quest("operationX") <= 3:
			B2_Playerdata.Quest("mekhanesLafayette", 2)
		else: queue_free()
		
	elif B2_Database.time_check("opX_Chandragupta") == "during":
		if B2_Playerdata.Quest("mekhanesRemind") == 1 || B2_Playerdata.Quest("operationX") <= 2:
			B2_Playerdata.Quest("mekhanesChandragupta", 1)
		elif B2_Playerdata.Quest("operationX") <= 3:
			B2_Playerdata.Quest("mekhanesChandragupta", 2)
		elif B2_Playerdata.Quest("operationX") <= 4:
			B2_Playerdata.Quest("mekhanesChandragupta", 3)
		elif B2_Playerdata.Quest("operationX") <= 5 && B2_Playerdata.Quest("prisonEnding") == 0:
			B2_Playerdata.Quest("mekhanesChandragupta", 4)
		else: queue_free()
		
	else: queue_free()

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
