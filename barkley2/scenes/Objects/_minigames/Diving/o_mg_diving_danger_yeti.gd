extends Area2D

@onready var detection_area: Area2D = $detection_area
@onready var s_mg_diving_water_yeti: AnimatedSprite2D = $s_mg_diving_water_yeti

var target 		: RigidBody2D
var speed		:= Vector2.ZERO
var is_active 	:= false

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	if is_active:
		speed = speed.move_toward( position.direction_to(target.position) * 1.25, 1.75 * delta )
		s_mg_diving_water_yeti.flip_h = speed.x < 0
		position += speed

		for body in get_overlapping_bodies():
			if body.name == "o_mg_diving_player":
				body.hurt()
				body.apply_central_impulse( global_position.direction_to(body.global_position) * 5000.0 )

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.name == "o_mg_diving_player":
		is_active = true
		target = body
