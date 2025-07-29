extends AnimatedSprite2D

@onready var wall_light: PointLight2D = $wall_light

func _ready() -> void:
	_on()
	
func _on() -> void:
	frame = 1
	wall_light.enabled = true
	
func _off() -> void:
	frame = 2
	wall_light.enabled = false

func _physics_process(_delta: float) -> void:
	if frame == 1:
		if randf() > 0.975:
			_off()
	else:
		if randf() > 0.85:
			_on()
