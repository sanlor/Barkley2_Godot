@icon("res://barkley2/assets/b2_original/images/merged/icon_parent_3.png")
extends B2_CombatActor
class_name B2_EnemyCombatActor
## Base class for all Combat enemies o_enemy_drone_egg

const O_SHADOW 						= preload("uid://c54kloot7bcu2")
const O_EFFECT_EMOTEBUBBLE_EVENT 	= preload("res://barkley2/scenes/_event/Misc/o_effect_emotebubble_event.tscn")
const COMBAT_DEBUG_DATA 			= preload("uid://dst4q8st6lgtm")
const ENEMY_STATS 					= preload("uid://ip8ryvrniime")

## NOTICE https://www.youtube.com/watch?v=1gN0lWXyrz0
signal aim_target_changed
signal move_target_changed
signal finished_attack_action
signal finished_charge_action	## Actor is done with its charge/rush action.
signal enemy_was_defeated
signal enemy_was_damaged

## 07/05/26 Disabled all of this. It should not be used anymore.
#enum MODE{NONE,INACTIVE,COMBAT,AIMING,CHARGING,DEATH}			## TODO check if this is still used.
#@export var curr_MODE := MODE.INACTIVE							## TODO check if this is still used.
#var is_changing_states := false								## TODO check if this is still used.

@export_category("Enemy stuff")
#@export var my_nest					: Area2D
@export var show_life_bar				:= true			## During the tutorial, some stuff dont really need it.
@export var show_combat_debug_data		:= false
@export var damage_player_on_contact	:= false

@export_category("Actor Stuff")
@export var cast_shadow			:= true
@export var shadow_scale		:= 1.0

@export var ActorSmokeEmitter		: GPUParticles2D
@export var has_collision 		:= true
#@export var ActorCol 			: CollisionShape2D

var my_shadow 		: Sprite2D

## Movement and animation variables.
var playing_animation 			:= "stand"

@export_category("Animation")
#@export var animation_speed 			:= 1.5			## Multiplier used on playset animations
@export var actor_animations 			: B2_Actor_Animations
@export var animation_attack 			:= ""
@export var animation_jump 				:= ""
@export var animation_stagger 			:= ""

@export_category("Sounds")
@export var sound_alert			:= ""
@export var sound_damage		:= ""
@export var sound_death			:= ""
@export var sound_charge		:= ""

@export_category("Gibs / Death")
@export var make_gibs				:= true							## Create a bunch of gibs during death.
@export var gib_sprite 				:= "s_enemyDeath_parts"			## Sprite used for gibs
@export var splatSound 				:= "junkbot_death_partclink"	## Sound used for Gib bounce
@export var bloodburst 				:= ""							## WARNING Don't know yet
@export var explode_on_death		:= true							## Create random explosions
@export var stay_after_death		:= false						## fade Enemy out of existance or let ir stay on this mortal coil?
@export var death_animation			:= ""							## What animation should be player at death.

@export_category("Enemy Stats")
@export var enemy_name				:= ""
#@export_tool_button("Fetch Enemy Data") var fetch_enemy_data = _fetch_enemy_data
@export var enemy_data				: B2_EnemyData

## Control stuff
var move_target 	:= Vector2.INF ## Cinema stuff: Tells where the node should walk to.
var aim_target 		:= Vector2.INF ## Cinema stuff: Tells where the node should aim to. Can be used with "move_target" to move and aim at the same time.
var charge_target	:= Vector2.ZERO ## Combat stuff: Tells where the enemy should charge torward
var charge_speed	:= 0.0
var charge_stopping := false

var hit_tween	: Tween

func _fetch_enemy_data() -> void:
	enemy_data = B2_EnemyData.new()
	enemy_data.apply_stats( enemy_name )
	enemy_data.resource_local_to_scene = true

func _ready() -> void:
	_setup_enemy()
	_setup_ai()
	
func _setup_ai() -> void:
	## AI Setup
	assert( is_instance_valid(actor_ai), "No valid AI found for actor '%s'." % name )
	assert( enemy_data, "No enemy data for actor '%s'." % name)
	if randf() < 0.01: for i in randf_range(0,99): print("Fuck you!") ## CRITICAL NEVER remove this. Won't explain why.
	enemy_data.resource_local_to_scene = true
	actor_ai.actor = self
	_connect_ai_signals()
	
func _setup_enemy() -> void:
	## Check for nodes not being set correctly
	if not is_instance_valid( ActorAnim ):				ActorAnim 			= get_node( "ActorAnim" )
	if not is_instance_valid( ActorCol ):				ActorCol 			= get_node( "ActorCol" )
	if not is_instance_valid( ActorAudioPlayer ):		ActorAudioPlayer 	= get_node( "ActorAudioPlayer" )
	if not is_instance_valid( ActorSmokeEmitter ):		ActorSmokeEmitter 	= get_node( "ActorSmokeEmitter" )
	if not is_instance_valid( ActorNav ):				ActorNav			= get_node( "ActorNav" )
	
	## Check for the animations resource
	if not actor_animations:						push_warning("Actor '%s' has no 'actor_animations' resource. Is this expected?" % name)
	
	## Setup navigation stuff
	if ActorNav:	ActorNav.velocity_computed.connect( _on_velocity_computed )
	else:			push_warning("No ActorNav for '%s'. Is this expected?" % name)
		
	## A.I.
	## Disabled this on 31/07/25 fix this later.
	## 07/05/26 Working on this right now.
	#if not disable_ai:
		#if not is_instance_valid( inactive_ai ):
			#push_error("%s: inactive_ai not set." % name)
		#else:
			#if my_nest:		inactive_ai.home_point = my_nest.global_position
			#else:			inactive_ai.home_point = global_position
			#inactive_ai.emote.connect( _emote )
			#
		#if not is_instance_valid( combat_ai ):
			#push_error("%s: combat_ai not set." % name)
		
	## Enable or disable shadows
	if cast_shadow:
		my_shadow = O_SHADOW.instantiate()
		my_shadow.scale *= shadow_scale
		add_child( my_shadow, true)
		
	## Setup enemy stats
	if enemy_name:
		if not enemy_data:
			enemy_data = B2_EnemyData.new()
			enemy_data.apply_stats( enemy_name )
			enemy_data.resource_local_to_scene = true
	
	## Debug stuff
	if show_combat_debug_data:
		add_child( COMBAT_DEBUG_DATA.instantiate(), true )
	
	## Duh.
	if show_life_bar:
		add_child( ENEMY_STATS.instantiate(), true )
	
	## Used for charging/dashing enemies
	if not contact_monitor:
		contact_monitor = true
		max_contacts_reported = 5
	
	## Avoid countless warnings.
	if not body_entered.is_connected( _on_body_entered ):
		## Connect signal do be able to charge at things.
		body_entered.connect( _on_body_entered )
	
	#enemy_ranged = B2_Gun.generate_gun( enemy_weapon_type, enemy_weapon_material )
	#set_mode( MODE.INACTIVE )
	
## Handle the most basic animations
func _normal_animation(_delta : float):
	if is_playingset: # Stop normal animations when a cinema_playset is playing.
		return
		
	var input 	:= curr_input
	var aim		:= curr_aim
	
	## Overide input with aim, it the actor is aiming at something.
	if curr_aim != Vector2.ZERO:
		input = curr_aim
	
	if input != Vector2.ZERO: # AI is moving the Actor
		if last_input != input:
			## Flip sprite if needed.
			flip_sprite( input )
			
			match input.round():
				Vector2.UP + Vector2.LEFT:			ActorAnim.play( actor_animations.ANIMATION_NORTHWEST )
				Vector2.UP + Vector2.RIGHT:			ActorAnim.play( actor_animations.ANIMATION_NORTHEAST )
				Vector2.DOWN + Vector2.LEFT:		ActorAnim.play( actor_animations.ANIMATION_SOUTHWEST )
				Vector2.DOWN + Vector2.RIGHT:		ActorAnim.play( actor_animations.ANIMATION_SOUTHEAST )
					
				Vector2.UP:							ActorAnim.play( actor_animations.ANIMATION_NORTH )
				Vector2.LEFT:						ActorAnim.play( actor_animations.ANIMATION_WEST )
				Vector2.DOWN:						ActorAnim.play( actor_animations.ANIMATION_SOUTH )
				Vector2.RIGHT:						ActorAnim.play( actor_animations.ANIMATION_EAST )
				Vector2.ZERO:						pass
				_: # Catch All
					print("Catch all 'input' for %s -> %s " % [name, input])
	else:
		# AI is not moving the actor anymore
		if actor_animations:
			ActorAnim.play( actor_animations.ANIMATION_STAND )
		
		var curr_direction : Vector2 = input
	
		# Update var
		last_direction = curr_direction
		
	# Update var
	last_input = input
	
func _emote( type : String ) -> void:
	var emote = O_EFFECT_EMOTEBUBBLE_EVENT.instantiate()
	emote.type = "!"
	emote.position  = position + Vector2( 0, -20 )
	add_sibling( emote )

## 06/05/26 Disabled this
#func _animations() -> void:
	#if is_instance_valid( actor_animations ):
		#if is_moving:
			#var _dir := "default"
					#
			#match movement_vector:
				#Vector2.UP + Vector2.LEFT: 		_dir = actor_animations.ANIMATION_NORTHWEST
				#Vector2.UP + Vector2.RIGHT: 	_dir = actor_animations.ANIMATION_NORTHEAST
				#Vector2.DOWN + Vector2.LEFT: 	_dir = actor_animations.ANIMATION_SOUTHWEST
				#Vector2.DOWN + Vector2.RIGHT: 	_dir = actor_animations.ANIMATION_SOUTHEAST
						#
				#Vector2.UP: 		_dir = actor_animations.ANIMATION_NORTH
				#Vector2.LEFT: 		_dir = actor_animations.ANIMATION_WEST
				#Vector2.DOWN: 		_dir = actor_animations.ANIMATION_SOUTH
				#Vector2.RIGHT: 		_dir = actor_animations.ANIMATION_EAST
			#
			#if playing_animation != _dir:
				#ActorAnim.play(_dir, animation_speed)
				#playing_animation = _dir
				#
		#else: ## is stopped
			#ActorAnim.stop()
			#ActorAnim.animation 	= actor_animations.ANIMATION_STAND
			#playing_animation 		= actor_animations.ANIMATION_STAND
			#
			#match movement_vector:
				#Vector2.UP + Vector2.LEFT: 		ActorAnim.frame = actor_animations.ANIMATION_STAND_SPRITE_INDEX[ 7 ]
				#Vector2.UP + Vector2.RIGHT: 	ActorAnim.frame = actor_animations.ANIMATION_STAND_SPRITE_INDEX[ 1 ]
				#Vector2.DOWN + Vector2.LEFT: 	ActorAnim.frame = actor_animations.ANIMATION_STAND_SPRITE_INDEX[ 5 ]
				#Vector2.DOWN + Vector2.RIGHT: 	ActorAnim.frame = actor_animations.ANIMATION_STAND_SPRITE_INDEX[ 3 ]
						#
				#Vector2.UP: 	ActorAnim.frame = actor_animations.ANIMATION_STAND_SPRITE_INDEX[ 0 ]
				#Vector2.LEFT: 	ActorAnim.frame = actor_animations.ANIMATION_STAND_SPRITE_INDEX[ 6 ]
				#Vector2.DOWN: 	ActorAnim.frame = actor_animations.ANIMATION_STAND_SPRITE_INDEX[ 4 ]
				#Vector2.RIGHT: 	ActorAnim.frame = actor_animations.ANIMATION_STAND_SPRITE_INDEX[ 2 ]
				#
		### Flip sprite, if necessary
		##if is_moving:
		#if movement_vector.x < 0:
			#ActorAnim.flip_h = true
		#else:
			#ActorAnim.flip_h = false
		
## DEPRECATED 06/05/26 Disabled THIS
#func get_ai_turnbased() -> B2_AI_Combat:
	#return actor_ai
		
func play_idle_anim() -> void:
	if not actor_animations.ANIMATION_IDLE.is_empty():
		ActorAnim.play( actor_animations.ANIMATION_IDLE.pick_random() )
	else:
		push_warning( name, ": No Idle animations.")
	
#func set_mode( mode : MODE ) -> void:
	#curr_MODE = mode
	## Disabled this on 31/07/25 fix this later
	#if curr_MODE == MODE.INACTIVE: 	set_inactive_ai(); 	speed = speed_slow
	#if curr_MODE == MODE.COMBAT: 	set_combat_ai(); 	speed = speed_normal
	
## TODO Fix this
func _physics_process( delta: float ) -> void:
	if Engine.is_editor_hint():	return
		
	## Makers the AI think.
	if actor_ai: actor_ai.step()
		
	match curr_STATE:
		STATE.NORMAL:			_normal_animation(delta)
		_:						pass # breakpoint ## TODO Set default states
		
	## Anim stuff
	last_movement_vector 	= movement_vector
	_process_movement( delta )

func cinema_look( _direction : Vector2 ) -> void:
	stop_animation.emit()
	movement_vector = _direction

## TODO Fix this, is incompatible with the old system
func _cinema_jump( times := 1 ) -> void:
	var t := create_tween()
	t.tween_interval(0.1)
	for i in times:
		t.tween_callback( play_local_sound.bind("hoopzweap_chitin_jump") )
		t.tween_property( ActorAnim, "position:y", -16.0, 0.1).set_ease(Tween.EASE_OUT)
		t.tween_property( ActorAnim, "position:y", 0.0, 0.2).set_ease(Tween.EASE_IN)
	await t.finished
	ActorAnim.position.y = 0.0
	return
	
## DEPRECATED function. THis was part of the old AI system (turn based)
func cinema_charge_telegraph( target_dir : Vector2 ) -> void:
	## TODO add charging animation
	#curr_MODE = MODE.AIMING
	if target_dir.y >= 0:		ActorAnim.play( actor_animations.CHARGE_DOWN )
	else:						ActorAnim.play( actor_animations.CHARGE_UP )
	ActorAnim.flip_h = target_dir.x < 0
	return
	
## DEPRECATED function. THis was part of the old AI system (turn based)
func cinema_charge_at( _charge_target : Vector2, _charge_speed : float ) -> void:
	## TODO add charging action
	charge_target 	= _charge_target
	charge_speed 	= _charge_speed
	#curr_MODE 		= MODE.CHARGING
	charge_stopping = false
	var my_dir := global_position.direction_to( charge_target )
	linear_damp = 5.0
	apply_central_impulse( my_dir * charge_speed * 0.35)
	ActorSmokeEmitter.get_process_material().direction = Vector3( -my_dir.x, -my_dir.y, 0 )
	ActorSmokeEmitter.emitting = true
	B2_Sound.play( sound_charge )

## Cheap. Play SFX on personal audiotream.
func play_local_sound( sound_name : String ) -> void:
	if ActorAudioPlayer:
		var sfx : String = B2_Sound.get_sound( sound_name )
		if sfx:
			ActorAudioPlayer.stream 		= load( sfx )
			ActorAudioPlayer.bus 			= "Audio"
			ActorAudioPlayer.max_distance 	= 300.0
			ActorAudioPlayer.play()
		else:
			push_warning("Invalid sound name: ", sound_name, " - ", sfx, ".")
	else:
		push_error("ActorAudioPlayer for actor %s not setup, dumbass." % name)
		
## Expensive. Play SFX on another audiotream.
func play_temp_local_sound( sound_name : String ) -> void:
	var temp_sfx := B2_Temp_AudioEmitter.new( sound_name )
	add_child( temp_sfx, true )

func damage_actor( damage : float, force : Vector2 ) -> void:
	## Cant be damaged if its not in combat.
	## TODO implement enviromental harm.
	#if curr_MODE == MODE.INACTIVE or curr_MODE == MODE.NONE:
	#	return
		
	if actor_is_dying or is_actor_dead: # dont process damage if the actor is dying.
		return
		
	## TODO apply resistances
	#push_warning("Applying dummy resistance reduction.")
	#print("%s: Applying dummy resistance reduction. FIXME" % name)
	#damage *= 0.5
	
	print( "Damaged actor %s with %s points of damage." % [self.name, damage] ) ## DEBUG
	
	B2_Screen.display_damage_number( self, damage )
	#B2_Sound.play( sound_damage )
	play_local_sound( sound_damage )
	apply_central_impulse( force )
	
	if enemy_data:
		@warning_ignore("narrowing_conversion")
		enemy_data.curr_health = clampi( enemy_data.curr_health - damage, 0, enemy_data.max_health )
		
		if enemy_data.curr_health <= 0.0:
			actor_is_dying 	= true
			actor_died.emit()
			destroy_actor()
		else:
			enemy_was_damaged.emit()
			if hit_tween:
				hit_tween.kill()
			hit_tween = create_tween()
			ActorAnim.modulate = Color.WHITE * 5.0
			hit_tween.tween_property( ActorAnim, "modulate", Color.WHITE, 0.1 )
			
	else: push_warning("Enemy data not loaded for %s." % name )
	_after_damage()

func spawn_gibs() -> void:
	const O_GIBS = preload("res://barkley2/scenes/Objects/_enemies/o_gibs.tscn")
	for i in randi_range(2,8) + 2:
		var gib = O_GIBS.instantiate()
		gib.global_position = global_position + Vector2( randf_range(-16,16), randf_range(-16,16) )
		gib.gib_sprite = gib_sprite
		gib.splatSound = splatSound
		gib.bloodburst = bloodburst
		add_sibling( gib, true )
		for p in randf_range(0,10): ## add some random delays
			await get_tree().process_frame

func destroy_actor() -> void:
	if is_actor_dead: ## Avoid running this more than once
		#return
		pass
		
	## Disable the loops.
	set_process( false )
	set_physics_process( false )
	actor_ai.queue_free() # Kill AI Kill AI Kill AI Kill AI Kill AI Kill AI Kill AI Kill AI Kill AI Kill AI Kill AI Kill AI Kill AI Kill AI Kill AI 
	
	is_actor_dead 	= true
	if my_shadow: my_shadow.hide()
	_before_death()
	#ActorCol.disabled = true
	if ActorCol: ActorCol.queue_free()
	else: push_warning("Collision was previously removed. Why it was removed? issue is with %s actor." % name) # Was having issues with the collision being removed twice. No idea why.
	#B2_Sound.play( sound_death )
	play_local_sound( sound_death ) # Better for 2D sound emission.
	
	## If TurnBased combat is active, let the system know that the enemy was defeated.
	B2_CombatManager.enemy_defeated(self)
	
	## Disabled this on 31/07/25 fix this later
	#if combat_ai:
		#combat_ai.combat_cancel( true )
	
	if explode_on_death:
		for i in randi_range(3,8):
			var off := Vector2( randf_range(-16,16), randf_range(-16,16) )
			B2_Screen.make_explosion( 2, global_position + off, Color.WHITE, randf_range(0.1,0.5) )
	
	## TEMP
	if make_gibs:
		spawn_gibs()
		
	if death_animation:
		ActorAnim.sprite_frames.set_animation_loop( death_animation, false )
		ActorAnim.play( death_animation )
	
	if stay_after_death:
		#ActorCol.disabled = true
		pass
	else:
		var t := create_tween()
		t.tween_property( ActorAnim, "self_modulate", Color.TRANSPARENT, randf_range( 0.05, 0.25 ) )
		#t.tween_property( self, "modulate", Color.TRANSPARENT, randf_range( 0.1, 0.25 ) )
		
		## Disabled 21-04-25
		#if is_instance_valid(B2_CManager.combat_manager):
			#t.tween_callback( B2_CManager.combat_manager.enemy_defeated.bind(self) )
		#else:
			#push_warning( "Combat manager not loaded" )
			
		t.tween_interval( 5.0 ) ## Add a small delay to wait on some animations to finish.
		t.tween_callback( get_parent().remove_child.bind(self) )
	
	B2_Drop.create_drops( enemy_data, global_position, false )
	enemy_was_defeated.emit()
	_after_death()

## DEPRECATED function. This was part of the old AI system (turn based)
## NOTE Not so DEPRECATED anymore, We can still use it for the new AI System.
func _on_body_entered(body: Node) -> void:
	if body is B2_CombatActor:
		if damage_player_on_contact:
			assert( body.has_method("damage_actor"), "%s: Something is very wrong here..." % name )
			body.damage_actor( 
				( enemy_data.weight * randf_range(0.5,1.5) ) * B2_Config.ENEMY_MELEE_DAMAGE_MULTIPLIER * linear_velocity.length(), 
				body.global_position.direction_to( global_position ) * 10.0
				)
			
	#if curr_MODE == MODE.CHARGING:
		#if body is B2_CombatActor:
			#body.damage_actor( 
				#( enemy_data.weight * randf() ) * B2_Config.ENEMY_MELEE_DAMAGE_MULTIPLIER, 
				#body.global_position.direction_to( global_position ) 
				#) ## TEMP
			#finished_charge_action.emit()
			#linear_damp = 10.0
			#curr_MODE = MODE.COMBAT
