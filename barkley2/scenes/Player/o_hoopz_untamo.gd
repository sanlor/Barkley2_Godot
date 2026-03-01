extends B2_Player_FreeRoam

const O_HOOPZ_UNTAMO_LAGGED = preload("uid://d145x83ed3s1r")

@onready var lag_timer: Timer = $lag_timer

func _lag_hoopz() -> void:
	if not is_node_ready():
		return
		
	# Setup main body lag timer
	var lag_time := randf()
	lag_timer.start( lag_time )
	
	## Add a copy of hoopz sprite, simulating a lag.
	var lagged_hoopz : AnimatedSprite2D = O_HOOPZ_UNTAMO_LAGGED.instantiate()
	lagged_hoopz.centered			= hoopz_normal_body.centered
	lagged_hoopz.flip_h				= hoopz_normal_body.flip_h
	lagged_hoopz.sprite_frames 		= hoopz_normal_body.sprite_frames
	lagged_hoopz.animation 			= hoopz_normal_body.animation
	lagged_hoopz.offset 			= hoopz_normal_body.offset
	lagged_hoopz.frame 				= hoopz_normal_body.frame
	lagged_hoopz.global_position 	= global_position
	add_sibling( lagged_hoopz, true )
	lagged_hoopz.set_timer( lag_time ) # Set timer only after node is ready.
	
	# Hide main body
	hide()

func _physics_process(delta: float) -> void:
	super(delta)
	if randf() >= 0.995:
		if lag_timer.is_stopped():
			_lag_hoopz()

# Lag over, show the main body. The lag 'shadow' should be removed at the same time.
func _on_lag_timer_timeout() -> void:
	show()
