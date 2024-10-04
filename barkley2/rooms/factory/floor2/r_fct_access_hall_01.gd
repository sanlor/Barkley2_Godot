extends B2_ROOMS

func _ready() -> void:
	# change the gray BG to Black during runtime
	RenderingServer.set_default_clear_color( Color.BLACK ) ## TEMP
	
	_init_pathfind()
	_update_pathfind()
