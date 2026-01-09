@tool
extends B2_ROOMS
## Fishing minigame room

@onready var o_cts_hoopz: CharacterBody2D = $o_cts_hoopz

func _enter_tree() -> void:
	super()
	B2_Playerdata.disable_save()

func _ready() -> void:
	RenderingServer.set_default_clear_color( Color.BLACK ) ## TEMP
	
	_setup_camera( o_cts_hoopz )
	#_set_region()
	#
	#await get_tree().process_frame
	#if play_cinema_at_room_start and is_instance_valid( cutscene_script ):
		#B2_CManager.play_cutscene( cutscene_script, self, [] )
	#elif B2_RoomXY.is_room_valid():
		#B2_RoomXY.add_player_to_room( B2_RoomXY.get_room_pos(), true )
	#else:
		#_setup_camera( _setup_player_node() )
