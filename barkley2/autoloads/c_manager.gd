extends Node

## B2 Cinema Manager
# Keeps track of CinemaScript running on the scene.

signal event_started
signal event_ended

## Handle costume / body changes
enum BODY{HOOPZ,MATTHIAS,GOVERNOR,UNTAMO,DIAPER,PRISON}
var curr_BODY := BODY.HOOPZ

const O_CTS_HOOPZ_DIAPER = preload("res://barkley2/scenes/Player/o_cts_hoopz_diaper.tscn")
const O_CTS_HOOPZ_NORMAL = preload("res://barkley2/scenes/Player/o_cts_hoopz_normal.tscn")

const O_HOOPZ_DIAPER = preload("res://barkley2/scenes/Player/o_hoopz_diaper.tscn")
const O_HOOPZ_NORMAL = preload("res://barkley2/scenes/Player/o_hoopz_normal.tscn")

var o_hoopz_scene 		: PackedScene = O_HOOPZ_NORMAL
var o_cts_hoopz_scene 	: PackedScene = O_CTS_HOOPZ_NORMAL

# Loaded actors, part of the original scr_event_hoopz_switch_cutscene() script.
var o_cts_hoopz 	: B2_Actor 			= null
var o_hoopz 		: B2_Player		 	= null
var camera			: Camera2D

func play_cutscene( cutscene_script : B2_Script, _event_caller : Node2D, cutscene_mask = [] ):
	var b2_cinema := B2_CinemaPlayer.new()
	
	get_tree().current_scene.add_child( b2_cinema )
	b2_cinema.play_cutscene( cutscene_script, _event_caller, cutscene_mask )

func BodySwap( costume_name : String ) -> void:
	# Handle costumes changes. during game load or new game, need to load the correct costume.
	match costume_name:
		"matthias":
			o_hoopz_scene		= null
			o_cts_hoopz_scene	= null
			curr_BODY = BODY.MATTHIAS
		"governor":
			o_hoopz_scene		= null
			o_cts_hoopz_scene	= null
			curr_BODY = BODY.GOVERNOR
		"untamo":
			o_hoopz_scene		= null
			o_cts_hoopz_scene	= null
			curr_BODY = BODY.UNTAMO
		"diaper":
			o_hoopz_scene		= O_HOOPZ_DIAPER
			o_cts_hoopz_scene	= O_CTS_HOOPZ_DIAPER
			curr_BODY = BODY.DIAPER
		"prison":
			o_hoopz_scene		= null
			o_cts_hoopz_scene	= null
			curr_BODY = BODY.PRISON
		# Else, You Are Hoopz.
		_:
			o_hoopz_scene		= O_HOOPZ_NORMAL
			o_cts_hoopz_scene	= O_CTS_HOOPZ_NORMAL
			curr_BODY = BODY.HOOPZ
			
	B2_Config.set_user_save_data( "player.body", costume_name )
	print("Costume changed to %s." % costume_name)
	
