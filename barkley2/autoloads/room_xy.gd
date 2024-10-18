extends CanvasLayer

## Node responsible for room transitions.
# Check the original RoomXY() script.
## RoomXY(room, x, y, slide_direction [4 args] open_sfx [5 args], close_sfx [5 args])

signal room_loaded( has_error )
signal room_finished_loading

var is_loading_room 	:= false
var path_loading_room 	:= ""
var load_progress		:= []

## Threaded load.
var use_subthreads 		:= false # setting this to true causes issues. # https://github.com/godotengine/godot/pull/93032
var cachemode			:= ResourceLoader.CACHE_MODE_IGNORE

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

var room_array := [
	# Menus, non gameplay
	"res://barkley2/rooms/r_title.tscn",
	"res://barkley2/rooms/r_cc.tscn",
	"res://barkley2/rooms/r_wip.tscn",
	
	# Actual rooms
	"res://barkley2/rooms/factory/floor2/r_fct_accessHall01.tscn",
	"res://barkley2/rooms/factory/floor2/r_fct_eggRooms01.tscn",
	"res://barkley2/rooms/factory/floor2/r_fct_tutorialZone01.tscn",
	"res://barkley2/rooms/ai_ruins/r_air_throneRoom01.tscn",
	"res://barkley2/rooms/factory/floor2/r_fct_reroute01.tscn",
]
var room_index := {}
var room_scene : PackedScene
var room_is_invalid := false

var player_scene := "res://barkley2/scenes/Player/o_hoopz.tscn"

const ROOM_PROGRESS_BAR 		= preload("res://barkley2/resources/autoloads/room_progress_bar.tscn")
const ROOM_TRANSITION_LAYER 	= preload("res://barkley2/resources/autoloads/room_transition_layer.tscn")

var room_transition_layer: 	ColorRect
var room_progress_bar: 		ProgressBar

func _index_rooms():
	for r : String in room_array:
		var r_name = r.rsplit("/", true, 1)[1].trim_suffix(".tscn")
		room_index[r_name] = r

	print("_index_rooms() ended: ", Time.get_ticks_msec(), "msecs. - ", room_index.size(), " room_index key entries")
	
func _ready() -> void:
	_index_rooms()
	room_transition_layer 	= ROOM_TRANSITION_LAYER.instantiate()
	room_progress_bar 		= ROOM_PROGRESS_BAR.instantiate()
	process_mode 			= ProcessMode.PROCESS_MODE_ALWAYS
	
func get_current_room() -> String:
	return this_room
	
func warp_to( room_transition_string : String, _delay := 0.0, create_player := true, skip_fade_in := false ):
	if room_load_lock:
		push_warning("Tried to load new room %s before the current one finishes." % room_transition_string)
		return
	room_load_lock = true
	var split := room_transition_string.split( ",", true )
	split.resize( 6 )
	
	var room_name 	:= str( split[0] )
	var room_x 		:= float( split[1] )
	var room_y 		:= float( split[2] )
	var slide_dir	:= int( split[3] ) ## No idea what this is.
	var open_sfx	:= str( split[4] )
	var close_sfx	:= str( split[5] )
	
	print("Started loading room %s." % room_name)
	
	add_child(room_transition_layer)
	add_child(room_progress_bar)
	
	# Take away the player control.
	B2_Input.player_has_control = false
	
	var tween : Tween
	
	if not skip_fade_in:
		tween = create_tween()
		tween.tween_property( room_transition_layer, "modulate:a", 1.0, fade_time_out )
		await tween.finished
	
		# set the delay before loading the room.
		if _delay > 0.0:
			await get_tree().create_timer( _delay ).timeout
		else:
			await get_tree().create_timer( fade_delay ).timeout
			
	else:
		room_transition_layer.modulate.a = 1.0
		await get_tree().process_frame
		
	await get_room_scene( room_name ) 						# Load the next room
	get_tree().change_scene_to_packed( room_scene )		# change the current room
	await get_tree().process_frame
	
	# save destination data
	this_room 		= room_name
	this_room_x 	= room_x
	this_room_y 	= room_y
	
	tween = create_tween()
	if create_player and not room_is_invalid:
		tween.tween_callback( add_player_to_room.bind( Vector2( room_x, room_y ), true ) ) # load the player node.
	tween.tween_property( room_transition_layer, "modulate:a", 0.0, fade_time_in )
	
	## Cleanup
	tween.tween_callback( remove_child.bind( room_transition_layer ) )
	tween.tween_callback( remove_child.bind( room_progress_bar ) )
	await tween.finished
	
	# Give back player control
	B2_Input.player_has_control = true
	room_finished_loading.emit()
	room_load_lock = false
	print("Finished loading room %s." % room_name)
	return
	
	
func get_room_scene( room_name : String ):
	room_is_invalid = false
	print_rich( "[bgcolor=black]Loading room %s started.[/bgcolor]" % room_name )
	var t1 := Time.get_ticks_msec()
	if room_index.has( room_name ):
		path_loading_room = room_index[ room_name ]
		ResourceLoader.load_threaded_request( path_loading_room, "PackedScene", use_subthreads, cachemode )
		is_loading_room = true
		
		var error = await room_loaded
		
		var t2 := Time.get_ticks_msec() - t1
		print_rich( "[bgcolor=black]Room %s loading took %s.[/bgcolor]" % [ room_name, str(t2 ) ] )
		if t2 > 1000.0:
			print_rich("[color=yellow]Warning: room load took a long time.[/color]")
		if not error:
			room_scene = ResourceLoader.load_threaded_get( path_loading_room ) as PackedScene
			return 
		print("Load error: ", error)
	else:
		push_error("Room %s not indexed." % room_name)
	
	room_is_invalid = true
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
		
	var player_node := load( player_scene ).instantiate() as B2_Player
	player_node.position = pos
	get_tree().current_scene.add_child( player_node, true )
	if add_camera:
		var cam := B2_Camera_Hoopz.new()
		get_tree().current_scene.add_child( cam, true )
		cam.cinema_snap( pos )
		cam.follow_player( player_node )
		cam.follow_mouse = true
		
	print( "RoomXY: Player loaded at %s. camera state is %s." % [str(pos), str(add_camera)] )

func _process(_delta: float) -> void:
	if is_loading_room:
		var error := ResourceLoader.load_threaded_get_status( path_loading_room, load_progress )
		 # THREAD_LOAD_INVALID_RESOURCE = 0
			#The resource is invalid, or has not been loaded with load_threaded_request().
		# THREAD_LOAD_IN_PROGRESS = 1
			#The resource is still being loaded.
		# THREAD_LOAD_FAILED = 2
			#Some error occurred during loading and it failed.
		# THREAD_LOAD_LOADED = 3
			#The resource was loaded successfully and can be accessed via load_threaded_get().
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
