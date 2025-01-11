extends B2_InteractiveActor

# Shopkeep.
# TODO actually setup the shop section.

## Made with B2_TOOL_DWARF_CONVERTER
func _ready() -> void:
	_setup_actor()
	_setup_interactiveactor()
		
	# Curfew stuff
	if B2_Database.time_check("tnnCurfew") != "before":
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
	#Quest("egidiusStocks", Shop("stocks", "Egidius' Jerkinry"));
	## TODO add shop function.
	pass
func execute_event_user_2():
	## Precalculate money
	#Quest("egidiusRentalMoney", scr_money_count());
	## NOTE Dunno what this is.
	pass
func execute_event_user_3(): 
	## Calculate money spent
	#Quest("egidiusRentalMoney", Quest("egidiusRentalMoney") - scr_money_count());
	## NOTE Dunno what this is.
	pass
func execute_event_user_4():
	## Unequip current jerkin if you no longer have
	#if (Jerkin("has", Jerkin("current")) == 0)
	#{
		#Jerkin("equip", "Cornhusk Jerkin");
		#with (o_hoopz) scr_player_genEffectiveStats();
	#}
	## NOTE Dunno what this is.
	pass
