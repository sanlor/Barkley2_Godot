extends B2_ROOMS

@onready var o_door_tech_01_vents: 	B2_Door_Tech 	= $o_door_tech01_vents
@onready var o_roethlisbuergar_01: 	B2_Duergar 		= $o_roethlisbuergar01
@onready var o_archambeau_01: 		B2_Duergar		 = $o_archambeau01
@onready var o_cinema_14: 			B2_CinemaSpot 	= $o_cinema14

func _ready() -> void:
	# change the gray BG to Black during runtime
	RenderingServer.set_default_clear_color( Color.BLACK ) ## TEMP
	_set_region()
	
	await get_tree().process_frame
	
	if B2_RoomXY.is_room_valid():
		B2_RoomXY.add_player_to_room( B2_RoomXY.get_room_pos(), true )
	else:
		_setup_camera( _setup_player_node() )
		
	# Hide Duergar.
	o_archambeau_01.modulate.a = 0.0
		
	if B2_Playerdata.Quest("tutorialCspear") == 1:
		o_door_tech_01_vents.is_open = false
		o_door_tech_01_vents.locked = true
		o_door_tech_01_vents.door_close( true )
		
		o_roethlisbuergar_01.position = o_cinema_14.position
		
		B2_Sound.set_loop_volume( 0.5 )
