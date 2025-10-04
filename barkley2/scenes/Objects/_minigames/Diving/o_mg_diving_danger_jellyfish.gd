extends Area2D

const SPEED 	:= 0.5
const GRAVITY 	:= 0.05

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var s_mg_diving_jellyfish: AnimatedSprite2D = $s_mg_diving_jellyfish

var falling := true
var speed := Vector2.ZERO
var tween : Tween

func _physics_process(delta: float) -> void:
	for body in get_overlapping_bodies():
		if body is TileMapLayer:
			if falling and speed.y > SPEED/2:
				falling = false
				speed = Vector2.ZERO
				s_mg_diving_jellyfish.play("default")
			elif not falling and speed.y < -SPEED/2:
				falling = true
				speed = Vector2.ZERO
				s_mg_diving_jellyfish.play("fall")
		
		if body is RigidBody2D:
			if body.name == "o_mg_diving_player":
				body.hurt()
				body.apply_central_impulse( global_position.direction_to(body.global_position) * 10000.0 )
				
	for body in get_overlapping_areas():
		if body.name == "o_mg_diving_danger_explosion":
			queue_free()
			
	if falling:
		speed.y += SPEED * delta * 0.75
	else:
		speed.y -= SPEED * delta
		
	speed.y = clampf(speed.y,-SPEED,SPEED)
	position += speed


func _on_timer_timeout() -> void:
	if not falling:
		s_mg_diving_jellyfish.flip_h = not s_mg_diving_jellyfish.flip_h
		tween = create_tween()
		var dest := 4.0
		if s_mg_diving_jellyfish.flip_h: dest *= -1.0
		tween.tween_property(s_mg_diving_jellyfish, "offset:x", -dest, 0.5 )
