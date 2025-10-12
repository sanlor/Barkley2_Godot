extends B2_InteractiveActor

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

func execute_event_user_5():
	#/// Generate guns based on shop type
	#var luck = scr_savedata_get("player.stats.effective." + STAT_BASE_LUCK);
	#// qal exists so you can have different gun qualities over time / through quests
	#qal = Quest("shopQuality");
	#if (qal == 0 && gunLoad[qal] == 0)
	#{
		#gunLoad[qal] = 1;
		#shpGun[qal, 0] = Drop("generate", luck, "kosmic pistol", "FUND");
		#shpGun[qal, 1] = Drop("generate", luck, "kosmic rifle", "GIRF");
		#shpGun[qal, 2] = Drop("generate", luck, "kosmic shotgun", "SGUN");
		#shpGun[qal, 3] = Drop("generate", luck, "kosmic projectile", "GIRF");
		#shpGun[qal, 4] = Drop("generate", luck, "kosmic mounted", "SGUN");
	#// Set price of guns from 5 - 10 dollars
	#for (i = 0; i < 5; i += 1) shpPrc[qal, i] = 5 + irandom(5); 
	#}
#
	#// IGNORE below here - Load prices
	#var shp = ds_list_find_index(global.shopName, shopName);
	#var shpCos = ds_list_find_value(global.shopCost, shp);
	#for (i = 0; i < 5; i += 1) shpCos[| i] = shpPrc[qal, i];
	breakpoint
	
func execute_event_user_6():
	#/// Ran after shop is closed
	#qal = 0;
	#var gunAmt = 0;
	#for (i = 0; i < 5; i += 1)
	#{
		#gunAmt += gunBuy[qal, i];
	#}
	#if (gunAmt == 5) // bought all 5
	#{
		#if (qal == 0) Quest("redfieldShop50Empty", 1);
	#}
	breakpoint
