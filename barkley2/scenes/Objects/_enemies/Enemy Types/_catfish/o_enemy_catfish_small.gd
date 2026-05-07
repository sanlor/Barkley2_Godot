@icon("res://barkley2/assets/b2_original/images/merged/s_catfish_head.png")
extends B2_EnemyCombatActor
class_name B2_Enemy_CatFish

## Check o_enemygroup_catfish
## Parent class for all Catfish enemies, since they all behave in a similar way.

const O_ENEMY_ATTACK_BLOWDART = preload("uid://bqoqnwresdv00")

@onready var actor_blood_spill: 			GPUParticles2D = $ActorBloodSpill

func _ready() -> void:
	super()

func _ai_ranged_attack( enabled : bool ) -> void:
	if enabled:
		if curr_STATE == STATE.NORMAL:
			_begin_attack()
			
	
func _ai_jump( enabled : bool ) -> void:
	if enabled:
		if curr_STATE == STATE.NORMAL:
			cinema_jump( curr_input * 200.0 ) ## Debug direction

func _shoot_dart() -> void:
	var dart := O_ENEMY_ATTACK_BLOWDART.instantiate()
	#dart.set_direction( curr_aim, 3.0 )
	if B2_CManager.o_hoopz:		dart.set_target( B2_CManager.o_hoopz.global_position + Vector2(0,-4) )
	else:						dart.set_target( get_global_mouse_position() ); push_error("ERROR: No hoopz to target")
	play_temp_local_sound("catfishsmall_shoot")
	dart.my_shooter = self
	dart.global_position = get_aim_origin()
	dart.global_position += curr_aim * 12.0 # small offset to avoid creating the arrow on the enemy's center
	add_sibling( dart, true )

func _begin_attack() -> void:
	if not animation_attack:
		push_error("Attack animation not set.")
	curr_STATE = STATE.AIM
	
	ActorAnim.animation = "catfish_shot_attack"
	ActorAnim.flip_h = curr_aim.x < 0.0
	if roundf(curr_aim.y) < 0.0: # needs to be rounded, or else it will flip all the time.
		ActorAnim.animation = "catfish_shot_attack_up"
		ActorAnim.flip_h = not ActorAnim.flip_h
	
	ActorAnim.stop()
	ActorAnim.frame = 0 ## Reset frame count
	var attack_tween := create_tween()
	attack_tween.tween_property( ActorAnim, "frame", 5, 0.25 )
	attack_tween.tween_interval( 0.35 )
	attack_tween.tween_callback( _shoot_dart )
	attack_tween.tween_callback( play_temp_local_sound.bind( "catfishsmall_attack") )
	#attack_tween.tween_interval( 0.15 )
	attack_tween.tween_property( ActorAnim, "frame", 7, 0.15 )
	attack_tween.tween_interval( 0.15 )
	attack_tween.tween_callback( _finish_attack )
	
func _finish_attack() -> void:
	finished_attack_action.emit()
	last_input = Vector2.INF
	curr_STATE = STATE.NORMAL

func _before_death() -> void:
	if my_shadow:
		my_shadow.hide()
	actor_blood_spill.emitting = true
	set_physics_process( false ) # Also stops the AI.

## DEBUG jump
func cinema_jump( jump_offset := Vector2.ZERO ) -> void:
	if jump_tween: jump_tween.kill()
	jump_tween = create_tween()
	jump_tween.tween_callback( set.bind("curr_STATE", STATE.JUMP) )
	jump_tween.tween_callback( set.bind("jump_target", position + jump_offset) )
	jump_tween.tween_callback( ActorAnim.set_animation.bind( animation_jump ) )
	jump_tween.tween_callback( ActorAnim.play )
	jump_tween.tween_property( ActorAnim, "position:y", -jump_height, jump_speed ).set_trans(		Tween.TRANS_SINE)
	jump_tween.tween_property( ActorAnim, "position:y", 0.0, jump_speed ).set_trans(				Tween.TRANS_SINE)
	jump_tween.tween_callback( set.bind("curr_STATE", STATE.NORMAL) )
	jump_tween.tween_callback( set.bind("last_input", Vector2.INF) )					## Reset last input (For animations)

func get_aim_origin() -> Vector2:
	return global_position + Vector2(0,-12)

func _physics_process(delta: float) -> void:
	## Makers the AI think.
	if actor_ai:
		actor_ai.step()
		
	match curr_STATE:
		STATE.JUMP:
			velocity = position.direction_to( jump_target ) * position.distance_squared_to( jump_target ) * 10.0
			apply_central_force( velocity / Engine.time_scale )
			
		STATE.NORMAL:
			normal_animation(delta)
			var move := curr_input # Take the input from the keyboard / Gamepag and apply directly.
			velocity = ( walk_speed * delta ) * move
			
			velocity += external_velocity
			external_velocity = Vector2.ZERO # Reset Ext velocity
			apply_central_force( velocity / Engine.time_scale )

func _on_actor_anim_frame_changed() -> void:
	if ActorAnim.animation.begins_with("catfish_walk"):
		if ActorAnim.frame in [1,3]:
			## Play step sound
			play_local_sound( "hoopz_puddlestep" )
			
	if ActorAnim.animation == animation_attack:
		if ActorAnim.frame == 5:
			## Play Attack sound
			#play_local_sound( "catfishsmall_attack")
			pass
			
