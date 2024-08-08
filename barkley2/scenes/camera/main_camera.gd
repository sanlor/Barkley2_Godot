extends Camera2D

signal destination_reached
signal all_destination_reached

var speed := 2.0
var is_moving := false
var destination := Vector2.ZERO

func cinema_moveto( _destinations : Array[Node2D], _speed : String ):
	# Default behaviour
	match _speed:
		"CAMERA_FAST":
			speed = 5.0
		"CAMERA_SLOW":
			speed = 1.0
		"CAMERA_NORMAL":
			speed = 2.0
	
	#var movement_tween := create_tween()
	for node in _destinations:
		if node == null:
			print("Camera: node is invalid. ", node, " - ", _destinations)
			continue
		else:
			is_moving = true
			destination = node.position
			await destination_reached

	return

func _process(delta: float) -> void:
	if is_moving:
		position = position.move_toward(destination, (speed * 100) * delta)
		if position.is_equal_approx(destination):
			is_moving = false
			destination_reached.emit()
