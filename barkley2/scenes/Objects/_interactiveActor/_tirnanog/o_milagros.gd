extends B2_InteractiveActor
# Milagros is the Ultimate Gamer Gal

## Made with B2_TOOL_DWARF_CONVERTER
func _ready() -> void:
	## TODO these conditions seem wrong.
	if get_room_name() == "r_tnn_marketDistrict01":
		if B2_Database.time_check("milagrosOpen") == "after" && B2_Database.time_check("tnnCurfew") != "during":
			queue_free()# pass
		else:
			pass# queue_free()
			
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
	
func execute_event_user_10():
	if B2_Shop.check_stock("Milagros' Palazzo") == 0: 	B2_Playerdata.Quest("shopEmpty", 1)
	else: 												B2_Playerdata.Quest("shopEmpty", 0)
