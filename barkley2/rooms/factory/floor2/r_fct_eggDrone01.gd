extends B2_ROOMS

const O_ENEMY_DRONE_EGG = preload("res://barkley2/scenes/Objects/_enemies/Enemy Types/Mechanical/o_enemy_drone_egg.tscn")
const GENERIC_EXPLOSION = preload("res://barkley2/scenes/Objects/System/generic_explosion.tscn")

@onready var alarm_sound: 				AudioStreamPlayer = $alarm_sound
@onready var o_fct_egg_computer_01: 	AnimatedSprite2D = $o_fct_eggComputer01
@onready var o_egg_drone_01: 			B2_InteractiveActor = $o_eggDrone01
var o_enemy_drone_egg : 				B2_EnemyCombatActor

@onready var o_fct_alarm_big_01: 	AnimatedSprite2D = $o_fct_alarmBig01
@onready var o_fct_alarm_wall_01: 	AnimatedSprite2D = $o_fct_alarmWall01
@onready var o_fct_alarm_wall_02: 	AnimatedSprite2D = $o_fct_alarmWall02
@onready var o_fct_egg_arms_01: 	Marker2D = $o_fct_eggArms01

@onready var o_fct_egg_pit_01: 		AnimatedSprite2D = $o_fct_eggPit01
@onready var o_fct_egg_heater_01: 	AnimatedSprite2D = $o_fct_eggHeater01


func _ready() -> void:
	RenderingServer.set_default_clear_color( Color.BLACK ) ## TEMP
	
	_init_pathfind()
	_update_pathfind()
	
	await get_tree().process_frame
	if B2_RoomXY.is_room_valid():
		B2_RoomXY.add_player_to_room( B2_RoomXY.get_room_pos(), true )
	else:
		_setup_camera( _setup_player_node() )

# setup stuff for drone fight. code was on o_egg_drone_01 before
func pre_drone_fight():
	room_pacify = false
	o_enemy_drone_egg = O_ENEMY_DRONE_EGG.instantiate()
	o_enemy_drone_egg.position = o_egg_drone_01.position
	o_egg_drone_01.queue_free()
	add_child( o_enemy_drone_egg )

# setup stuff after drone fight. code was on o_enemy_drone_egg
func post_drone_fight():
	room_pacify = true
	if B2_Playerdata.Quest("factoryEggs") < 1:
		B2_Playerdata.Quest("factoryEggs", 1)
		o_fct_egg_computer_01.show_error()
	
	## VERY IMPORTANT. death sfx, animation
	B2_Sound.play( "sn_explosion_generic_06_01" )
	B2_Music.play( "mus_blankTEMP", 1.0 )
	
	var explosion = GENERIC_EXPLOSION.instantiate()
	explosion.position = o_enemy_drone_egg.position
	o_enemy_drone_egg.queue_free()
	add_sibling(explosion)
	
	activate_facility_alarm()
	
func activate_facility_alarm():
	# check o_tutorial_eggDrone step event
	var audio_stream : AudioStreamOggVorbis = load( B2_Sound.get_sound("sn_pdt_alert01") )
	audio_stream.loop = true
	alarm_sound.stream = audio_stream
	alarm_sound.play()
	
	# animations
	o_fct_alarm_big_01.play()
	o_fct_alarm_wall_01.play("on")
	o_fct_alarm_wall_02.play("on")
	## NOTE - Mission lighting effect.
	o_fct_egg_arms_01.stop_arms()
	
	# Light, off
	o_fct_egg_heater_01.frame = 0
	
	# EGG
	o_fct_egg_pit_01.jostle_eggs()
