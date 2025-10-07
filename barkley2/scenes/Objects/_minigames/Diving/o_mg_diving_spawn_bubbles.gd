extends GPUParticles2D

const O_MG_DIVING_BUBBLE_BIG = preload("uid://jlolk2pxejh6")

@onready var detection_area: Area2D = $detection_area
@onready var timer: Timer = $Timer

func _ready() -> void:
	timer.start( randf_range(1,8) )

## Spawn big bubble
func _on_timer_timeout() -> void:
	timer.start( randf_range(2,5) )
	for body in detection_area.get_overlapping_bodies():
		if body.name == "o_mg_diving_player":
			var bubble := O_MG_DIVING_BUBBLE_BIG.instantiate()
			bubble.global_position = global_position
			bubble.dir = Vector2.DOWN.rotated( rotation )
			add_sibling.call_deferred(bubble, true)
