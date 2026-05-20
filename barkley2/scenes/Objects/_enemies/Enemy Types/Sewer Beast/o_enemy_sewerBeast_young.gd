extends B2_EnemyCombatActor
class_name B2_Enemy_SewerBeast

var is_wading := false

const O_SPLASH:													= preload("uid://dgxwfaoi5p3x1")
const O_ENEMY_ATTACK_BULLET_OOZE_SPIT 							= preload("uid://c36knm16d25gp")

@onready var ai_wading: 				B2_AI_Wading 			= $B2_AI_Wading
@onready var ai_sewer_beast_young: 		B2_AI_SewerBeast_Young 	= $B2_AI_SewerBeast_Young

@onready var ActorAnimLower: 			AnimatedSprite2D 		= $ActorAnimLower
@onready var actor_blood_spill: 		GPUParticles2D 			= $ActorBloodSpill

func _ready() -> void:
	super()
	ready.connect( _to_wade_or_not_to_wade ) # <- this is the question.
	
func _to_wade_or_not_to_wade() -> void:
	if not check_for_water():
		actor_ai = ai_wading
		curr_STATE = STATE.WADING
		ActorAnim.play( "water" )
		my_shadow.hide()
	else:
		actor_ai = ai_sewer_beast_young
		my_shadow.show()
		curr_STATE = B2_CombatActor.STATE.NORMAL
	

func _ai_ranged_attack( enabled : bool ) -> void:
	if enabled:
		if curr_STATE == STATE.NORMAL:
			_begin_attack()
			
## Special gibbing
func spawn_gibs() -> void:
	const O_GIBS = preload("res://barkley2/scenes/Objects/_enemies/o_gibs.tscn")
	
	var gimme_gibs := func() -> B2_Gibs:
		var gib : B2_Gibs = O_GIBS.instantiate()
		gib.global_position = global_position + Vector2( randf_range(-16,16), randf_range(-16,16) )
		gib.gib_sprite = gib_sprite
		gib.splatSound = splatSound
		gib.bloodburst = bloodburst
		gib.enable_bloodburst = true
		return gib
	
	var head_gib : B2_Gibs = gimme_gibs.call()
	head_gib.gib_sprite = "s_sewerBeast_young"
	head_gib.sprite_frame = randi_range(0,5)
	add_sibling( head_gib, true )
	
	for i in randi_range(2,8) + 2:
		var gib : B2_Gibs = gimme_gibs.call()
		gib.gib_sprite = "s_catfish_gibs"
		gib.sprite_frame = [0,1,3,4,8,11,10].pick_random()
		add_sibling( gib, true )
		for p in randf_range(0,10): ## add some random delays
			await get_tree().process_frame
	
func _ai_jump( enabled : bool ) -> void:
	if enabled:
		if curr_STATE == STATE.NORMAL:
			cinema_jump( curr_input * 200.0 ) ## Debug direction

func _shoot_projectile() -> void:
	var proj : Node2D = O_ENEMY_ATTACK_BULLET_OOZE_SPIT.instantiate()
	
	## TODO vvvv
	if B2_CManager.o_hoopz:		proj.set_target( B2_CManager.o_hoopz.global_position + Vector2(0,-4) )
	else:						proj.set_target( get_global_mouse_position() ); push_error("ERROR: No hoopz to target")
	#play_temp_local_sound("catfishsmall_shoot")
	proj.my_shooter = self
	proj.global_position = get_aim_origin()
	proj.global_position += curr_aim * 12.0 # small offset to avoid creating the arrow on the enemy's center
	add_sibling( proj, true )

func _begin_attack() -> void:
	if not animation_attack:
		push_error("Attack animation not set.")
	curr_STATE = STATE.AIM
	
	ActorAnim.animation = "beast_shoot"
	ActorAnim.flip_h = curr_aim.x < 0.0
	if roundf(curr_aim.y) < 0.0: # needs to be rounded, or else it will flip all the time.
		ActorAnim.animation = "beast_shoot_up"
		ActorAnim.flip_h = not ActorAnim.flip_h
	
	ActorAnim.stop()
	ActorAnim.frame = 0 ## Reset frame count
	var attack_tween := create_tween()
	attack_tween.tween_property( ActorAnim, "frame", 5, 0.25 )
	attack_tween.tween_interval( 0.35 )
	attack_tween.tween_callback( _shoot_projectile )
	attack_tween.tween_callback( play_temp_local_sound.bind( "sewerbeastJr_spit") )
	#attack_tween.tween_interval( 0.15 )
	attack_tween.tween_property( ActorAnim, "frame", 7, 0.15 )
	attack_tween.tween_interval( 0.15 )
	attack_tween.tween_callback( _finish_attack )
	
func _finish_attack() -> void:
	finished_attack_action.emit()
	last_input = Vector2.INF
	curr_STATE = STATE.NORMAL

func _before_death() -> void:
	actor_blood_spill.emitting = true
	if my_shadow: my_shadow.hide()
	set_physics_process( false ) # Also stops the AI.
	if randf() > 0.85:
		ActorAnimLower.animation = "hurt"
	else:
		ActorAnimLower.hide()
	
func damage_actor( damage : float, force : Vector2 ) -> void:
	if curr_STATE == STATE.WADING:
		return
	else:
		super(damage, force)

func _after_damage():
	if not actor_is_dying:
		var t := create_tween()
		t.tween_callback( ActorAnimLower.set_animation.bind("beast_hurt") )
		t.tween_interval(0.5)

func get_aim_origin() -> Vector2:
	return global_position + Vector2(0,-12)

func _normal_animation(delta) -> void:
	## Do normal animation stuff
	super(delta)
	
	## Do lower sprite animation
	flip_sprite( velocity.normalized(), ActorAnimLower )
	if velocity.normalized().y < 0:	ActorAnimLower.play("beast_wiggle_up")
	else:							ActorAnimLower.play("beast_wiggle")
		
	var anim_speed : float = linear_velocity.length_squared() / 3000.0
	ActorAnimLower.speed_scale = max( 0.35, anim_speed )
	#print( linear_velocity.length_squared() )

func _physics_process(delta: float) -> void:
	## Makers the AI think.
	if actor_ai:
		actor_ai.step()
		
	match curr_STATE:
		STATE.JUMP:
			velocity = position.direction_to( jump_target ) * position.distance_squared_to( jump_target ) * 10.0
			apply_central_force( velocity / Engine.time_scale )
			
		STATE.WADING:
			pass
			
		STATE.HIT:
			pass
			
		STATE.NORMAL:
			_normal_animation(delta)
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
