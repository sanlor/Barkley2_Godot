extends PointLight2D

@export var energy_variation := 0.2

func _ready() -> void:
	energy += randf_range( -energy_variation, energy_variation)
