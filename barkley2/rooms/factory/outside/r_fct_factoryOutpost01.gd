extends B2_ROOMS

@onready var o_archambeau_01: CharacterBody2D = $o_archambeau01
@onready var o_door_tech_01: B2_Door_Tech = $o_door_tech01


#/* MAIN QUEST aka mainQuest
#
#0 = Game begun
#1 = Tutorial over
#2 = Escaped TNN, one way or another
#3 = Reached BCT, one way or another
#4 = Found BCT Longinus
#5 = Visited Cuchu's Lair
#6 = Met Cyberdwarf
#7 = Identity chosen
#8 = Reached Cuchu's Lair with Cdwarf
#9 = Beyond the point of no return

func _ready() -> void:
	RenderingServer.set_default_clear_color( Color.BLACK ) ## TEMP
	
	_init_pathfind()
	_update_pathfind()
	
	# Quest related
	o_archambeau_01.modulate.a = 0.0
	B2_Sound.stop_loop()
	
	await get_tree().process_frame
	if play_cinema_at_room_start and is_instance_valid( cutscene_script ):
		B2_CManager.play_cutscene( cutscene_script, self, true )
	elif B2_RoomXY.is_room_valid():
		B2_RoomXY.add_player_to_room( B2_RoomXY.get_room_pos(), true )
	else:
		_setup_camera( _setup_player_node() )

func execute_event_user_0():
	o_door_tech_01.door_open( true )
	o_door_tech_01.locked = true
	
func execute_event_user_1():
	# sets hoopz shadow
	pass
