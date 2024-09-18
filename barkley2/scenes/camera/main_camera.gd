extends Camera2D

# scr_event_camera_frame()

signal destination_reached

enum MODE{FOLLOW, CINEMA}
var curr_MODE := MODE.FOLLOW

var speed := 2.0
var is_moving := false
var destination := Vector2.ZERO
var _position : Vector2 # Allow int based movement. aides in the movement smoothing to avoid fittering when the camera moves.

func _ready() -> void:
	_position = position.round()

var player_node

func follow_player( _player_node ):
	player_node = _player_node
	curr_MODE = MODE.FOLLOW

func cinema_moveto( _destinations : Array, _speed : String ):
	curr_MODE = MODE.CINEMA
	# Default behaviour
	match _speed:
		"CAMERA_FAST":
			speed = 5.0
		"CAMERA_SLOW":
			speed = 1.0
		"CAMERA_NORMAL":
			speed = 2.0
	
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
	await destination_reached
	return

func _process(delta: float) -> void:
	match curr_MODE:
		MODE.CINEMA:
			if is_moving:
				_position = _position.move_toward(destination, (speed * 30) * delta)
				if _position.is_equal_approx(destination):
					is_moving = false
					destination_reached.emit()
					
				#position = _position.round()
				position = _position.floor()
				#print(position)
		MODE.FOLLOW:
			if is_instance_valid(player_node):
				_position = player_node.position
			
			#position = _position.round()
			position = _position.floor()
