@tool
extends B2_ROOMS
# Hehe bct.

## The bridge room is a bit weird. Brainc city consists of 7 towers connected by bridges (or bridge - singular actually).
## This room has some weird control on the doors that changes the destiny depending on which tower you left.
## I decided that I preffer to create 7 bridge scenes, since its weird that all bridges have the same tilemap along with the same background.

# Left door:
	#case 0: RoomXY(r_bct_tower07, 496, 1040); break;
	#case 1: RoomXY(r_bct_tower01, 496, 1040); break;
	#case 2: RoomXY(r_bct_toweor02, 496, 1040); break;
	#case 3: RoomXY(r_bct_tower03, 496, 1040); break;
	#case 4: RoomXY(r_bct_tower04, 496, 1040); break;
	#case 5: RoomXY(r_bct_tower05, 496, 1040); break;
	#case 6: RoomXY(r_bct_tower06, 496, 1040); break;
# Right door:
	#case 0: RoomXY(r_bct_tower01, 16, 1040); break;
	#case 1: RoomXY(r_bct_tower02, 16, 1040); break;
	#case 2: RoomXY(r_bct_tower03, 16, 1040); break;
	#case 3: RoomXY(r_bct_tower04, 16, 1040); break;
	#case 4: RoomXY(r_bct_tower05, 16, 1040); break;
	#case 5: RoomXY(r_bct_tower06, 16, 1040); break;
	#case 6: RoomXY(r_bct_tower07, 16, 1040); break;

func _ready() -> void:
	RenderingServer.set_default_clear_color( Color.BLACK ) ## TEMP
	
	_set_region()
	
	await get_tree().process_frame
	if play_cinema_at_room_start and is_instance_valid( cutscene_script ):
		B2_CManager.play_cutscene( cutscene_script, self, [] )
	elif B2_RoomXY.is_room_valid():
		B2_RoomXY.add_player_to_room( B2_RoomXY.get_room_pos(), true )
	else:
		_setup_camera( _setup_player_node() )
