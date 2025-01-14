extends B2_Camera
class_name B2_Camera_Hoopz

# scr_event_camera_frame()
# check o_camera_hoopz
# check o_camera

signal destination_reached

enum MODE{FOLLOW, CINEMA, FRAMEFOLLOW}
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

## Shake stuff
var shake_rng 				:= RandomNumberGenerator.new()
var shake_array 			: Array[ Array ]
var camera_shake_offset 	:= Vector2.ZERO

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
	B2_Input.camera_follow_mouse.connect( func(state): follow_mouse = state )
	
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

func follow_player( _player_node ):
	curr_MODE = MODE.FOLLOW
	player_node = _player_node
	
func follow_actor( _actor_array : Array, _speed : String ):
	curr_MODE = MODE.FRAMEFOLLOW
	actor_array = _actor_array
	match _speed:
		"CAMERA_FAST": 		speed = speed_fast
		"CAMERA_SLOW": 		speed = speed_slow
		"CAMERA_NORMAL": 	speed = speed_normal

# snap to the target
func cinema_snap( _destination : Vector2 ):
	curr_MODE 	= MODE.CINEMA
	position 	= _destination
	offset 		= camera_normal_offset

# move to te target
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
			var rl : TileMapLayer = get_parent().reference_layer.front()
			#limit_top 		= rl.get_used_rect().position.y 	* 16
			#limit_left 		= rl.get_used_rect().position.x 	* 16
			#limit_right 	= rl.get_used_rect().end.x 			* 16
			#limit_bottom 	= rl.get_used_rect().end.y 			* 16
			limit_width 	= Vector2( rl.get_used_rect().position.x, rl.get_used_rect().end.x ) * 16.0
			limit_height 	= Vector2( rl.get_used_rect().position.y, rl.get_used_rect().end.y ) * 16.0
		else:
			push_warning( "Invalid parent, can't set camera limits." )
	#else:
		#limit_top 		= -100000
		#limit_left 		= -100000
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
## TODO - Radius is also ignored.
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
				shakeStrength = lerpf( shakeStrength, 0.0, 1.0 * delta )
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
	
				
func _process(delta: float) -> void:
	# process shake effects.
	_process_shake(delta)
	
	match curr_MODE:
		MODE.FRAMEFOLLOW:
			if actor_array.is_empty():
				return

			# is this the best way to get an average of an array?
			var arr_size := actor_array.size()
			var avg_pos := Vector2.ZERO
			for node : Node2D in actor_array:
				avg_pos += node.position
			avg_pos /= arr_size
			
			position 	= position.move_toward( avg_pos, (speed * 30) * delta )
			offset 		= offset.move_toward( camera_normal_offset, 0.5 * camera_follow_speed * delta ) + camera_shake_offset
			
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
			if is_instance_valid(player_node):
				if is_lost:
					# Just jump to the player.
					position 	= player_node.position
					#_position 	= player_node.position
					is_lost = false
					return
				#_position = player_node.position
				position = position.move_toward(player_node.position, 300 * delta)
				
				if follow_mouse:
					var mouse_dir 	:= player_node.position.direction_to( 	get_global_mouse_position() )
					var mouse_dist 	:= player_node.position.distance_to( 	get_global_mouse_position() )
					mouse_dist = clampf( mouse_dist, 0.0, 250.0 )
					offset = offset.move_toward( mouse_dir * mouse_dist / 3.0, camera_follow_speed * delta ) + camera_shake_offset
					offset = offset.round() # fixes jittery movement. THIS TIME!
				else:
					offset = camera_normal_offset + camera_shake_offset
					
				#print(offset)
			else:
				is_lost = true
				offset = camera_normal_offset + camera_shake_offset
			
			if camera_bound_to_map:
				## Avoid seeing outside the map.
				#position.x = clamp( position.x, )
				
				offset.x = clamp( offset.x, (384.0/2.0 - position.x), limit_width.y - (384.0/2.0 + position.x) )
				offset.y = clamp( offset.y, (384.0/2.0 - position.y), limit_height.y - (384.0/2.0 + position.y) )
		
	if show_debug_data:
		if is_instance_valid(debug_data):
			_update_debug_data()
