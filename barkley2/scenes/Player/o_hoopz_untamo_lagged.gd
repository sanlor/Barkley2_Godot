extends AnimatedSprite2D

@onready var lag_timer: Timer = $lifetime

func set_timer( time : float ) -> void:
	lag_timer.start( time )

func _on_lifetime_timeout() -> void:
	queue_free()

func _physics_process(_delta: float) -> void:
	modulate.a = randf_range(0.75,1.0)
