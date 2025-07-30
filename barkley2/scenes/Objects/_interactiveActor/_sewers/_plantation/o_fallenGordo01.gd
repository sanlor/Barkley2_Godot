extends B2_InteractiveActor

##Fallen Gordo, grotesque ruler of the plantation
#Variables
#gordoState
	#0 - never talked
	#1 - talked
	#2 - gordo is dead, repeating value
	#-----3 - gordo is basically dead, choking on the slow garlics
#gordoAskWhere
	#0 - haven't asked where you are
	#1 - have asked where you are, won't ask again

## Made with B2_TOOL_DWARF_CONVERTER
func _ready() -> void:
	## Dead? ##
	if B2_Playerdata.Quest("gordoState") == 2:
		ActorAnim.animation = "dead"
		
	B2_Playerdata.Quest("bossColor", B2_Gamedata.c_cyber);
	B2_Playerdata.Quest("bossName", "B.A.B.B.Y. System");
	B2_Playerdata.Quest("bossDescription", "Gerder of Gordo");
		
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

##  Set battlemode
func execute_event_user_1():
	push_error("Battle mode not set.")
	
	B2_Playerdata.Quest("marqueeBossName", "B.A.B.B.Y. ");
	B2_Playerdata.Quest("marqueeBossHealth", 1);
	
	breakpoint
	
## ???
func execute_event_user_2():
	#robotto.visAct = 1;
	#global.battleMode = 1;  
	pass

## BABBY active
func execute_event_user_3():
	# robotto.visDes = 1
	pass
	
## Disable the machine hum
func execute_event_user_4():
	# with o_sfx_audio_emitter_parent timer_remove = irandom(3) + 1;
	pass
