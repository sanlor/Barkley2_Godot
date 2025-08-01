extends CanvasLayer

## Node responsible for room transitions.
# Check the original RoomXY() script.
## RoomXY(room, x, y, slide_direction [4 args] open_sfx [5 args], close_sfx [5 args])

## Also check RespawnLocation()

const ROOM_INDEX = preload("res://barkley2/resources/rooms/room_index.json")

## DEBUG
var print_debug_logs 		:= false
var print_room_load_logs 	:= true

signal started_loading
signal room_loaded( has_error )
signal room_finished_loading

signal fadeout_finished

signal room_index_dirty

var is_loading_room 	:= false
var path_loading_room 	:= ""
var load_progress		:= []

## Threaded load.
var use_subthreads 		:= false # setting this to true causes issues. # https://github.com/godotengine/godot/pull/93032
var cachemode			:= ResourceLoader.CACHE_MODE_REPLACE

## Bellow vars are used by the cinema script, to add the player character.
var this_room 			:= ""
var this_room_x 		:= 0.0
var this_room_y 		:= 0.0

var fade_time_in 		:= B2_Config.settingFadeIn
var fade_delay 			:= B2_Config.settingFadeDelay
var fade_time_out 		:= B2_Config.settingFadeOut

var invalid_room 		:= "res://barkley2/rooms/ai_ruins/r_air_throneRoom01.tscn" # "res://barkley2/rooms/r_wip.tscn" # Fallback room
var room_folder 		:= "res://barkley2/rooms/"

var room_load_lock		:= false # disallow loading a new room defore the current one finishes loading

var room_array 			:= []
var room_index 			:= {}
var room_scene 			: PackedScene
var room_reference		: B2_ROOMS				## Reference used for static functions to fin the SceneTree.
var room_is_invalid 	:= false

const ROOM_PROGRESS_BAR 		= preload("res://barkley2/resources/autoloads/room_progress_bar.tscn")
const ROOM_TRANSITION_LAYER 	= preload("res://barkley2/resources/autoloads/room_transition_layer.tscn")

var room_transition_layer		: ColorRect
var room_progress_bar			: ProgressBar

## Room load time
var t1 := 0.0
var t2 := 0.0

func _index_rooms():
	print_rich("[color=web_purple]Room Index called.[/color]")
	room_index.clear()
	room_array = FileSearch.search_dir( "res://barkley2/rooms/", "", true )
	## Godot is kinda weird sometimes.
	## PackedScene in exported projects are named *.tscn.remap for some reason.
	## This basically handles the project in the editor and on exported projects.
	for r : String in room_array:
		if 	r.ends_with(".tscn"):			## <- used in the godot editor
			var r_name = r.rsplit("/", true, 1)[1].trim_suffix(".tscn")
			room_index[r_name] = r
		elif r.ends_with(".tscn.remap"):	## <- used in the exported project
			var r_name = r.rsplit("/", true, 1)[1].trim_suffix(".tscn.remap")
			room_index[r_name] = r.trim_suffix(".remap")
	print_rich("[color=web_purple]Index rooms ended: ", Time.get_ticks_msec(), " msecs. - ", room_index.size(), " room_index key entries[/color]")
	_save_room_index_to_disk()

func _save_room_index_to_disk() -> void:
	print_rich("[color=cyan]WARNING: Saving 'room_index' to disk.[/color]")
	var file = FileAccess.open( "res://barkley2/resources/rooms/room_index.json", FileAccess.WRITE )
	file.store_string( JSON.stringify(room_index, "\t") )
	file.close()

func _ready() -> void:
	## In case of a cache miss, reindex the entire thing.
	room_index_dirty.connect( _index_rooms )
	
	## Set Room Index cache
	room_index = ROOM_INDEX.data
	
	room_transition_layer 	= ROOM_TRANSITION_LAYER.instantiate()
	room_progress_bar 		= ROOM_PROGRESS_BAR.instantiate()
	process_mode 			= ProcessMode.PROCESS_MODE_ALWAYS
	layer 					= B2_Config.ROOMXY_LAYER
	B2_Config.title_screen_loaded.connect( _reset_data )

func _reset_data():
	reset_room()

## Check if hoopz can draw its gun in the current room.
func can_aim_gun() -> bool:
	if room_reference:
		return not room_reference.room_pacify 
	else:
		push_error("B2_ROOMS not loaded: %s" % room_reference)
		return false

func is_room_valid( strict := false) -> bool:
	if strict:
		if this_room_x == 0.0 or this_room_y == 0.0 or this_room.is_empty():
			return false
	return not this_room.is_empty()

func get_room_pos() -> Vector2:
	return Vector2( this_room_x, this_room_y )

# Reset room data. is this needed?
func reset_room() -> void:
	this_room 		= ""
	this_room_x 	= 0.0
	this_room_y 	= 0.0
	print_rich( "[color=yellow]B2_RoomXY: Room data reseted[/color]" )

## Hoopz dies. respawn based on the RespawnLocation script data.
func respawn( area : String, room_name : String ) -> void:
	# As a failsafe, a respawn map will be assigned based on AREA first,
	# just in "there is no room found afterwards
	var respawnRoom = "r_est_tnnRespawn01"

	# Cuchu's Lair as part of Wiglaf's Mission Tracker
	if area == "chu": B2_Playerdata.Quest("cuchuLairDeath", 1)

	# Failsafe, get area respawn #
	match area:
		"gau": respawnRoom = "r_gau_01_entrance01"
		"tnn": respawnRoom = "r_sw1_respawn01"
		"sw1": respawnRoom = "r_sw1_respawn01"
		"sw2": respawnRoom = "r_sw2_respawn01"
		"est": respawnRoom = "r_est_tnnRespawn01"
		"pea": respawnRoom = "r_pea_caveRespawnBase01"
		"pri": respawnRoom = "r_pea_caveRespawnBase01"
		"far": respawnRoom = "r_far_nexus01"
		"fct": respawnRoom = "r_fct_respawn01"
		"swp": respawnRoom = "r_swp_respawntrash01"
		"bct": respawnRoom = "r_usw_ruinsWifi01"
		"usw": respawnRoom = "r_usw_ruinsWifi01"
		"air": respawnRoom = "r_usw_ruinsWifi01"
		"wst": respawnRoom = "r_wst_northRespawn01"
		"min": respawnRoom = "r_far_nexus01"
		"dth": respawnRoom = "r_far_nexus01"
		"pdt": respawnRoom = "r_usw_ruinsWifi01"
		"ice": respawnRoom = "r_ice_respawn01"
		"chu": respawnRoom = "r_usw_ruinsWifi01"
		"min": respawnRoom = "r_min_respawn01"

	# Find where you should respawn based on the MAP you died in #
	## NOTE Yes, it is a mess. I like this mess. its original, its... confortable.
	match room_name:
		# Gauntlet #
		"r_gau_01_entrance01","r_gau_room1_1","r_gau_sewersOne01","r_gau_sewersTwo01","r_gau_NPCVilla01","r_gau_boss_catfishQueen","r_gau_boss_crabcommandoFight","r_gau_boss_hugebrainAlien", "r_gau_boss_oozeFight","r_gau_boss_sentinel","r_gau_combatEffects01","r_gau_21_eastelandsStart01","r_gau_27_swampStart01":
			respawnRoom = "r_gau_01_entrance01"

		# AI Ruins #
		"r_air_dais01":
			respawnRoom = "r_est_tnnRespawn01"

		# Factory #
		"r_fct_arena01","r_fct_assembly01","r_fct_bigRoom01","r_fct_control01","r_fct_corridor01","r_fct_eggRooms01","r_fct_corner01","r_fct_gizmo01","r_fct_loading01","r_fct_lobby01","r_fct_office01","r_fct_storage01","r_fct_tutorialZone01":
			respawnRoom = "r_fct_respawn01"

		# Wasteland # TNN side respawn #
		"r_est_cgremArena01","r_est_cgremPath01","r_est_cgremVillage01","r_est_difficultyFork01","r_est_easternPaths01","r_est_factoryChicane01","r_fct_factoryOutpost01","r_fct_factoryParking01","r_fct_factoryStorage01","r_est_junkworms01","r_est_mountainBase01","r_est_pythagoras01","r_est_swampZigzag01","r_wst_tnnEntrance01","r_est_tnnRespawn01","r_wst_wadingRace01","r_wst_westJunction01","r_wst_westOpenGrounds01":
			respawnRoom = "r_est_tnnRespawn01"

		# Wasteland # North side Respawn #
		"r_wst_donutDomain01","r_est_industrialPlaza01","r_est_industrialRock01","r_est_industrialZone01","r_wst_northCircle01","r_wst_northPassage01","r_wst_northRespawn01","r_wst_northRuins01","r_est_turretGauntlet01","r_wst_westMaze01":
			respawnRoom = "r_wst_northRespawn01"

		# Sewers Floor 01 #
		"r_sw1_baldomero01","r_sw1_center01","r_sw1_closet01","r_sw1_crossroads01","r_sw1_descent01","r_sw1_eastEdge01","r_sw1_elemental01","r_sw1_end01","r_sw1_fishersCreek01","r_sw1_floor2Access01","r_sw1_foyer01","r_sw1_gap01","r_sw1_gutterGate01","r_sw1_joad01","r_sw1_longWays01","r_sw1_manholeEast01","r_sw1_manholeWest01","r_sw1_plantation02","r_sw1_pool01","r_sw1_rathell01","r_sw1_respawn01","r_sw1_secret01","r_sw1_southEdge01","r_sw1_tnnShortcut01","r_sw1_treasureDwarf01","r_sw1_utility01","r_sw2_gordo01":
			respawnRoom = "r_sw1_respawn01"

		# Sewers Floor 02 #
		"r_sw2_balcony01","r_sw2_bridges01","r_sw2_crossing01","r_sw2_crossroad01","r_sw2_eastExit01","r_sw2_end01","r_sw2_hermitPass01","r_sw2_indianRopeTrick01","r_sw2_looparound01","r_sw2_pools01","r_sw2_respawn01","r_sw2_sludgeFloor01","r_sw2_start01","r_sw2_steam01","r_sw2_steam02","r_sw2_treasureDwarf01","r_sw2_utility01":
			respawnRoom = "r_sw2_respawn01"

		# Undersewers #

		# Swamps Trash #
		"r_swp_barkleypond01","r_swp_bcdeadend01","r_swp_bcentrance01","r_swp_bogchurch01","r_swp_centralbend01","r_swp_koboldcamp01","r_swp_longpathrespawn01","r_swp_longpathutility01","r_swp_quagmire01","r_swp_respawntrash01","r_swp_roundabout01","r_swp_shacklake01","r_swp_swampRanch01","r_swp_utilityonpath01","r_swp_westentrance01","r_swp_westpool01","r_swp_westshortcut01":
			respawnRoom = "r_swp_respawntrash01"

		# Swamps water #
		"r_swp_beach01","r_swp_corpseLake01","r_swp_cuchu1_01","r_swp_cuchu3_01","r_swp_cuchu4_01","r_swp_cuchuelevator01","r_swp_duergarencounter01","r_swp_eastwestcrossroads01","r_swp_flowerguardian01","r_swp_koboldchallenge01","r_swp_respawnwater01","r_swp_southPatch01","r_swp_waterbowl01":
			respawnRoom = "r_swp_respawnwater01"

		# Mines #
		"r_min_baseCampAlpha01","r_min_baseCampBeta01","r_min_constantine01","r_min_eastPit01","r_min_entrance01","r_min_jeanmarcPit01","r_min_junction01","r_min_kaleviCave01","r_min_respawn01","r_min_secret01":
			respawnRoom = "r_min_respawn01"
	
	# Babyzone check #
	## TODO - need to implement baby check. check RespawnLocation line 236
	
	# Cuchu Trial (Longinus mission) random respawn location #
	if B2_Playerdata.Quest("cuchuRespawn") == 1:
		# Only happens this once #
		B2_Playerdata.Quest("cuchuRespawn", 2);
		
		# Pick a random spot #
		# TODO: this could be enhanced to a place you haven't been yet
		respawnRoom = [
			"r_est_tnnRespawn01", "r_wst_northRespawn01", "r_swp_respawntrash01", 
			"r_swp_respawnwater01", "r_sw1_respawn01", "r_sw2_respawn01", "r_fct_respawn01", 
			"r_far_nexus01","r_pea_caveRespawnBase01"].pick_random()
			
	var respawnX := 0.0
	var respawnY := 0.0
			
	# X and Y coords for "normal" respawns #
	match respawnRoom:
		# Get the X and Y #
		"r_tnn_wilmer01": 				respawnX = 256; respawnY = 352; 
		"r_est_tnnRespawn01": 			respawnX = 648; respawnY = 224; 
		"r_wst_northRespawn01": 		respawnX = 272; respawnY = 328; 
		"r_swp_respawntrash01": 		respawnX = 264; respawnY = 200; 
		"r_swp_respawnwater01": 		respawnX = 312; respawnY = 248; 
		"r_sw1_respawn01": 				respawnX = 272; respawnY = 224; 
		"r_sw2_respawn01": 				respawnX = 312; respawnY = 208; 
		"r_fct_respawn01": 				respawnX = 240; respawnY = 304; 
		"r_min_respawn01":				respawnX = 588; respawnY = 248;
		"r_far_nexus01":				respawnX = 488; respawnY = 720;
		"r_ice_respawn01":				respawnX = 240; respawnY = 200;
		"r_gau_01_entrance01":			respawnX = 224; respawnY = 208;
		"r_pea_caveRespawnBase01":		respawnX = 184; respawnY = 264;
		"r_usw_ruinsWifi01":			respawnX = 368; respawnY = 176;
	
	## TODO add junklord check - RespawnLocation line 354
	
	# Once past the point of no return #
	if B2_Playerdata.Quest("pointOfNoReturn") == 1:
		respawnRoom = "r_chu_corridor01"
		respawnX = 136; 
		respawnY = 296;
		
	## NOTE This piece of code was moved to the gameover screen -> uid://cqm2w1d4jwnwn
	## Increase death count
	#var deaths : int = B2_Config.get_user_save_data( "player.deaths.total", 0 )
	#deaths += 1
	#B2_Config.set_user_save_data( "player.deaths.total", deaths )
		
	# Debug messages #
	print("B2_RoomXY: You have died: " 		+ str( B2_Config.get_user_save_data( "player.deaths.total", 0 ) ) + " times"	);
	print("B2_RoomXY: respawnRoom = " 		+ str(respawnRoom)			);
	print("B2_RoomXY: respawnX = " 			+ str(respawnX)				);
	print("B2_RoomXY: respawnY = " 			+ str(respawnY)				);
		
	fancy_warp_to( respawnRoom, respawnX, respawnY )
	
## Instead of using the GML style string, this uses arguments as parameters
func fancy_warp_to( respawnRoom : String, respawnX : float, respawnY : float ):
	warp_to( respawnRoom + "," + str(respawnX) + "," + str(respawnY) )
	
## Compatibility with old GML transport string.
func warp_to( room_transition_string : String, _delay := 0.0, skip_fade_out := false ):
	if room_load_lock:
		push_warning("B2_RoomXY: Tried to load new room %s before the current one (%s) finishes." % [ room_transition_string, this_room ])
		return
	if randi_range(0,99) == 69: print_rich( "[color=red][bgcolor=white]BAZINGA![/bgcolor][/color]" ) ## VERY IMPORTANT. CRITICAL even.
		
	room_load_lock = true
	started_loading.emit()
	B2_Screen.set_cursor_type( B2_Screen.TYPE.POINT )
	var split := room_transition_string.split( ",", true )
	split.resize( 6 )

	var its_the_same_room := false

	var room_name 	:= str( split[0] ).strip_edges()
	var room_x 		:= float( split[1] )
	var room_y 		:= float( split[2] )
	var slide_dir	:= int( split[3] ) ## No idea what this is.
	var open_sfx	:= str( split[4] ).strip_edges()
	var close_sfx	:= str( split[5] ).strip_edges()

	var fade_modifier := 1.0

	if room_name == this_room:
		print("Room_XY: Warping to the same room.")
		its_the_same_room = true
		fade_modifier = 0.70

	## Non game rooms. Mostly the title screen and CC.
	if not room_name == "r_title" or room_name == "r_cc" or room_name == "r_scale":

		# save destination data
		this_room 		= room_name
		this_room_x 	= room_x
		this_room_y 	= room_y

		if B2_Playerdata.Quest("saveDisabled") == 0:
			B2_Config.set_user_save_data("map.room", this_room)
			B2_Config.set_user_save_data("map.x", this_room_x);
			B2_Config.set_user_save_data("map.y", this_room_y);

		# Save game during room transition
		if B2_Playerdata.Quest("saveDisabled") == 0: # scr_map_roomstart() line 108
			B2_Playerdata.SaveGame()

	if print_debug_logs: print("B2_RoomXY: Started loading room %s." % room_name)
	
	B2_Input.cutscene_is_playing = false
	
	add_child(room_transition_layer)
	add_child(room_progress_bar)

	# Take away the player control.
	B2_Input.player_has_control = false

	if not its_the_same_room:
		begin_load_room_scene( room_name )

	var tween : Tween
	
	if not skip_fade_out:
		tween = create_tween()
		tween.tween_property( room_transition_layer, "modulate:a", 1.0, fade_time_out * fade_modifier )
		await tween.finished
		fadeout_finished.emit()

		# set the delay before loading the room.
		if _delay > 0.0:
			await get_tree().create_timer( _delay ).timeout
		else:
			await get_tree().create_timer( fade_delay * fade_modifier ).timeout

	else:
		room_transition_layer.modulate.a = 1.0
		await get_tree().process_frame

	if not its_the_same_room:
		finish_loading_room_scene( room_name ) 				# Load the next room
		get_tree().change_scene_to_packed( room_scene )		# change the current room
		await get_tree().process_frame
	else:
		if is_instance_valid( B2_CManager.o_hoopz ):
			B2_CManager.o_hoopz.position = Vector2( room_x, room_y )
		else:
			# What happened?
			breakpoint

		if is_instance_valid( B2_CManager.camera ):
			B2_CManager.camera.position = Vector2( room_x, room_y )
		else:
			# What happened?
			breakpoint
	
	## Gives control back
	B2_Input.player_has_control = true

	tween = create_tween()
	tween.tween_property( room_transition_layer, "modulate:a", 0.0, fade_time_in * fade_modifier )

	## Cleanup
	tween.tween_callback( remove_child.bind( room_transition_layer ) )
	tween.tween_callback( remove_child.bind( room_progress_bar ) )
	await tween.finished

	# Give back player control
	#B2_Input.player_has_control = true
	room_reference = get_tree().current_scene
	room_finished_loading.emit()
	room_load_lock = false
	if print_debug_logs: print("Finished loading room %s." % room_name)
	## NOTE 09/06/25 Deltarune ch 3 and 4 was pretty good. still need to finish the weird rounte on ch4.
	## future me, is ch 5 and 6 any good?

## Begin loading level with threaded load. This should be called before the fade out effect.
func begin_load_room_scene( room_name : String ) -> void:
	room_is_invalid = false
	if print_room_load_logs: print_rich( "[bgcolor=black]B2_RoomXY: Loading room %s started.[/bgcolor]" % room_name )
	t1 = Time.get_ticks_msec()
	if room_index.has( room_name ):
		path_loading_room = room_index[ room_name ]
		if print_debug_logs: print(path_loading_room)
		ResourceLoader.load_threaded_request( path_loading_room, "PackedScene", use_subthreads, cachemode )
		is_loading_room = true

		#var error = await room_loaded

## Finish loading a new level. Should be run after the fadeout. NOTE ResourceLoader.load_threaded_get() locks the main thread.
func finish_loading_room_scene( room_name ) -> void:
	room_scene = ResourceLoader.load_threaded_get( path_loading_room ) as PackedScene
	
	## Room scene not valid, load debug room.
	if not room_scene:
		push_error( "B2_RoomXY: Room %s not indexed." % room_name )
		room_index_dirty.emit()
		room_is_invalid = true
		this_room_x 	= 0
		this_room_y 	= 0
		push_error( "B2_RoomXY: Room %s failed to load. Falling back to %s." % [room_name, invalid_room] )
		print_rich( "[color=pink]Loading debug save data...[/color]")
		B2_Config.select_user_slot( 100 ) ## Debug Save slot
		room_scene = ResourceLoader.load( invalid_room, "PackedScene", cachemode ) as PackedScene
		
	## Performance debug data.
	t2 = Time.get_ticks_msec() - t1
	if print_room_load_logs: print_rich( "[bgcolor=black]B2_RoomXY: Room %s loading took %s msecs.[/bgcolor]" % [ room_name, str(t2 ) ] )
	if t2 > 1000.0:
		if print_room_load_logs: print_rich("[color=yellow]Warning: room load took a long time.[/color]")

func add_player_to_room( pos : Vector2, add_camera : bool ):
	if this_room.is_empty():
		push_error("B2_RoomXY: Room name empty. Aborting player node creation.")
		return

	# Pos is invalid. do not spawn player.
	if pos == Vector2.ZERO:
		return

	var player_scene 	:= B2_CManager.o_hoopz_scene
	var player_node 	:= player_scene.instantiate() as B2_Player

	player_node.position = pos
	get_tree().current_scene.add_child( player_node, true )
	if add_camera:
		var cam := B2_Camera_Hoopz.new()
		get_tree().current_scene.add_child( cam, true )
		cam.cinema_snap( pos )
		cam.follow_player( player_node )

		if get_tree().current_scene is B2_ROOMS:
			cam.set_camera_bound( get_tree().current_scene.camera_bound_to_map )

		cam.follow_mouse = true

	if print_debug_logs: print( "B2_RoomXY: Player loaded at %s. camera state is %s." % [str(pos), str(add_camera)] )
	# reset_room()

func _process(_delta: float) -> void:
	if is_loading_room:
		var error := ResourceLoader.load_threaded_get_status( path_loading_room, load_progress )
		
		if error == 1: 		## The resource is still being loaded.
			if room_progress_bar != null:
				room_progress_bar.visible = true
				room_progress_bar.value = load_progress.front()
		if error == 3:		## The resource was loaded successfully and can be accessed via load_threaded_get().
			is_loading_room = false
			room_progress_bar.visible = false
			load_progress.clear()
		if error == 2:		## Some error occurred during loading and it failed.
			is_loading_room = false
			room_progress_bar.visible = false
			load_progress.clear()
