extends B2_InteractiveActor

# Shopkeep.
# TODO actually setup the shop section.
#^ 14/03/26 Done for a while now

## NOTE This seems to have some unused part of a questline regarding a Gov Chip:

#GOV00
#DIALOG | Egidius | Greetings, Sir Governor! You're looking splendid in that uniform... I see it when I look at you... the vision of power! I hope it's satisfying you in every possible way. I hope your fitting was thorough enough. Does it require any alterations? Anything for you, sir! We in Tir na Nog, myself especially, are so grateful we may bask in Cuchulainn's glory for yet another day.
#QUEST  | egidiusGovernor = 1
## //IF milagrosChip == 1 | GOTO | GOVCHIP <<<<<<<<<<<<
#DIALOG | Governor Elagabalus | Yes of course, as your duly appointed Governor I declare this Jerkinry Among the City's Best.
#GOTO   | GOV01

##GOVCHIP
##DIALOG | Egidius | Why, sir Governor! Another day in paradise. Thank you! Thank you, sir! Thank you for your leadership and mercy! Please, take this offering. See? Contraband cyberware... I... I found it in a pocket, I was just about to report it.
##ITEM | Cu-tel Basilard HD 488x90 with QRI-3 | 1
##NOTIFY | Got the Cu-tel Basilard HD 488x90 with QRI-3!
##DIALOG | Governor Elagabalus | A computer chip? Much appreciated, um... good citizen!
##DIALOG | Egidius | Yes... yes...! Thank you! Thank you, sir! Thank you for your mercy!
##EXIT |

## ^ No idea what this can mean. TODO Check this questline.

@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var timer: Timer = $Timer

## Made with B2_TOOL_DWARF_CONVERTER
func _ready() -> void:
	_setup_actor()
	_setup_interactiveactor()
		
	# Curfew stuff
	#if B2_Database.time_check("tnnCurfew") != "before":
	if B2_Database.time_check("tnnCurfew") == "during":## 14/03/26 Changed this. o_egidius01 disappears during and after curfew, no reason for the shutters to be open.
		queue_free()
		
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
	
	##Egidius Root Shop Menu and Meeting
	#Variables
	#egidiusState
		#0 - never talked
		#1 - talked, had your "misunderstanding"
		#2 - talked and reconciled and can now shop
	#egidiusRental
		#1 - Learned about rental option
		#2 - Currently renting a Jerkin
		#3 - Have rented a jerkin once
	#egidiusRentalJerkin
		#Stores name of rented Jerkin
	#egidiusRentalInProgress
		#1 - Activate only when the shop is open to tell it you're renting
#
	#egidiusCollateral
#
	#egidiusTalking (for sewing animation to stop)
		#0 - Not talking to him
		#1 - Talking to him
		
func execute_event_user_1():
	## Check shop stock
	B2_Playerdata.Quest("egidiusStocks", B2_Shop.DB["Egidius' Jerkinry"]["stocks"].keys().size() )
	
func execute_event_user_2():
	## Precalculate money
	B2_Playerdata.Quest("egidiusRentalMoney", B2_Playerdata.Quest("money") );
	## NOTE Dunno what this is.
	## 15/06/25 Its used to rent jerkins. this is stupid, dont want to deal with this.
	
func execute_event_user_3(): 
	## Calculate money spent
	B2_Playerdata.Quest("egidiusRentalMoney", B2_Playerdata.Quest("egidiusRentalMoney") - B2_Playerdata.Quest("money"))
	## NOTE Dunno what this is.
	## 15/06/25 Its used to rent jerkins. this is stupid, dont want to deal with this.
	
func execute_event_user_4():
	## Unequip current jerkin if you no longer have
	#if (Jerkin("has", Jerkin("current")) == 0)
	#{
		#Jerkin("equip", "Cornhusk Jerkin");
		#with (o_hoopz) scr_player_genEffectiveStats();
	#}
	## NOTE Dunno what this is.
	pass

func _on_timer_timeout() -> void:
	#if B2_Playerdata.Quest("egidiusTalking") == 1:
	if not B2_Input.cutscene_is_playing:
		ActorAnim.play()
		audio_stream_player_2d.play()
	else:
		ActorAnim.stop()
		audio_stream_player_2d.stop()
