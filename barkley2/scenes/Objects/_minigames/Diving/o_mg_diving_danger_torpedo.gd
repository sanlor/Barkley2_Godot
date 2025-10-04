extends Area2D

const O_MG_DIVING_DANGER_EXPLOSION = preload("uid://s7vkb38vjeab")

@onready var timer: Timer = $Timer
@onready var s_mg_diving_torpedo: AnimatedSprite2D = $s_mg_diving_torpedo

var target 		: RigidBody2D
var speed		:= Vector2.ZERO
var can_seek	:= false

func _ready() -> void:
	speed = Vector2.DOWN * 0.25

func _physics_process(delta: float) -> void:
	if can_seek:
		speed = speed.move_toward( position.direction_to(target.position) * 3.0, 0.75 * delta )
		s_mg_diving_torpedo.rotation = speed.angle()
		position += speed

		for body in get_overlapping_bodies():
			if body.name == "o_mg_diving_player":
				_explode()
			elif body is TileMapLayer:
				_explode()
	position += speed
			
func _explode() -> void:
	var expl := O_MG_DIVING_DANGER_EXPLOSION.instantiate()
	expl.global_position = global_position
	add_sibling.call_deferred( expl, true )
	queue_free()

func _on_timer_timeout() -> void:
	speed = position.direction_to(target.position) * 1.0
	can_seek = true
