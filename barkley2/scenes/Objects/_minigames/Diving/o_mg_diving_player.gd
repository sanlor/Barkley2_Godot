extends RigidBody2D

@onready var flashlight: PointLight2D = $flashlight
@onready var actor_anim: AnimatedSprite2D = $ActorAnim

var speed := 10000.0
var prev_input := Vector2.ZERO

func _physics_process(_delta: float) -> void:
	flashlight.look_at( get_global_mouse_position() )
	
	var my_input := Input.get_vector("Left","Right","Up","Down")
	
	if my_input.round() != prev_input:
		actor_anim.flip_h = my_input.x < 0
		
		if my_input.y < 0:
			actor_anim.play("swim_up")
		elif my_input.y > 0:
			actor_anim.play("swim_down")
		else:
			if my_input == Vector2.ZERO:
				actor_anim.pause()
			else:
				actor_anim.play()
		prev_input = my_input.round()
	
	apply_central_force( my_input * speed )
	
	if my_input and Input.is_action_just_pressed("Roll"):
		apply_central_impulse( my_input * speed )
