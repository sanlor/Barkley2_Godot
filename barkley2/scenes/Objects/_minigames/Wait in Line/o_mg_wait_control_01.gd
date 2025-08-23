extends Marker2D

@onready var clock_timer: Timer = $clock_timer
@onready var line_timer: Timer = $line_timer

@export var o_mg_wait_clock : B2_Environ

func _ready() -> void:
	clock_timer.start( 1.0 )

func _clock_timer_timeout() -> void:
	B2_Sound.play("sn_mg_wait_clock01")
	if randf() > 0.85:
		clock_timer.start( 1.0 + randf() )
	else:
		clock_timer.start( 1.0 )
