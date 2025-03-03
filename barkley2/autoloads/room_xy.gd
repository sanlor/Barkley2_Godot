extends CanvasLayer

## Node responsible for room transitions.
# Check the original RoomXY() script.
## RoomXY(room, x, y, slide_direction [4 args] open_sfx [5 args], close_sfx [5 args])

## DEBUG
var print_debug_logs := false
var print_room_load_logs := true

signal started_loading
signal room_loaded( has_error )
signal room_finished_loading

signal fadeout_finished

var is_loading_room 	:= false
var path_loading_room 	:= ""
var load_progress		:= []

## Threaded load.
var use_subthreads 		:= false # setting this to true causes issues. # https://github.com/godotengine/godot/pull/93032
var cachemode			:= ResourceLoader.CACHE_MODE_REPLACE

## Bellow vars are used by the cinema script, to add the player character.
var this_room 		:= ""
var this_room_x 	:= 0.0
var this_room_y 	:= 0.0

var fade_time_in 		:= B2_Config.settingFadeIn
var fade_delay 			:= B2_Config.settingFadeDelay
var fade_time_out 		:= B2_Config.settingFadeOut

var invalid_room 	:= "res://barkley2/rooms/ai_ruins/r_air_throneRoom01.tscn" # "res://barkley2/rooms/r_wip.tscn" # Fallback room
var room_folder 	:= "res://barkley2/rooms/"

var room_load_lock	:= false # disallow loading a new room defore the current one finishes loading

var room_array := [ # need a better way to do this.
	## Menus, non gameplay
	#"res://barkley2/rooms/r_title.tscn",
	#"res://barkley2/rooms/r_cc.tscn",
	#"res://barkley2/rooms/r_wip.tscn",
	#
	## Actual rooms
	#
	### Tutorial - Factory 2nd floor
	#"res://barkley2/rooms/factory/floor2/r_fct_accessHall01.tscn",
	#"res://barkley2/rooms/factory/floor2/r_fct_eggRooms01.tscn",
	#"res://barkley2/rooms/factory/floor2/r_fct_tutorialZone01.tscn",
	#"res://barkley2/rooms/factory/floor2/r_fct_reroute01.tscn",
	#"res://barkley2/rooms/factory/floor2/r_fct_eggDrone01.tscn",
	#"res://barkley2/rooms/factory/outside/r_fct_factoryOutpost01.tscn",
	#
	### AIR
	#"res://barkley2/rooms/ai_ruins/r_air_boss01.tscn",
	#"res://barkley2/rooms/ai_ruins/r_air_cloister01.tscn",
	#"res://barkley2/rooms/ai_ruins/r_air_corridor01.tscn",
	#"res://barkley2/rooms/ai_ruins/r_air_dais01.tscn",
	#"res://barkley2/rooms/ai_ruins/r_air_entrance03.tscn",
	#"res://barkley2/rooms/ai_ruins/r_air_filler01.tscn",
	#"res://barkley2/rooms/ai_ruins/r_air_finalgun01.tscn",
	#"res://barkley2/rooms/ai_ruins/r_air_scannerFirst01.tscn",
	#"res://barkley2/rooms/ai_ruins/r_air_throneRoom01.tscn", ## main debug room
]
var room_index := {}
var room_scene : PackedScene
var room_is_invalid := false

#var player_scene := "res://barkley2/scenes/Player/o_hoopz.tscn"

const ROOM_PROGRESS_BAR 		= preload("res://barkley2/resources/autoloads/room_progress_bar.tscn")
const ROOM_TRANSITION_LAYER 	= preload("res://barkley2/resources/autoloads/room_transition_layer.tscn")

var room_transition_layer: 	ColorRect
var room_progress_bar: 		ProgressBar

func _index_rooms():
	room_array = FileSearch.search_dir( "res://barkley2/rooms/", "", true )
	#print(room_array)
	## Godot is kinda weird sometimes.
	## PackedScene in exported projects are named *.tscn.remap for some reason.
	## This basically handles the project in the editor and on exported projects.
	for r : String in room_array:
		if 	r.ends_with(".tscn"):
			var r_name = r.rsplit("/", true, 1)[1].trim_suffix(".tscn")
			room_index[r_name] = r
		elif r.ends_with(".tscn.remap"):
			var r_name = r.rsplit("/", true, 1)[1].trim_suffix(".tscn.remap")
			room_index[r_name] = r.trim_suffix(".remap")

	print("_index_rooms() ended: ", Time.get_ticks_msec(), "msecs. - ", room_index.size(), " room_index key entries")
	
func _ready() -> void:
	_index_rooms()
	room_transition_layer 	= ROOM_TRANSITION_LAYER.instantiate()
	room_progress_bar 		= ROOM_PROGRESS_BAR.instantiate()
	process_mode 			= ProcessMode.PROCESS_MODE_ALWAYS
	layer 					= B2_Config.ROOMXY_LAYER
	B2_Config.title_screen_loaded.connect( _reset_data )

func _reset_data():
	reset_room()
	
func is_room_valid( strict := false) -> bool:
	if strict:
		if this_room_x == 0 or this_room_y == 0 or this_room.is_empty():
			return false
	return not this_room.is_empty()
	
func get_room_pos() -> Vector2:
	return Vector2( this_room_x, this_room_y )
	
# Reset room data. is this needed?
func reset_room() -> void:
	this_room 		= ""
	this_room_x 	= 0.0
	this_room_y 	= 0.0
	print_rich( "[color=yellow]Room data reseted[/color]" )
	
func warp_to( room_transition_string : String, _delay := 0.0, skip_fade_out := false ):
	if room_load_lock:
		push_warning("Tried to load new room %s before the current one (%s) finishes." % [ room_transition_string, this_room ])
		return
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
	
	if print_debug_logs: print("Started loading room %s." % room_name)
	
	add_child(room_transition_layer)
	add_child(room_progress_bar)
	
	# Take away the player control.
	B2_Input.player_has_control = false
	
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
		await get_room_scene( room_name ) 						# Load the next room
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
		
	B2_Input.player_has_control = true
	
	tween = create_tween()
	tween.tween_property( room_transition_layer, "modulate:a", 0.0, fade_time_in * fade_modifier )
	
	## Cleanup
	tween.tween_callback( remove_child.bind( room_transition_layer ) )
	tween.tween_callback( remove_child.bind( room_progress_bar ) )
	await tween.finished
	
	# Give back player control
	#B2_Input.player_has_control = true
	room_finished_loading.emit()
	room_load_lock = false
	if print_debug_logs: print("Finished loading room %s." % room_name)
	return
	
	
func get_room_scene( room_name : String ):
	room_is_invalid = false
	if print_room_load_logs: print_rich( "[bgcolor=black]Loading room %s started.[/bgcolor]" % room_name )
	var t1 := Time.get_ticks_msec()
	if room_index.has( room_name ):
		path_loading_room = room_index[ room_name ]
		if print_debug_logs: print(path_loading_room)
		ResourceLoader.load_threaded_request( path_loading_room, "PackedScene", use_subthreads, cachemode )
		is_loading_room = true
		
		var error = await room_loaded
		
		var t2 := Time.get_ticks_msec() - t1
		if print_room_load_logs: print_rich( "[bgcolor=black]Room %s loading took %s msecs.[/bgcolor]" % [ room_name, str(t2 ) ] )
		if t2 > 1000.0:
			if print_room_load_logs: print_rich("[color=yellow]Warning: room load took a long time.[/color]")
		if not error:
			room_scene = ResourceLoader.load_threaded_get( path_loading_room ) as PackedScene
			return 
		print("Load error: ", error)
	else:
		push_error("Room %s not indexed." % room_name)
	
	room_is_invalid = true
	this_room_x 	= 0
	this_room_y 	= 0
	push_error("Room %s failed to load. Falling back to %s." % [room_name, invalid_room] )
	room_scene = load( invalid_room ) as PackedScene
	return 

func add_player_to_room( pos : Vector2, add_camera : bool ):
	if this_room.is_empty():
		push_error("Room name empty. Aborting player node creation.")
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
		
	if print_debug_logs: print( "RoomXY: Player loaded at %s. camera state is %s." % [str(pos), str(add_camera)] )
	# reset_room()

func _process(_delta: float) -> void:
	if is_loading_room:
		var error := ResourceLoader.load_threaded_get_status( path_loading_room, load_progress )
		# THREAD_LOAD_INVALID_RESOURCE = 0
		#		The resource is invalid, or has not been loaded with load_threaded_request().
		# THREAD_LOAD_IN_PROGRESS = 1
		#		The resource is still being loaded.
		# THREAD_LOAD_FAILED = 2
		#		Some error occurred during loading and it failed.
		# THREAD_LOAD_LOADED = 3
		#		The resource was loaded successfully and can be accessed via load_threaded_get().
		if error == 1:
			if room_progress_bar != null:
				room_progress_bar.visible = true
				room_progress_bar.value = load_progress.front()
		if error == 3:
			is_loading_room = false
			room_progress_bar.visible = false
			room_loaded.emit( false )
			load_progress.clear()
		if error == 2:
			is_loading_room = false
			room_progress_bar.visible = false
			room_loaded.emit( true )
			load_progress.clear()
