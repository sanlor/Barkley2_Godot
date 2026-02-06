@tool
extends B2_ROOMS

const O_MG_VRW_TITLE = preload("uid://b5evdjjapm3in")

@export var skip_title := false

func _ready() -> void:
	RenderingServer.set_default_clear_color( Color.BLACK ) ## TEMP
	
	_set_region()
	
	# o_mg_vrw_control
	## Change dialog skin and BodySwap
	B2_CManager.BodySwap("untamo");
	B2_CManager.curr_DIAG_BOX = B2_CManager.DIAG_BOX.VRW
	
	B2_Screen.hide_hud( true )
	
	## Visited VRW at least once ##
	B2_Playerdata.Quest("vrwLoggedIn", 1);
	
	# o_mg_vrw_title
	if not skip_title:
		B2_Music.play("mus_dnet_track1", 0.0)
		var o_mg_vrw_title := O_MG_VRW_TITLE.instantiate()
		B2_Screen.call_deferred("add_child", o_mg_vrw_title, true )
		await o_mg_vrw_title.finished
	else: push_warning("O.O. Title skipped.")
	
	## Business as usual.
	B2_Music.play("mus_OligarchyOnline", 0.0)
	
	await get_tree().process_frame
	if play_cinema_at_room_start and is_instance_valid( cutscene_script ):
		B2_CManager.play_cutscene( cutscene_script, self, [] )
	elif B2_RoomXY.is_room_valid():
		B2_RoomXY.add_player_to_room( B2_RoomXY.get_room_pos(), true )
	else:
		_setup_camera( _setup_player_node() )
		
	## Disable camera offset
	B2_CManager.camera.follow_mouse = false

func _physics_process(_delta: float) -> void:
	if Engine.is_editor_hint():
		return
		
	if B2_CManager.o_hoopz: ## Map Wrap around
		if B2_CManager.o_hoopz.position.x <= 192:
			B2_CManager.o_hoopz.position.x += force_map_rect.size.x - 384;
			B2_CManager.camera.global_position = B2_CManager.o_hoopz.position
		if B2_CManager.o_hoopz.position.x + 192 >= force_map_rect.size.x:
			B2_CManager.o_hoopz.position.x -= force_map_rect.size.x - 384;
			B2_CManager.camera.global_position = B2_CManager.o_hoopz.position

func _on_tree_exiting() -> void:
	## Change to default dialog skin and BodySwap Hoopz
	B2_CManager.BodySwap("hoopz");
	B2_CManager.curr_DIAG_BOX = B2_CManager.DIAG_BOX.NORMAL
	B2_CManager.camera.follow_mouse = true
