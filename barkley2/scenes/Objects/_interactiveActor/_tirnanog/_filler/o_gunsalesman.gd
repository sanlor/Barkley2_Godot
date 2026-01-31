extends B2_InteractiveActor

## Redfield the Gun'ssalesman
# (He's Chris, we don't even try to hide it. And he's lost a lot of good partners.)
	#redfieldState
		#0 - never talked
		#1 - talked, sends you to PURCHASER
	#redfieldPast
		#0 - haven't asked about his past
		#1 - have asked about his past, gotten some stupid details
# How he works:
#you have to have a knowledgeVariable of knowGunstiers to a certain level, when you, you 
	#knowGunstiers
		#0 - only get 50 point gun's
		#1 - get 70 point gun's
	#stahlGuns
	#1 - learned you can get better stuff from redfield from stahl
	#2 - told redfield that stahl sent you, have access to better stuff

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
	
	execute_event_user_10()

## NOTE Its missing a lot of stuff.
## check user event 10, pretty important

# check o_gunsalesman
## Generate guns based on shop type
func execute_event_user_5(): 
	var qal := 0;
	if B2_Playerdata.Quest("redfieldPoint") == 70: qal = 1
	if B2_Playerdata.Quest("redfieldPoint") == 90: qal = 2
	var luck : int = B2_Playerdata.player_stats.get_effective_stat( B2_HoopzStats.STAT_BASE_LUCK ) ## TODO Add luck
	
	B2_Shop.gun_inventory.clear()
	B2_Shop.gun_prices.clear()
	B2_Shop.gun_inventory.resize(5)
	B2_Shop.gun_prices.resize(5)
	
	if qal == 0:
		B2_Shop.gun_inventory[ 0 ] = B2_Gun.get_gun_from_db("kosmic pistol", "FUND")
		B2_Shop.gun_inventory[ 1 ] = B2_Gun.get_gun_from_db("kosmic rifle", "GIRF")
		B2_Shop.gun_inventory[ 2 ] = B2_Gun.get_gun_from_db("kosmic shotgun", "SGUN")
		B2_Shop.gun_inventory[ 3 ] = B2_Gun.get_gun_from_db("kosmic projectile", "GIRF")
		B2_Shop.gun_inventory[ 4 ] = B2_Gun.get_gun_from_db("kosmic mounted", "SGUN")
		
		B2_Shop.gun_prices[ 0 ]		= 5 + randi_range(0,5)
		B2_Shop.gun_prices[ 1 ]		= 5 + randi_range(0,5)
		B2_Shop.gun_prices[ 2 ]		= 5 + randi_range(0,5)
		B2_Shop.gun_prices[ 3 ]		= 5 + randi_range(0,5)
		B2_Shop.gun_prices[ 4 ]		= 5 + randi_range(0,5)
	if qal == 1:
		B2_Shop.gun_inventory[ 0 ] = B2_Gun.get_gun_from_db("zauber pistol", "HELL")
		B2_Shop.gun_inventory[ 1 ] = B2_Gun.get_gun_from_db("zauber rifle", "NIFF")
		B2_Shop.gun_inventory[ 2 ] = B2_Gun.get_gun_from_db("zauber shotgun", "GOOP")
		B2_Shop.gun_inventory[ 3 ] = B2_Gun.get_gun_from_db("zauber projectile", "GOOP")
		B2_Shop.gun_inventory[ 4 ] = B2_Gun.get_gun_from_db("zauber mounted", "GOOP")
		
		B2_Shop.gun_prices[ 0 ]		= 10 + randi_range(0,5)
		B2_Shop.gun_prices[ 1 ]		= 10 + randi_range(0,5)
		B2_Shop.gun_prices[ 2 ]		= 10 + randi_range(0,5)
		B2_Shop.gun_prices[ 3 ]		= 10 + randi_range(0,5)
		B2_Shop.gun_prices[ 4 ]		= 10 + randi_range(0,5)
	if qal == 2:
		B2_Shop.gun_inventory[ 0 ] = B2_Gun.get_gun_from_db("turald best", "ABCD")
		B2_Shop.gun_inventory[ 1 ] = B2_Gun.get_gun_from_db("turald best", "WXYZ")
		B2_Shop.gun_inventory[ 2 ] = B2_Gun.get_gun_from_db("turald best", "AAAA")
		B2_Shop.gun_inventory[ 3 ] = B2_Gun.get_gun_from_db("turald best", "OOOO")
		B2_Shop.gun_inventory[ 4 ] = B2_Gun.get_gun_from_db("turald best", "HOOP")
		
		B2_Shop.gun_prices[ 0 ]		= 15 + randi_range(0,5)
		B2_Shop.gun_prices[ 1 ]		= 15 + randi_range(0,5)
		B2_Shop.gun_prices[ 2 ]		= 15 + randi_range(0,5)
		B2_Shop.gun_prices[ 3 ]		= 15 + randi_range(0,5)
		B2_Shop.gun_prices[ 4 ]		= 15 + randi_range(0,5)
		
	print("loaded Redfield's guns")
	
func execute_event_user_6(): 
	var qal := 0;
	if B2_Playerdata.Quest("redfieldPoint") == 70: qal = 1
	if B2_Playerdata.Quest("redfieldPoint") == 90: qal = 2
	
	## TODO Add a way to check for bought weapons
	var gunAmt := 0;
	
	if B2_Shop.bought_items.has("Redfield's Wares"):
		gunAmt = B2_Shop.bought_items["Redfield's Wares"].size()
		
	if gunAmt == 5: ## bought all 5
		if qal == 0: B2_Playerdata.Quest("redfieldShop50Empty", 1)
		if qal == 1: B2_Playerdata.Quest("redfieldShop70Empty", 1)
		if qal == 2: B2_Playerdata.Quest("redfieldShop90Empty", 1)

# Placement system
func execute_event_user_10() -> void:
	var time 		:= B2_ClockTime.time_get()
	var newArea 	:= "";
	var oldArea 	: String = B2_Playerdata.Quest("redfieldLastArea", null, "");

	# The first area is 0 - 30 minutes in, second area is 30-60 minutes in, etc
	var dslArea := []
	dslArea.append("r_tnn_warehouseDistrict01");
	dslArea.append("r_tnn_residentialDistrict01");
	dslArea.append("r_sw1_descent01"); #r_tnn_marketDistrict01);
	dslArea.append("r_sw1_descent01"); #r_tnn_maingate02);
	dslArea.append("r_sw1_descent01"); #r_tnn_businessDistrict01);
	dslArea.append("r_sw1_descent01"); #r_tnn_bballcourt02);
	dslArea.append("r_tnn_bballcourt_transition01");
	dslArea.append("r_tnn_boardinghouse01"); #3;30
	dslArea.append("r_sw1_manholeWest01");
	dslArea.append("r_sw1_manholeEast01");
	dslArea.append("r_sw1_respawn01");
	dslArea.append("r_sw1_floor2Access01");
	
	for i in dslArea:
		var are = dslArea[i]
		if (time < (i + 1) * 0.5): 
			newArea = are
			break

	if (get_room_name() == "r_tnn_marketDistrict01"): 				ActorAnim.flip_h = true
	elif (get_room_name() == "r_tnn_maingate02"): 					ActorAnim.flip_h = true
	elif (get_room_name() == "r_tnn_bballcourt02"): 				ActorAnim.flip_h = true
	elif (get_room_name() == "r_tnn_bballcourt_transition01"): 		ActorAnim.flip_h = true
	elif (get_room_name() == "r_sw1_manholeEast01"): 				ActorAnim.flip_h = true
	elif (get_room_name() == "r_sw1_respawn01"): 					ActorAnim.flip_h = true
	elif (get_room_name() == "r_sw1_floor2Access01"): 				ActorAnim.flip_h = true
	elif (get_room_name() == "r_sw1_descent01"): 					ActorAnim.flip_h = true
	else: 															ActorAnim.flip_h = false

	## NOTE bellow seems to be some patchwork code. I wonder if it works as the old devs expected.
	#show_debug_message("Redfield - " + room_get_name(newArea) + " - OLD = " + room_get_name(oldArea));
	if get_room_name() == newArea:
		if true: #newArea != oldArea)
			B2_Playerdata.Quest("redfieldLastArea", newArea);
			B2_Playerdata.Quest("redfieldTalked", 0);
			B2_Playerdata.Quest("redfieldShop50Empty", 0);
			B2_Playerdata.Quest("redfieldShop70Empty", 0);
			## NOTE disabled the condition below on a whim. No idea what its supposed to do.
			#if newArea == "r_tnn_boardinghouse01":
			#	with (o_door_parent)
			#		if (name == "redfield")
			#			event_user(1);
	else:
		queue_free()
