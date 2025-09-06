@tool
extends B2_ROOMS

#const O_ENEMY_DRONE_EGG 		= preload("res://barkley2/scenes/Objects/_enemies/Enemy Types/Mechanical/o_enemy_drone_egg.tscn")
const O_ENEMY_DRONE_EGG_FINAL 	= preload("res://barkley2/scenes/Objects/_enemies/Enemy Types/Mechanical/o_enemy_drone_egg_final.tscn")
const GENERIC_EXPLOSION 		= preload("res://barkley2/scenes/Objects/System/generic_explosion.tscn")

@onready var alarm_sound: 				AudioStreamPlayer = $alarm_sound
@onready var o_fct_egg_computer_01: 	AnimatedSprite2D = $o_fct_eggComputer01
@onready var o_egg_drone_01: 			B2_InteractiveActor = $o_eggDrone01
var o_enemy_drone_egg : 				B2_EnemyCombatActor

@onready var enemy_nest_drone_egg: Area2D = $enemy_nest


@onready var o_tutorial_egg_drone: 		Area2D = $o_tutorial_eggDrone

@onready var o_doorlight_exit: B2_DoorLight = $o_doorlight_down_exit

@onready var o_fct_alarm_big_01: 	AnimatedSprite2D = $o_fct_alarmBig01
@onready var o_fct_alarm_wall_01: 	AnimatedSprite2D = $o_fct_alarmWall01
@onready var o_fct_alarm_wall_02: 	AnimatedSprite2D = $o_fct_alarmWall02
@onready var o_fct_egg_arms_01: 	Marker2D = $o_fct_eggArms01

@onready var o_fct_egg_pit_01: 		AnimatedSprite2D = $o_fct_eggPit01
@onready var o_fct_egg_heater_01: 	AnimatedSprite2D = $o_fct_eggHeater01

@onready var o_effect_alarm_light: CanvasLayer = $o_effect_alarmLight

func _ready() -> void:
	RenderingServer.set_default_clear_color( Color.BLACK ) ## TEMP
	
	## Debug
	#B2_Playerdata.preload_CC_save_data()
	#B2_Gun.add_gun_to_bandolier()
	#B2_Gun.add_gun_to_bandolier()
	#B2_Gun.add_gun_to_bandolier()
	#B2_CManager.BodySwap("diaper");
	#B2_Playerdata.Quest("hudVisible", 		0);
	#B2_Playerdata.Quest("zoneVisible", 		0);
	#B2_Playerdata.Quest("dropEnabled", 		0);
	#B2_Playerdata.Quest("infiniteAmmo", 	1);
	
	_set_region()
	
	await get_tree().process_frame
	if B2_RoomXY.is_room_valid():
		B2_RoomXY.add_player_to_room( B2_RoomXY.get_room_pos(), true )
	else:
		_setup_camera( _setup_player_node() )

func flip_switch():
	if o_egg_drone_01: 			o_egg_drone_01.queue_free() # Destroy(o_eggDrone01);
	if o_tutorial_egg_drone: 	o_tutorial_egg_drone.queue_free()
	if B2_Playerdata.Quest("factoryEggs") < 1:
		B2_Playerdata.Quest("factoryEggs", 1)
		
	o_fct_egg_computer_01.show_error()
	B2_Playerdata.Quest("tutorialProgress", 9)
	B2_Music.play( "mus_blankTEMP", 1.0 )
	
	activate_facility_alarm()

# setup stuff for drone fight. code was on o_egg_drone_01 before
func pre_drone_fight():
	set_pacify( false )
	o_doorlight_exit.enabled = false
	o_enemy_drone_egg = O_ENEMY_DRONE_EGG_FINAL.instantiate() # O_ENEMY_DRONE_EGG.instantiate()
	o_enemy_drone_egg.position = o_egg_drone_01.position
	add_child( o_enemy_drone_egg, true )
	enemy_nest_drone_egg.add_enemy( o_enemy_drone_egg )
	o_egg_drone_01.queue_free()
	
	enemy_nest_drone_egg.deactivate_nest()
	enemy_nest_drone_egg.begin_battle()

# setup stuff after drone fight. code was on o_enemy_drone_egg
func post_drone_fight():
	set_pacify( true )
	o_doorlight_exit.enabled = true
	if B2_Playerdata.Quest("factoryEggs") < 1:
		B2_Playerdata.Quest("factoryEggs", 1)
		o_fct_egg_computer_01.show_error()
	
	## VERY IMPORTANT. death sfx, animation
	## NOTE 27-04-25 As of right now, not important anymore. We have a new combat system.
	#B2_Sound.play( "sn_explosion_generic_06_01" )
	#var explosion = GENERIC_EXPLOSION.instantiate()
	#explosion.position = o_enemy_drone_egg.position
	#o_enemy_drone_egg.queue_free()
	#add_sibling(explosion)
	
	B2_Music.play( "mus_blankTEMP", 0.0 )
	B2_Music.clear_curr_music()
	B2_Music.stop()
	await get_tree().process_frame
	activate_facility_alarm()
	
func activate_facility_alarm():
	# check o_tutorial_eggDrone step event
	B2_Sound.play_loop( "sn_pdt_alert01" )
	
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
	
	# alarm
	o_effect_alarm_light.activate()
