@icon("res://barkley2/assets/b2_original/images/merged/s_catfish_head.png")
extends B2_EnemyCombatActor
class_name B2_Enemy_CatFish

## Check o_enemygroup_catfish
## Parent class for all Catfish enemies, since they all behave in a similar way.

@onready var actor_blood_spill: GPUParticles2D = $ActorBloodSpill

func _ready() -> void:
	assert( is_instance_valid(actor_ai), "No valid AI found." )
	actor_ai.actor = self
	_connect_ai_signals()

func _ai_ranged_attack( enabled : bool ) -> void:
	if enabled:
		if curr_STATE == STATE.NORMAL:
			if not animation_attack:
				push_error("Attack animation not set.")
			curr_STATE = STATE.AIM
			ActorAnim.animation = animation_attack
			ActorAnim.sprite_frames.set_animation_loop( animation_attack, false )
			await ActorAnim.animation_finished
			curr_STATE = STATE.NORMAL
	
func _ai_jump( enabled : bool ) -> void:
	if enabled:
		if curr_STATE == STATE.NORMAL:
			cinema_jump( curr_input * 200.0 ) ## Debug direction

func _before_death() -> void:
	actor_blood_spill.emitting = true

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

## Handle the most basic animations
func normal_animation(_delta : float):
	var input := curr_input
	
	if input != Vector2.ZERO: # AI is moving the Actor
		if last_input != input:
			## Flip sprite if needed.
			ActorAnim.flip_h = input.x < 0 ## If going left, flip the sprite
			if input.y < 0:
				# If going up, toggle the sprite flip. This is because of how the sprites were created. Check the ActorAnim node.
				ActorAnim.flip_h = not ActorAnim.flip_h
			
			match input.round():
				Vector2.UP + Vector2.LEFT:			ActorAnim.play( actor_animations.ANIMATION_NORTHWEST )
				Vector2.UP + Vector2.RIGHT:			ActorAnim.play( actor_animations.ANIMATION_NORTHEAST )
				Vector2.DOWN + Vector2.LEFT:		ActorAnim.play( actor_animations.ANIMATION_SOUTHWEST )
				Vector2.DOWN + Vector2.RIGHT:		ActorAnim.play( actor_animations.ANIMATION_SOUTHEAST )
					
				Vector2.UP:							ActorAnim.play( actor_animations.ANIMATION_NORTH )
				Vector2.LEFT:						ActorAnim.play( actor_animations.ANIMATION_WEST )
				Vector2.DOWN:						ActorAnim.play( actor_animations.ANIMATION_SOUTH )
				Vector2.RIGHT:						ActorAnim.play( actor_animations.ANIMATION_EAST )
					
				_: # Catch All
					print("Catch all, ", input)
	else:
		# AI is not moving the actor anymore
		ActorAnim.play( actor_animations.ANIMATION_STAND )
		
		var curr_direction : Vector2 = input
	
		# Update var
		last_direction = curr_direction
		
	# Update var
	last_input = input

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
			
			# Take the input from the keyboard / Gamepag and apply directly.
			var move := curr_input
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
			play_local_sound( "catfishsmall_attack")
			
