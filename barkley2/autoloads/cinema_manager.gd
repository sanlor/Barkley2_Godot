extends Node

## B2 Cinema Manager
# Keeps track of CinemaScript running on the scene.

signal event_started
signal event_ended

## Handle costume / body changes
enum BODY{HOOPZ,MATTHIAS,GOVERNOR,UNTAMO,DIAPER,PRISON}
var curr_BODY := BODY.HOOPZ

## Normal, player controlable node
const O_CTS_HOOPZ_DIAPER = preload("res://barkley2/scenes/Player/o_cts_hoopz_diaper.tscn")
const O_CTS_HOOPZ_NORMAL = preload("res://barkley2/scenes/Player/o_cts_hoopz_normal.tscn")

## Combat actor
const O_CBT_HOOPZ_NORMAL = preload("res://barkley2/scenes/Player/o_cbt_hoopz_normal.tscn")

## Cutscene actor
const O_HOOPZ_DIAPER = preload("res://barkley2/scenes/Player/o_hoopz_diaper.tscn")
const O_HOOPZ_NORMAL = preload("res://barkley2/scenes/Player/o_hoopz_normal.tscn")

var o_hoopz_scene 		: PackedScene = O_HOOPZ_NORMAL
var o_cts_hoopz_scene 	: PackedScene = O_CTS_HOOPZ_NORMAL
var o_cbt_hoopz_scene 	: PackedScene = O_CBT_HOOPZ_NORMAL

# Loaded actors, part of the original scr_event_hoopz_switch_cutscene() script.
var o_cts_hoopz 	: B2_Actor 						= null ## Cutscene Hoopz
var o_hoopz 		: B2_Player		 				= null ## PLayer controlled Hoopz
var o_hud			: B2_Hud						= null ## Main HUD
var camera			: Camera2D

## Combat stuff
var o_cbt_hoopz 	: B2_CinemaCombatActor_Base 	= null ## Combat Hoopz
var o_combat_ui		: CanvasLayer					= null ## Combat UI (Is this needed?)
var combat_manager	: B2_CombatManager

func play_cutscene( cutscene_script : B2_Script, _event_caller : Node2D, cutscene_mask = [] ) -> void:
	var b2_cinema := B2_CinemaPlayer.new()
	
	get_tree().current_scene.add_child( b2_cinema, true )
	b2_cinema.play_cutscene( cutscene_script, _event_caller, cutscene_mask )

func start_combat( combat_script : B2_CombatScript, enemies : Array ) -> void:
	var combat_cinema := B2_Combat_CinemaPlayer.new()
	get_tree().current_scene.add_child( combat_cinema, true )
	combat_cinema.setup_combat( combat_script, enemies )

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
	
