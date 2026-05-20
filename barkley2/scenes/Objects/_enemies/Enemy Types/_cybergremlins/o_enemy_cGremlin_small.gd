@icon("uid://clq6vos2qs815")
extends B2_EnemyCombatActor
class_name B2_Enemy_CGremlin
## Funky little guys. They seem to use random body pieces. What. A. Chore.

@onready var actor_anim_head: 		AnimatedSprite2D = $ActorAnimHead
@onready var actor_anim_weapon: 	AnimatedSprite2D = $ActorAnimWeapon
@onready var actor_anim_arm_r: 		AnimatedSprite2D = $ActorAnimArmR
@onready var actor_anim_body: 		AnimatedSprite2D = $ActorAnimBody
@onready var actor_anim_atk_arm: 	AnimatedSprite2D = $ActorAnimAtkArm
@onready var actor_anim_arm_l: 		AnimatedSprite2D = $ActorAnimArmL


func _physics_process(delta: float) -> void:
	## Makers the AI think.
	if actor_ai:
		actor_ai.step()
		
	match curr_STATE:
		STATE.JUMP:
			velocity = position.direction_to( jump_target ) * position.distance_squared_to( jump_target ) * 10.0
			apply_central_force( velocity / Engine.time_scale )
			
		STATE.WADING:			pass
		STATE.HIT:				pass
		STATE.NORMAL:
			_normal_animation(delta)
			var move := curr_input # Take the input from the keyboard / Gamepag and apply directly.
			velocity = ( walk_speed * delta ) * move
			
			velocity += external_velocity
			external_velocity = Vector2.ZERO # Reset Ext velocity
			apply_central_force( velocity / Engine.time_scale )
