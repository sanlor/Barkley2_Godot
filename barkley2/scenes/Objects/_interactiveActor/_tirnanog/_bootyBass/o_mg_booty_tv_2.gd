extends AnimatedSprite2D

@onready var point_light_2d: PointLight2D = $PointLight2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	## Weird connection issues.
	if not animation_finished.is_connected(_on_animation_finished):
		animation_finished.connect( _on_animation_finished )
		
	speed_scale = randf_range(0.75,1.25)
	play("default")

func _on_animation_finished() -> void:
	if randf() < 0.95:
		play("default")
		point_light_2d.energy = 0.25
	else:
		play("flash")
		point_light_2d.energy = 1.00
