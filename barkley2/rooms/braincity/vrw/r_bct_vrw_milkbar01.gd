@tool
extends B2_ROOMS

## NOTE this room had a cutscene called "event_bct_trigal01". This cutscene doesnt exist anymore, but is referenced by the "script_purgatory" folder.
# https://github.com/sanlor/Barkley2_Original/blob/91b27766d4cc32912342564aa35ab94992d9a8ce/barkley_2/script_purgatory/event_bct_trigal01.txt#L2
# https://github.com/sanlor/Barkley2_Original/blob/91b27766d4cc32912342564aa35ab94992d9a8ce/barkley_2/Design/script_conversion/locations.txt#L438

func _ready() -> void:
	RenderingServer.set_default_clear_color( Color.BLACK ) ## TEMP
	
	_set_region()
	
	# o_mg_vrw_control
	## Change dialog skin and BodySwap
	B2_CManager.BodySwap("untamo");
	B2_CManager.curr_DIAG_BOX = B2_CManager.DIAG_BOX.VRW
	
	## Visited VRW at least once ##
	B2_Playerdata.Quest("vrwLoggedIn", 1);
	
	## Business as usual.
	#B2_Music.play("mus_OligarchyOnline", 0.0)
	
	## DEBUG
	B2_Playerdata.Quest("longinusDoorState", 1)
	push_warning("DEBUG Variable set.")
	
	await get_tree().process_frame
	if play_cinema_at_room_start and is_instance_valid( cutscene_script ):
		B2_CManager.play_cutscene( cutscene_script, self, [] )
	elif B2_RoomXY.is_room_valid():
		B2_RoomXY.add_player_to_room( B2_RoomXY.get_room_pos(), true )
	else:
		_setup_camera( _setup_player_node() )
		
	## Hide hud
	B2_Playerdata.Quest("hudVisible", 0)
	B2_Screen.hide_hud( true )
		
	## Disable camera offset
	B2_Playerdata.Quest("FollowMouseDisabled", 1)
	B2_CManager.camera.follow_mouse = false
	
func _on_tree_exiting() -> void:
	## Change to default dialog skin and BodySwap Hoopz
	B2_CManager.BodySwap("hoopz");
	B2_Playerdata.Quest("FollowMouseDisabled", 0)
	B2_Playerdata.Quest("hudVisible", 1)
	B2_CManager.curr_DIAG_BOX = B2_CManager.DIAG_BOX.NORMAL
	B2_CManager.camera.follow_mouse = true
