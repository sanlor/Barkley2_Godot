@tool
extends PointLight2D

@onready var timer: Timer = $Timer
var t := 0.0
var s := 2.5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	s = randf_range(2.0,3.0)
	_on_timer_timeout()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	t += randf_range(0.9,1.1) * s * delta
	rotation = 0.5 * -PI + sin(t) * 0.45

func _on_timer_timeout() -> void:
	timer.start( randf_range(1.0,5.0) )
	var tt := create_tween()
	tt.tween_property(self, "color", Color(randf(),randf(),randf()), 1.0 )
