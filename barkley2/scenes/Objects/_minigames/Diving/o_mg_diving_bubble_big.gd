extends Area2D

@onready var s_mg_diving_bubble_big: AnimatedSprite2D = $s_mg_diving_bubble_big
@onready var pop_timer: Timer = $Timer

var dir			:= Vector2.UP
var popping := false
var t := 0.0

func _ready() -> void:
	s_mg_diving_bubble_big.speed_scale = randf_range(0.3,1.2)
	
func pop() -> void:
	popping = true
	s_mg_diving_bubble_big.play("pop")
	await s_mg_diving_bubble_big.animation_finished
	queue_free()
	
func _physics_process(delta: float) -> void:
	position -= dir * 8.0 * delta
	s_mg_diving_bubble_big.offset.x = sin(t) * 5.0
	t += 3.0 * delta
	
	if not popping:
		for body in get_overlapping_bodies():
			if body.name == "o_mg_diving_player":
				if not s_mg_diving_bubble_big.is_playing(): ## Only gulp if the animation is finished
					body.refill_air()
					pop()

func _on_timer_timeout() -> void:
	pop()
