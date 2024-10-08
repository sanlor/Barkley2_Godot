extends B2_Camera
class_name B2_Camera_Hoopz

# scr_event_camera_frame()
# check o_camera_hoopz
# check o_camera

signal destination_reached

enum MODE{FOLLOW, CINEMA}
var curr_MODE := MODE.FOLLOW

@export var speed_slow 			:= 2.5
@export var speed_normal 		:= 4.0
@export var speed_fast 			:= 6.0
@export var camera_follow_speed := 550.0 # Speed that the camera follows the mouse.

var speed := 1.5
var is_moving := false
var destination := Vector2.ZERO
var _position : Vector2 # Allow int based movement. aides in the movement smoothing to avoid fittering when the camera moves.

# stop wandering camera
var is_lost := true

# Keep camera inbound.
var safety := true

# camera position is influenced by the mouse position
@export var follow_mouse_overide := false
var follow_mouse := false

@export var player_node_overide : Node2D
var player_node : Node2D

func _ready() -> void:
	if player_node_overide != null:
		player_node = player_node_overide
		print( "Camera: Debug player node %s set." % player_node.name )
		
	if follow_mouse_overide:
		follow_mouse = follow_mouse_overide
		print( "Camera: Debug follow mouse is set to true." )
		
	if player_node != null:
		position 	= player_node.position
		_position 	= player_node.position
		
	_position = position.round()
	
	B2_Input.camera_follow_mouse.connect( func(state): follow_mouse = state )

func follow_player( _player_node ):
	player_node = _player_node
	curr_MODE = MODE.FOLLOW

# snap to the target
func cinema_snap( _destination : Vector2 ):
	curr_MODE = MODE.CINEMA
	position 	= _destination

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

func set_safety(_safety : bool):
	safety = _safety
	# camera limits with the offset feels terrible. something is wrong with my code.
	if safety and false: # false is TEMP
		var rl : TileMapLayer = get_parent().reference_layer
		limit_top 		= rl.get_used_rect().position.y 	* 16
		limit_left 		= rl.get_used_rect().position.x 	* 16
		limit_right 	= rl.get_used_rect().end.x 			* 16
		limit_bottom 	= rl.get_used_rect().end.y 			* 16
	else:
		limit_top 		= -100000
		limit_left 		= -100000
		limit_right 	= 100000
		limit_bottom 	= 100000

func _process(delta: float) -> void:
	match curr_MODE:
		MODE.CINEMA:
			if is_moving:
				_position = _position.move_toward(destination, (speed * 30) * delta)
				
				if _position.is_equal_approx(destination):
					is_moving = false
					destination_reached.emit()
					
				#position = _position.round()
				#position = _position.floor()
				position = _position
				
		MODE.FOLLOW:
			if is_instance_valid(player_node):
				if is_lost:
					# Just jump to the player.
					position 	= player_node.position
					_position 	= player_node.position
					is_lost = false
					return
				#_position = player_node.position
				_position = _position.move_toward(player_node.position, 300 * delta)
				
				if follow_mouse:
					var mouse_dir 	:= player_node.position.direction_to( 	get_global_mouse_position() )
					var mouse_dist 	:= player_node.position.distance_to( 	get_global_mouse_position() )
					mouse_dist = clampf( mouse_dist, 0.0,250.0 )
					offset = offset.move_toward( mouse_dir * mouse_dist / 3.0, camera_follow_speed * delta )
					offset = offset.round() # fixes jittery movement. THIS TIME!
				else:
					offset = Vector2( 0,20 )
			else:
				is_lost = true
			#position = _position.round()
			#position = _position.floor()
			position = _position
