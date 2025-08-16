extends B2_Duergar

## Made with B2_TOOL_DWARF_CONVERTER
func _ready() -> void:
	# These scripts are for the Dwarf Crushing Quest, see o_tnn_batteredDwarf01,
	# o_slag01 and o_tnn_crusher01 for the rest of the events and objects
	
	if get_room_name() == "r_tnn_warehouse01":
		if B2_Playerdata.Quest("lugnerQuest") == 4: queue_free()
		elif B2_Playerdata.Quest("lugnerQuest") == 5: global_position = Vector2( 40, 568)
		elif B2_Playerdata.Quest("lugnerQuest") == 6: pass
		else: queue_free()
	
	duergar_name 							= "lugner"
	_setup_actor()
	_setup_interactiveactor()

	ANIMATION_STAND 						= "s_lugner01"
	ANIMATION_SOUTH 						= "s_lugnerSE"
	ANIMATION_SOUTHEAST 					= "s_lugnerSE"
	ANIMATION_SOUTHWEST 					= "s_lugnerSE"
	ANIMATION_WEST 							= "s_lugnerSE"
	ANIMATION_NORTH 						= "s_lugnerNE"
	ANIMATION_NORTHEAST 					= "s_lugnerNE"
	ANIMATION_NORTHWEST 					= "s_lugnerNE"
	ANIMATION_EAST 							= "s_lugnerSE"
	ANIMATION_STAND_SPRITE_INDEX 			= [1, 1, 0, 0, 0, 0, 0, 1]
	ActorAnim.animation 					= "s_lugner01"

## Lugner attack
func execute_event_user_0():
	breakpoint ## Not set yet
