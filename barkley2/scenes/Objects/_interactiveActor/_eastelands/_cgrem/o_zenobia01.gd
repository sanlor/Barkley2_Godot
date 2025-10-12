extends B2_InteractiveActor

## variables
#zenobiaState
	#0 = haven't met Zenobia
	#1 = have met zenobia
#zenobiaEncounter
	#0 = this scene hasn't run, you haven't triggered the trap
	#1 = you have triggered the trap, Cauldron scene will now run
	#2 = you didn't have the Clispaeth Quest activated, you were dropped in the cauldron
	#3 = the Cauldron Scene has run and now you talk to zenobia in private, you've already activated the Clispaeth Quest
#relicSearch (what Hoopz says he'll look for.)
	#1 = The Iron Crown of Jackson
	#2 = The Veil of Valanciunas
	#3 = The Blood of Klisp
	#4 = The Scala Iactus
	#5 = The Mandyblue
	#6 = The Crown of Jalapenos
	#7 = The Shroud of Ballin'
	#8 = The Grape-topped Grail
	#9 = Boatloads of Trash
#cgremQuest
	#0 = you haven't started the quest
	#1 = the search is activated/started/unpaused
	#2 = the search is "paused" so that it turns off the "QUEST MARKERS" visual gag
	#3 = you've given the relio to the grems    
	#4 = you've talked to Irmingard after giving Zenobia the piece
		#
	#3 = you've found the particular "relicSearch" item
	#4 = you've been denied the "relicSearch" item, and now have to look for the cyberSpear piece
	#5 = you've found the Cyberspear Piece

@export var o_cinema0 : B2_CinemaSpot

## Made with B2_TOOL_DWARF_CONVERTER
func _ready() -> void:
	_setup_actor()
	_setup_interactiveactor()
	
	# Game name # Fetcher's Quest
	B2_Playerdata.Quest("gamename", B2_Vidcon.get_vidcon_name(31) );
	
	# Move to "home"
	if B2_Playerdata.Quest("cgremQuest") >= 1:
		assert( o_cinema0 )
		global_position = o_cinema0.global_position
	
	ANIMATION_STAND 						= "s_zenobia01"
	ANIMATION_SOUTH 						= " s_zenobiaSE"
	ANIMATION_SOUTHEAST 					= " s_zenobiaSE"
	ANIMATION_SOUTHWEST 					= " s_zenobiaSE"
	ANIMATION_WEST 							= " s_zenobiaSE"
	ANIMATION_NORTH 						= " s_zenobiaNE"
	ANIMATION_NORTHEAST 					= " s_zenobiaNE"
	ANIMATION_NORTHWEST 					= " s_zenobiaNE"
	ANIMATION_EAST 							= " s_zenobiaSE"
	ANIMATION_STAND_SPRITE_INDEX 			= [1, 1, 0, 0, 0, 0, 0, 1]
	ActorAnim.animation 					= "s_zenobia01"
	
## Relic name
func execute_event_user_1():
	var goomba666 = B2_Playerdata.Quest("relicSearch");
	match goomba666:
		1: B2_Playerdata.Quest("relicName", "The Iron Crown of Jackson")
		2: B2_Playerdata.Quest("relicName", "The Veil of Valanciunas")
		3: B2_Playerdata.Quest("relicName", "The Blood of Klisp")
		4: B2_Playerdata.Quest("relicName", "The Scala Iactus")
		5: B2_Playerdata.Quest("relicName", "The Mandyblue")
		6: B2_Playerdata.Quest("relicName", "The Crown of Jalapenos")
		7: B2_Playerdata.Quest("relicName", "The Shroud of Ballin'")
		8: B2_Playerdata.Quest("relicName", "The Grape-topped Grail")

# Lose skelly = Transhumanism change
func execute_event_user_2():
	var humBio = B2_Config.get_user_save_data("player.humanism.bio", 0)
	var humCyb = B2_Config.get_user_save_data("player.humanism.cyber", 0)
	if humBio - 30 > 30:
		humCyb += 30;
		humBio -= 30;
	else:
		humCyb += humBio;
		humBio = 0;
	B2_Config.set_user_save_data("player.humanism.bio", humBio)
	B2_Config.set_user_save_data("player.humanism.cyber", humCyb)
