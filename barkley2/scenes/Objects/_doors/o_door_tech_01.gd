extends B2_DOOR_PARENT

@export var is_open := false

@onready var sensor_shape: CollisionShape2D = $door_sensor/sensor_shape

func _ready() -> void:
	_door_setup()
	
	if is_open:
		_door_open( true )
		door_block.get_child( 0 ).disabled = true
	else:
		_door_close( true )
		door_block.get_child( 0 ).disabled = false
		
	
	if locked:
		door_sensor.get_child( 0 ).disabled = true
	else:
		door_sensor.body_entered.connect( detect_player_enter )
		door_sensor.body_exited.connect( detect_player_exit )

func detect_player_exit( body ):
	if locked:
		return
	if body is B2_Player:
		_door_close()

func detect_player_enter( body ):
	if locked:
		return
	if body is B2_Player:
		_door_open()
		
