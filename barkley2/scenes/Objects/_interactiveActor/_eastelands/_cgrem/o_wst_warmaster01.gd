extends B2_InteractiveActor

## Made with B2_TOOL_DWARF_CONVERTER
func _ready() -> void:
	_setup_actor()
	_setup_interactiveactor()
	
	#/// Create
	#event_inherited();
	#scr_event_hook_onCommon(event_cinema);
	#shopName = "War Warez";
	#event_user(0);
#
	#// 5 quality shop set-up
	#for (q = 0; q < 5; q += 1) // Quality
	#{
	#gunLoad[q] = 0;
	#for (i = 0; i < 5; i += 1) gunBuy[q, i] = 0;
	#}
	
	ANIMATION_STAND 						= "default"
	ANIMATION_SOUTH 						= " s_cgrem_henchman02_SE"
	ANIMATION_SOUTHEAST 					= " s_cgrem_henchman02_SE"
	ANIMATION_SOUTHWEST 					= " s_cgrem_henchman02_SE"
	ANIMATION_WEST 							= " s_cgrem_henchman02_SE"
	ANIMATION_NORTH 						= " s_cgrem_henchman02_NE"
	ANIMATION_NORTHEAST 					= " s_cgrem_henchman02_NE"
	ANIMATION_NORTHWEST 					= " s_cgrem_henchman02_NE"
	ANIMATION_EAST 							= " s_cgrem_henchman02_SE"
	ANIMATION_STAND_SPRITE_INDEX 			= [1, 1, 0, 0, 0, 0, 0, 1]
	ActorAnim.animation 					= "default"

func execute_event_user_5():
	## Generate guns based on shop type
	#var luck = scr_savedata_get("player.stats.effective." + STAT_BASE_LUCK);
	## qal exists so you can have different gun qualities over time / through quests
	#qal = 0;
	#if (qal == 0 && gunLoad[qal] == 0):
		#gunLoad[qal] = 1;
		#shpGun[qal, 0] = Drop("generate", luck, "kosmic pistol", "KRAP");
		#shpGun[qal, 1] = Drop("generate", luck, "kosmic pistol", "KARP");
		#shpGun[qal, 2] = Drop("generate", luck, "kosmic pistol", "KOOL");
		#shpGun[qal, 3] = Drop("generate", luck, "kosmic pistol", "KELP");
		#shpGun[qal, 4] = Drop("generate", luck, "kosmic pistol", "KAIN");
		## Set price of guns from 5 - 10 dollars
		#for (i = 0; i < 5; i += 1) shpPrc[qal, i] = 5 + irandom(5); 
#
	## IGNORE below here - Load prices
	#var shp = ds_list_find_index(global.shopName, shopName);
	#var shpCos = ds_list_find_value(global.shopCost, shp);
	#for (i = 0; i < 5; i += 1) shpCos[| i] = shpPrc[qal, i];
	push_error("TODO Add shop stuff")
	
func execute_event_user_6():
	## Ran after shop is closed
	#qal = 0;
	#if (Quest("redfieldPoint") == 70) qal = 1;
	#var gunAmt = 0;
	#for (i = 0; i < 5; i += 1)
	#{
		#gunAmt += gunBuy[qal, i];
	#}
	#if (gunAmt == 5) # bought all 5
	#{
		#if (qal == 0) Quest("redfieldShop50Empty", 1);
		#if (qal == 1) Quest("redfieldShop70Empty", 1);
	#}
	push_error("TODO Add shop stuff")
