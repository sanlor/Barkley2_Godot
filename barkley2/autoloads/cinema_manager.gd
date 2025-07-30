extends Node

## B2 Cinema Manager
## Keeps track of CinemaScript running on the scene, also handles some of the Combatscript stuff.

signal event_started
signal event_ended
signal hoopz_got_hit ## Used during combat, for action canceling.

const SCENE_INDEX = preload("res://barkley2/resources/B2_CManager/scene_index.json")

## Cutscene scenes.
var scene_index	: Dictionary = Dictionary()

## Handle costume / body changes
enum BODY{HOOPZ,MATTHIAS,GOVERNOR,UNTAMO,DIAPER,PRISON}
var curr_BODY := BODY.HOOPZ

## Normal, player controlable node
const O_CTS_HOOPZ_DIAPER = preload("res://barkley2/scenes/Player/o_cts_hoopz_diaper.tscn")
const O_CTS_HOOPZ_NORMAL = preload("res://barkley2/scenes/Player/o_cts_hoopz_normal.tscn")

## Combat actor
const O_CBT_HOOPZ_NORMAL = preload("res://barkley2/scenes/Player/o_cbt_hoopz_normal.tscn")
const O_CBT_HOOPZ_DIAPER = preload("res://barkley2/scenes/Player/o_cbt_hoopz_diaper.tscn")

## Cutscene actor
const O_HOOPZ_DIAPER = preload("res://barkley2/scenes/Player/o_hoopz_diaper.tscn")
const O_HOOPZ_NORMAL = preload("res://barkley2/scenes/Player/o_hoopz_normal.tscn")

var o_hoopz_scene 		: PackedScene = O_HOOPZ_NORMAL
var o_cts_hoopz_scene 	: PackedScene = O_CTS_HOOPZ_NORMAL
var o_cbt_hoopz_scene 	: PackedScene = O_CBT_HOOPZ_NORMAL

# Loaded actors, part of the original scr_event_hoopz_switch_cutscene() script.
var o_cts_hoopz 	: B2_Actor 						= null :## Cutscene Hoopz
	set(h):
		o_cts_hoopz = h
		#print_stack() ## Debug
var o_hoopz 		: B2_PlayerCombatActor		 				= null ## PLayer controlled Hoopz
var o_hud			: B2_Hud						= null ## Main HUD, with combat attachments.
var camera			: B2_Camera_Hoopz #Camera2D
var cinema_player 	: B2_CinemaPlayer

## Combat stuff
var o_cbt_hoopz 			: B2_HoopzCombatActor		 	= null ## Combat Hoopz
#var o_combat_ui				: CanvasLayer					= null ## Combat UI (Is this needed?)
var combat_manager			: B2_CombatManager
var combat_cinema_player 	: B2_Combat_CinemaPlayer
var cinema_caller			: Node

## Index all scenes
func _index_scenes():
	print_rich("[color=web_purple]Scene Index called.[/color]")
	scene_index.clear()
	var scene_array = FileSearch.search_dir( "res://barkley2/scenes/", "", true )
	## Godot is kinda weird sometimes.
	## PackedScene in exported projects are named *.tscn.remap for some reason.
	## This basically handles the project in the editor and on exported projects.
	for s : String in scene_array:
		if 	s.ends_with(".tscn"):			## <- used in the godot editor
			var s_name = s.rsplit("/", true, 1)[1].trim_suffix(".tscn")
			scene_index[s_name] = s
		elif s.ends_with(".tscn.remap"):	## <- used in the exported project
			var s_name = s.rsplit("/", true, 1)[1].trim_suffix(".tscn.remap")
			scene_index[s_name] = s.trim_suffix(".remap")
	print_rich("[color=web_purple]Index rooms ended: ", Time.get_ticks_msec(), " msecs. - ", scene_index.size(), " room_index key entries[/color]")
	_save_sceneindex_to_disk()

## This writes the Sound list to disk to avoid unecessary lookups during boot.
func _save_sceneindex_to_disk() -> void:
	print_rich("[color=cyan]WARNING: Saving SceneIndex to disk.[/color]")
	var file = FileAccess.open( "res://barkley2/resources/B2_CManager/scene_index.json", FileAccess.WRITE )
	file.store_string( JSON.stringify(scene_index, "\t") )

func _ready() -> void:
	scene_index = SCENE_INDEX.data

func get_cached_scene( scene_name : String ) -> PackedScene:
	if scene_index.has(scene_name):
		return load( scene_index.get(scene_name) )
	else:
		push_error("Scene cache miss (%s). Cache has %s scenes. Reindexing the cache." % [scene_name, str(scene_index.size())])
		_index_scenes()
		return null

func play_cutscene( cutscene_script : B2_Script, _event_caller : Node2D, cutscene_mask = [] ) -> void:
	cinema_player = B2_CinemaPlayer.new()
	get_tree().current_scene.add_child( cinema_player, true )
	cinema_player.play_cutscene( cutscene_script, _event_caller, cutscene_mask )

func start_combat( combat_script : B2_Script_Combat, enemies : Array[B2_EnemyCombatActor] ) -> void:
	combat_manager 				= B2_CombatManager.new()
	combat_cinema_player 		= B2_Combat_CinemaPlayer.new()
	combat_cinema_player.name 	= "combat_cinema_player"
	get_tree().current_scene.add_child( combat_cinema_player, true )
	combat_cinema_player.setup_combat( combat_script, enemies )

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
			o_cbt_hoopz_scene	= O_CBT_HOOPZ_DIAPER
			curr_BODY = BODY.DIAPER
		"prison":
			o_hoopz_scene		= null
			o_cts_hoopz_scene	= null
			curr_BODY = BODY.PRISON
		# Else, You Are Hoopz.
		_:
			o_hoopz_scene		= O_HOOPZ_NORMAL
			o_cts_hoopz_scene	= O_CTS_HOOPZ_NORMAL
			o_cbt_hoopz_scene	= O_CBT_HOOPZ_NORMAL
			curr_BODY = BODY.HOOPZ
			
	B2_Config.set_user_save_data( "player.body", costume_name )
	print("Costume changed to %s." % costume_name)
	
func get_BodySwap() -> String:
	return B2_Config.get_user_save_data( "player.body", "hoopz" )
	
func cleanup_line( line : String ) -> PackedStringArray:
	var parsed_line : PackedStringArray = line.split( "|", false )
	# Cleanup
	for i in range( parsed_line.size() ):
		parsed_line[i] = parsed_line[i].strip_edges()
		if parsed_line[i].is_empty(): ## Avoid issues with emtpy lines after trimming.
			continue
		# parsed_line[i] = parsed_line[i].split("//", false, 1)[ 0 ] ## Strip comments
		parsed_line[i] = parsed_line[i].get_slice("//", 0) 	## Strip comments
		parsed_line[i] = parsed_line[i].strip_edges() 		## cleanup for empty spaces
	return parsed_line
	
func get_node_from_name( _name ) -> Object:
	var node : Object
	var all_nodes := get_tree().current_scene.get_children()
	for item in all_nodes:
		if is_instance_valid(item):
			if item is Object:
				if item.name == _name:
					node = item
					break
	if not is_instance_valid(node):
		print_debug("Target %s not found. Bummer. This is normal with the USEAT action." % _name)
	return node
	
## NOTE Cinema Functions. A suite of functions used for cinema scripts.
## WARNING Right now, only used by the Combat Cinema Script.

func cinema_dialog( _line : String ) -> void:
	pass
	
func cinema_quest( parsed_line : PackedStringArray, debug := false ) -> void:
	# this is confusing. This can set quest states, change states, like quest += 1 and fuck aroung with money and time. weird
	var quest_stuff := parsed_line[ 1 ].strip_edges().split(" ", false, 2)
	var qstNam = quest_stuff[0]
	var qstTyp = quest_stuff[1]
	var qstVal = quest_stuff[2]
	
	if qstVal.contains("@"): ## Not sure how this is used.
		# if (string_pos("@", qstVal) > 0) qstVal = Cinema("parse", qstVal);
		## Now I know! Its a variable injection, to add arbitrary values to quest variables.
		# What a beautifull mess.
		
		qstVal = qstVal.replace("@", "")
		if qstVal.begins_with("money_"):
			qstVal = qstVal.trim_prefix("money_")
			if not B2_Database.money.has(qstVal):
				push_error("B2_Database.money doesn have the data regarding the variable %s." % qstVal)
			qstVal = B2_Database.money.get( qstVal, "69420666" )
		elif qstVal.begins_with("time_"):
			qstVal = qstVal.trim_prefix("time_")
			push_warning("Time function is not implemented.")
		else:
			## Sometimes, quests variables are also in the value variable.
			qstVal = str( B2_Playerdata.Quest(qstVal) )
			#breakpoint
	else:
		# qstVal = float( qstVal ) # 27/07/25 disabled this. having issues with adding strings values to quests.
		pass
	
	if qstVal.is_valid_int() or qstVal.is_valid_float():
		qstVal = float( qstVal )
		
		if qstTyp == "+=":
			B2_Playerdata.Quest(qstNam, B2_Playerdata.Quest(qstNam) + qstVal )
		elif qstTyp == "-=":
			B2_Playerdata.Quest(qstNam, B2_Playerdata.Quest(qstNam) - qstVal )
		else:
			B2_Playerdata.Quest(qstNam, qstVal )
	else: # = or ==
		B2_Playerdata.Quest(qstNam, str(qstVal) )
	
	if debug: print( "Quest: ", quest_stuff )

func cinema_sound( parsed_line : PackedStringArray, debug := false ) -> void:
	if parsed_line.size() > 2:
		# Loops
		B2_Sound.play( parsed_line[1], 0.0, false, int( parsed_line[2] ) )
		if debug: print(parsed_line[1], " with %s loops" % parsed_line[2])
	else:
		B2_Sound.play( parsed_line[1], 0.0, false )
		if debug: print( parsed_line )

## Moves the camera torward a node *OR* torward the average portition of a group of nodes.
func cinema_frame( parsed_line : PackedStringArray, source, _debug := false ) -> void:
	var move_points := parsed_line.size() - 2 # first 2 are the action and speed.
	var move_array : Array[Node2D] = []
	
	for point in move_points:
		var dest := get_node_from_name( parsed_line[ 2 + point ] )
		if dest == null:
			push_warning("FRAME: destination_object is invalid: ", dest, " - ", parsed_line[ 2 + point ] )
		move_array.append( dest )
	
	if not move_array.is_empty():
		var speed 					= parsed_line[1]
		camera.cinema_moveto( move_array, speed )		## Async movement 
		
		source.add_cinema_action( camera )
