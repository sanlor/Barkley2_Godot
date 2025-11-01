extends B2_EnemyCombatActor
class_name B2_Enemy_EnemyRat

## Check o_enemygroup_rat. Some rat types can explode.
# https://youtu.be/SQKRnzWSW0M?t=12323

@export var rat_explosion_radius		:= 32.0
@onready var actor_blood_spill: GPUParticles2D = $ActorBloodSpill
var exploding := false


func _ready() -> void:
	super()
	assert( is_instance_valid(actor_ai), "No valid AI found." )
	assert( enemy_data, "No enemy data ")
	enemy_data.resource_local_to_scene = true
	actor_ai.actor = self
	_connect_ai_signals()

func _ai_ranged_attack( enabled : bool ) -> void:
	if enabled:
		if curr_STATE == STATE.NORMAL:
			_begin_attack()

func _begin_attack() -> void:
	if exploding:
		return
	
	exploding = true
	var attack_tween := create_tween()
	attack_tween.tween_property( ActorAnim, "modulate", Color.WHITE * 5.0, 0.5 )
	attack_tween.tween_callback( destroy_actor )
	attack_tween.tween_callback( play_temp_local_sound.bind( "catfishsmall_attack") )
	attack_tween.tween_callback( _finish_attack )
	

	
func _finish_attack() -> void:
	destroy_actor()
	var damage := randf_range(1.0,10.0)
	#scr_stats_setBaseStat(self, STAT_BASE_HP, 0.01);
	#scr_stats_setBaseStat(self, STAT_BASE_GUTS, 0.01);
	#scr_stats_genEffectiveStats();
	#scr_stats_resetCurrentStats();
	
	#body.damage_actor( damage, position.direction_to(body.position) * 50.0 * damage )
	if B2_CManager.o_hoopz: 
		if global_position.distance_to(B2_CManager.o_hoopz.global_position) < rat_explosion_radius:
			B2_CManager.o_hoopz.damage_actor( damage, position.direction_to(B2_CManager.o_hoopz.position) * 50.0 * damage )
	push_error("DEBUG: Weird RATO damage. FIXME")
	finished_attack_action.emit()

#func _ai_ranged_attack( enabled : bool ) -> void:
	#if enabled:
		#if curr_STATE == STATE.NORMAL:
			#if not animation_attack:
				#push_error("Attack animation not set.")
				#return
			#curr_STATE = STATE.AIM
			#ActorAnim.animation = animation_attack
			#ActorAnim.sprite_frames.set_animation_loop( animation_attack, false )
			#await ActorAnim.animation_finished
			#curr_STATE = STATE.NORMAL
	
func _ai_jump( enabled : bool ) -> void:
	if enabled:
		if curr_STATE == STATE.NORMAL:
			cinema_jump( curr_input * 200.0 ) ## Debug direction

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
			ActorAnim.flip_h = input.x < 0 ## If going left, flip the spritesd
			
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
		if last_input != input:
			# AI is not moving the actor anymore
			ActorAnim.animation = actor_animations.ANIMATION_STAND
			ActorAnim.stop()
			
			# change the animation itself.
			match last_input.round():
				Vector2.UP + Vector2.LEFT:			ActorAnim.frame = actor_animations.ANIMATION_STAND_SPRITE_INDEX[3]
				Vector2.UP + Vector2.RIGHT:			ActorAnim.frame = actor_animations.ANIMATION_STAND_SPRITE_INDEX[5]
				Vector2.DOWN + Vector2.LEFT:		ActorAnim.frame = actor_animations.ANIMATION_STAND_SPRITE_INDEX[7]
				Vector2.DOWN + Vector2.RIGHT:		ActorAnim.frame = actor_animations.ANIMATION_STAND_SPRITE_INDEX[1]
					
				Vector2.UP:			ActorAnim.frame = actor_animations.ANIMATION_STAND_SPRITE_INDEX[4]
				Vector2.LEFT:		ActorAnim.frame = actor_animations.ANIMATION_STAND_SPRITE_INDEX[6]
				Vector2.DOWN:		ActorAnim.frame = actor_animations.ANIMATION_STAND_SPRITE_INDEX[0]
				Vector2.RIGHT:		ActorAnim.frame = actor_animations.ANIMATION_STAND_SPRITE_INDEX[2]
					
				_: # Catch All
					#ActorAnim.frame = actor_animations.ANIMATION_STAND_SPRITE_INDEX[0]
					pass
		
		var curr_direction : Vector2 = input
	
		# Update var
		last_direction = curr_direction
		
	# Update var
	last_input = input

## Special gibs for rats
func spawn_gibs() -> void:
	const O_GIBS = preload("res://barkley2/scenes/Objects/_enemies/o_gibs.tscn")
	## Make head bone.
	var gib_head = O_GIBS.instantiate()
	gib_head.global_position = global_position + Vector2( randf_range(-16,16), randf_range(-16,16) )
	gib_head.splatSound = splatSound
	gib_head.bloodburst = bloodburst
	add_sibling( gib_head, true )
	gib_head.force_sprite( gib_sprite )
	gib_head.force_frame( 1 )
	
	## Make body bones.
	for i in randi_range(2,4):
		var gib_bone = O_GIBS.instantiate()
		gib_bone.global_position = global_position + Vector2( randf_range(-16,16), randf_range(-16,16) )
		gib_bone.gib_sprite = gib_sprite
		gib_bone.splatSound = splatSound
		gib_bone.bloodburst = bloodburst
		add_sibling( gib_bone, true )
		gib_bone.force_sprite( gib_sprite )
		gib_bone.force_frame( 0 )

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
			
			if not get_colliding_bodies().is_empty():
				for body in get_colliding_bodies():
					_on_body_entered( body )

func _on_body_entered( body : Node ) -> void:
	## Check scr_AI_action_kamikaze
	if body is B2_PlayerCombatActor:
		## Do not explode if player is rolling.
		if body.can_be_damaged():
			_ai_ranged_attack(true)

func _before_death() -> void:
	actor_blood_spill.emitting = true
