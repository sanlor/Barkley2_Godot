@icon("uid://b0u5bv6vahxul")
extends B2_EnemyCombatActor
class_name B2_Enemy_EggDrone

func _ready() -> void:
	super()

func _physics_process(delta: float) -> void:
	## Makers the AI think.
	if actor_ai:
		actor_ai.step()
		
	match curr_STATE:
		STATE.JUMP:
			pass
			
		STATE.NORMAL:
			normal_animation(delta)
			var move := curr_input # Take the input from the keyboard / Gamepag and apply directly.
			velocity = ( walk_speed * delta ) * move
			
			velocity += external_velocity
			external_velocity = Vector2.ZERO # Reset Ext velocity
			apply_central_force( velocity / Engine.time_scale )
