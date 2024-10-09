extends B2_ROOMS

@onready var r_fct_access_hall_collision: TileMapLayer = $r_fct_accessHall_collision


func _ready() -> void:
	# change the gray BG to Black during runtime
	RenderingServer.set_default_clear_color( Color.BLACK ) ## TEMP
	
	_init_pathfind()
	_update_pathfind()
	
	r_fct_access_hall_collision.hide()
	
	if create_camera_at_room_start:
		_setup_camera()
		
	if create_player_scene_at_room_start:
		await get_tree().process_frame
		_setup_player_node()
