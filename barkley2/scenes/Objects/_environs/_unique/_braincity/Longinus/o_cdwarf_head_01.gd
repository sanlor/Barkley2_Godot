extends B2_EnvironInteractive


var t := 0.0

func _ready() -> void:
	modulate.a = 0.0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	offset.y = sin( t ) * 5.0
	t += 1.0 * delta
