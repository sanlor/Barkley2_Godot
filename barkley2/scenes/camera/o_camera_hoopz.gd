extends B2_Camera
class_name B2_Camera_Hoopz

# scr_event_camera_frame()
# check o_camera_hoopz
# check o_camera

signal destination_reached

# FOLLOW - Camera follows the players. Simple.
# CINEMA - Camera is controlled by the Cinema Script, like in cutscenes.
# FRAMEFOLLOW - Follows an actor during the Cinema Script.
# COMBAT - New. Camera is controlled by the Combat script. ## FIXME
enum MODE{FOLLOW, CINEMA, FRAMEFOLLOW, COMBAT}
var curr_MODE := MODE.FOLLOW

var debug_data: Label

@export var show_debug_data 	:= true

@export var speed_slow 			:= 3.5
@export var speed_normal 		:= 5.0
@export var speed_fast 			:= 7.5
@export var camera_follow_speed := 750.0 # Speed that the camera follows the mouse.

var speed := speed_normal
var is_moving := false
var destination := Vector2.ZERO
#var _position : Vector2 # Allow int based movement. aides in the movement smoothing to avoid fittering when the camera moves.

# stop wandering camera
var is_lost := true

# Keep camera inbound.
@export var camera_bound_to_map			:= false # Camera cannot see outside the map. This setting should be set on the B2_ROOMS.
var limit_height 	:= Vector2.ZERO
var limit_width 	:= Vector2.ZERO
#var safety := true

# camera position is influenced by the mouse position
@export var follow_mouse_overide := false
var follow_mouse := false

@export var player_node_overide : Node2D
var player_node : Node2D

## Follow Frame
var actor_array : Array

## Camera stuff
var camera_normal_offset := Vector2( 0,20 )
var camera_combat_offset := Vector2( 0,0 )

## Shake stuff
var shake_rng 				:= RandomNumberGenerator.new()
var shake_array 			: Array[ Array ]
var camera_shake_offset 	:= Vector2.ZERO

## Combat camera
var focus 		:= Vector2.ZERO
var cam_zoom 	:= 1.0

var manual_control := false
var manual_target	: Node

func _ready() -> void:
	if player_node_overide != null:
		player_node = player_node_overide
		print( "Camera: Debug player node %s set." % player_node.name )
		
	if follow_mouse_overide:
		follow_mouse = follow_mouse_overide
		print( "Camera: Debug follow mouse is set to true." )
		
	if player_node != null:
		position 	= player_node.position
		#_position 	= player_node.position
		
	position 			= position.round()
	offset 				= camera_normal_offset
	
	B2_CManager.camera 	= self
	B2_SignalBus.camera_follow_mouse.connect( func(state): follow_mouse = state )
	
	if show_debug_data:
		debug_data 								= Label.new()
		debug_data.label_settings 				= LabelSettings.new()
		debug_data.label_settings.font 			= load("res://barkley2/resources/fonts/fn_small.tres")
		debug_data.label_settings.font_color 	= Color.MAGENTA
		debug_data.horizontal_alignment 		= HORIZONTAL_ALIGNMENT_CENTER
		debug_data.position 					= Vector2(-384.0 / 2.0, -64)
		debug_data.size 						= Vector2(384, 32)
		debug_data.z_index 						= 4000
		
		add_child( debug_data, true )

func combat_focus( _focus : Vector2, _cam_zoom : float ) -> void:
	curr_MODE = MODE.COMBAT
	focus = _focus
	cam_zoom = _cam_zoom

func follow_player( _player_node ):
	curr_MODE = MODE.FOLLOW
	player_node = _player_node
	zoom = Vector2.ONE
	
func follow_actor( _actor_array : Array, _speed : String ):
	curr_MODE = MODE.FRAMEFOLLOW
	actor_array = _actor_array
	match _speed:
		"CAMERA_FAST": 		speed = speed_fast
		"CAMERA_SLOW": 		speed = speed_slow
		"CAMERA_NORMAL": 	speed = speed_normal
	zoom = Vector2.ONE
	
# snap to the target
func cinema_snap( _destination : Vector2 ):
	curr_MODE 	= MODE.CINEMA
	position 	= _destination
	offset 		= camera_normal_offset
	zoom = Vector2.ONE

# move to the target
func cinema_frame( _destination : Vector2, _speed : String ):
	curr_MODE = MODE.CINEMA
	match _speed:
		"CAMERA_FAST": 		speed = speed_fast
		"CAMERA_SLOW": 		speed = speed_slow
		"CAMERA_NORMAL": 	speed = speed_normal
		
	# move torward the target
	var tween := create_tween()
	tween.set_parallel(true)
	tween.tween_property( self, "position", 	_destination, 	speed / 30)
	tween.tween_property( self, "offset", 		Vector2(0,20), 	speed / 30 )
	await tween.finished
	zoom = Vector2.ONE
	return 
	
## Yup, its an array. the original system takes an array of nodes / positions and average the target position. This way, the camera can go between the nodes.
func cinema_moveto( _destinations : Array, _speed : String ):
	curr_MODE = MODE.CINEMA
	# Default behaviour
	match _speed:
		"CAMERA_FAST":
			speed = speed_fast
		"CAMERA_SLOW":
			speed = speed_slow
		"CAMERA_NORMAL":
			speed = speed_normal
	
	if _destinations.is_empty():
		push_error("Empty destinations. weird.")
		return
		
	destination = Vector2.ZERO
	while _destinations.has(null):
		print("Camera: node is invalid. ", _destinations.find(null), " - ", _destinations )
		_destinations.erase(null)
			
	for node in _destinations:
		destination += node.position
	
	destination = destination / _destinations.size()
	is_moving = true
	zoom = Vector2.ONE

## Function checks if the node is doing anything
## Return void right awai if itsd idle. Await for a signal if its busy.
func check_actor_activity() -> void:
	if is_moving:
		# is moving toward something.
		await destination_reached
		return
	else:
		# not doing anything important
		return

func set_camera_bound( _is_bound : bool ):
	camera_bound_to_map = _is_bound
	# camera limits with the offset feels terrible. something is wrong with my code.
	if _is_bound:
		if get_parent() is B2_ROOMS:
			var map_rect : Rect2 = get_parent().map_rect
			limit_width 	= Vector2( map_rect.position.x, map_rect.end.x ) * 16.0
			limit_height 	= Vector2( map_rect.position.y, map_rect.end.y ) * 16.0
			print( "o_camera_hoopz: limit_width: ", limit_width/16, " - limit_height: ", limit_height/16 )
		else:
			push_warning( "o_camera_hoopz: Invalid parent, can't set camera limits." )
	#else:
		#limit_top 		= -100000
		#limit_left 	= -100000
		#limit_right 	=  100000
		#limit_bottom 	=  100000

## Shake functions, controls camera shake. check Shake().
func add_shake( shakeStrength : float, shakeRadius : float, shakeX := 0.0, shakeY := 0.0, shakeTime := 0.0 ):
	var index = shake_array.size()
	var shake_data := [ shakeStrength * 0.35, shakeRadius, shakeX, shakeY, shakeTime * 1.0 ]
	shake_array.append( shake_data )
	return index
	
func edit_shake( shakeIndex : int, shakeStrength : float, shakeRadius : float, shakeX := 0.0, shakeY := 0.0, shakeTime := 0.0 ):
	if shakeIndex in range( shake_array.size() ):
		shake_array[shakeIndex] = [ shakeStrength * 0.25, shakeRadius, shakeX, shakeY, shakeTime * 1.0 ]
	else:
		push_error("Index %s does not exist in %s... I think." % [ shakeIndex, shake_array.size() ])
	
func remove_shake( shakeIndex : int ):
	if shakeIndex in range( shake_array.size() ):
		shake_array.remove_at( shakeIndex )
	else:
		push_error("Index %s does not exist in %s... I think." % [ shakeIndex, shake_array.size() ])
	
func clear_shake():
	shake_array.clear()

# https://www.youtube.com/watch?v=LGt-jjVf-ZU
## Allow camera shake. There may be multiple "shake" sources, like multiple explosions.
## This system allows adding these multiple explosions, so none can override eachother.
## TODO - SETUP the shake origin. No idea how to use that. 
## TODO - Radius is also ignored.'
func _process_shake(delta: float) -> void:
	if shake_array.is_empty():
		camera_shake_offset = Vector2.ZERO
		return
		
	var shake_cleanup := false ## remove inactive shake indexes.
	var shake_effect := Vector2.ZERO
	#print( shake_array )
	for shake_data : Array in shake_array:
		var shakeStrength 	= shake_data[0]
		var shakeRadius 	= shake_data[1]
		var shakeX 			= shake_data[2]
		var shakeY 			= shake_data[3]
		var shakeTime 		= shake_data[4]
		
		if shakeStrength > 0.25:
			var rand_offset := Vector2(shake_rng.randf_range( -shakeStrength, shakeStrength ), shake_rng.randf_range( -shakeStrength, shakeStrength ) )
			
			if shakeTime < 0.0:
				#shakeStrength = move_torward( shakeStrength, 0.0, 1.0 * delta ) # no lerp. 
				shakeStrength = lerpf( shakeStrength, 0.0, 4.0 * delta )
				shake_data[0] = shakeStrength
			else:
				shake_data[4] -= ( Engine.get_frames_per_second() * 10) * delta 	# time
			shake_effect += rand_offset
		else:
			shake_cleanup = true
			
	camera_shake_offset = shake_effect
	#print(shake_array.size())
	
	# clean inactive arrays
	if shake_cleanup:
		var clean_array : Array[Array]
		for shake_data : Array in shake_array:
			if shake_data[0] > 0.25:
				clean_array.append( shake_data )
				
		if not clean_array.is_empty():
			shake_array = clean_array
		else:
			shake_array.clear()
				
func _update_debug_data():
	debug_data.text = 	"Pos: " 			+ str(position) 		+ "\n"
	debug_data.text += 	"Off: " 			+ str(offset) 			+ "\n"
	debug_data.text += 	"Limit Height: " 	+ str(limit_height) 	+ "\n"
	debug_data.text += 	"Limit Hidth: " 	+ str(limit_width)
	
func _physics_process(delta: float) -> void:
	if manual_control:
		global_position 	= global_position.lerp( manual_target.global_position, 0.1 )
		#offset 				= offset.lerp( Vector2.ZERO, 0.1 )
		offset 				= offset.lerp( camera_normal_offset, 0.1 )
		zoom 				= zoom.lerp( Vector2.ONE, 0.1)
		return
		
	# process shake effects.
	_process_shake( delta )
	
	match curr_MODE:
		MODE.FRAMEFOLLOW:
			if actor_array.is_empty():
				return

			# is this the best way to get an average of an array?
			var arr_size := actor_array.size()
			var avg_pos := Vector2.ZERO
			for node : Node2D in actor_array:
				if node == null: ## Avoid issoes with fast changing actors.
					continue
				avg_pos += node.position
			avg_pos /= arr_size
			
			## NOTE What feels better? Lerp of move_torward?
			position 	= position.move_toward( avg_pos, (speed * 20) * delta )
			#position 	= position.lerp( avg_pos, (speed * 10) * delta )
			offset 		= offset.move_toward( camera_normal_offset, 0.25 * camera_follow_speed * delta ) + camera_shake_offset
			#offset 		= offset.lerp( camera_normal_offset, 0.125 * camera_follow_speed * delta ) + camera_shake_offset
			
		MODE.CINEMA:
			if is_moving:
				position = position.move_toward(destination, (speed * 30) * delta)
				
				if position.is_equal_approx(destination):
					is_moving = false
					destination_reached.emit()
					
			#position = _position.round()
			#position = _position.floor()
			offset	= offset.move_toward(camera_normal_offset, camera_follow_speed * delta) + camera_shake_offset
			#position = _position
			
		MODE.FOLLOW:
			if is_instance_valid( player_node ):
				if is_lost: ## NOTE Is still needed?
					# Just jump to the player. 
					#position 	= player_node.position # 16/05/25 Disabled this. dont even remember how is this used.
					#_position 	= player_node.position
					is_lost = false
					return
					
				#_position = player_node.position
				position = position.move_toward(player_node.position, 120 * delta)
				
				if follow_mouse:
					var mouse_dir 	:= Vector2.ZERO
					var mouse_dist 	:= 0.0
					if B2_Input.player_has_control: ## Cant influence camera if the player doesnt have control.
						mouse_dir 	= player_node.position.direction_to( 	get_global_mouse_position() )
						mouse_dist 	= player_node.position.distance_to( 	get_global_mouse_position() )
					mouse_dist = clampf( mouse_dist, 0.0, 250.0 )
					offset = offset.move_toward( mouse_dir * mouse_dist / 3.0, camera_follow_speed * delta ) + camera_shake_offset
					#offset = offset.round() # fixes jittery movement. THIS TIME!
				else:
					offset = camera_normal_offset + camera_shake_offset
					
			else:
				is_lost = true
				#print(offset)
				offset = offset.lerp( camera_normal_offset + camera_shake_offset, 0.05 )
			
			if camera_bound_to_map:
				## Avoid seeing outside the map.
				## NOTE THis was a huge pain to deal with, because of the way the camera follows the mouse (using offsets).
				offset.x = clamp( offset.x, limit_width.x + (384.0/2.0 - position.x), limit_width.y - (384.0/2.0 + position.x) )
				offset.y = clamp( offset.y, limit_height.x + (240.0/2.0 - position.y), limit_height.y - (240.0/2.0 + position.y) )
		
		MODE.COMBAT:
			offset = offset.lerp( camera_combat_offset, (speed / 200.0) ) + camera_shake_offset
			position = position.lerp( focus, (speed / 200.0) )
			zoom = zoom.lerp( Vector2.ONE / clampf( cam_zoom / 100.0, 1.0, 2.0 ), ( speed / 200.0 ) )
		
	if B2_Debug.show_camera_debug_data:
		if show_debug_data:
			if is_instance_valid(debug_data):
				_update_debug_data()
