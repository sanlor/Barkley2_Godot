@icon("res://barkley2/assets/b2_original/images/merged/icon_parent_3.png")
extends B2_CombatActor
class_name B2_EnemyCombatActor
## Base class for all Combat enemies o_enemy_drone_egg

const O_SHADOW 						= preload("res://barkley2/scenes/Objects/System/o_shadow.tscn")
const O_EFFECT_EMOTEBUBBLE_EVENT 	= preload("res://barkley2/scenes/_event/Misc/o_effect_emotebubble_event.tscn")

signal aim_target_changed
signal move_target_changed
signal finished_charge_action	## Actor is done with its charge/rush action.

enum MODE{INACTIVE,COMBAT,AIMING,CHARGING,DEATH}
var curr_MODE := MODE.INACTIVE
var is_changing_states := false

@export_category("Enemy stuff")
@export var my_nest					: Area2D

@export_category("Actor Stuff")
@export var cast_shadow		:= true
@export var shadow_scale	:= 1.0
@export var ActorAnim 		: AnimatedSprite2D
@export var smoke_emitter	: GPUParticles2D
@export var has_collision 	:= true
#@export var ActorCol 		: CollisionShape2D

var my_shadow 		: Sprite2D

## Movement and animation variables.
var playing_animation 			:= "stand"

@export_category("Animation")
#@export var animation_speed 	:= 1.5			## Multiplier used on playset animations
@export var actor_animations 	: B2_Actor_Animations
@export var animation_attack 	:= ""
@export var animation_jump 		:= ""
@export var animation_stagger 	:= ""

@export_category("Sounds")
@export var sound_alert			:= ""
@export var sound_damage		:= ""
@export var sound_death			:= ""
@export var sound_charge		:= ""

@export_category("Enemy Stats")
@export var enemy_name				:= ""
@export var enemy_data				: B2_EnemyData
@export var enemy_weapon_type		: B2_Gun.TYPE
@export var enemy_weapon_material	: B2_Gun.MATERIAL
var enemy_ranged 					: B2_Weapon
@export var enemy_melee				: B2_MeleeAttack ## TODO

@export_category("A.I") ## Artificial... Inteligence... -Neil Breen
@export var inactive_ai 		: B2_AI_Wander
#@export var chase_ai 			: B2_AI_Chase
@export var combat_ai 			: B2_AI_Combat

## Control stuff
var move_target 	:= Vector2.ZERO ## Cinema stuff: Tells where the node should walk to.
var aim_target 		:= Vector2.ZERO ## Cinema stuff: Tells where the node should aim to. Can be used with "move_target" to move and aim at the same time.
var charge_target	:= Vector2.ZERO ## Combat stuff: Tells where the enemy should charge torward
var charge_speed	:= 0.0
var charge_stopping := false

var hit_tween	: Tween

func _ready() -> void:
	_setup_enemy()
	
func _setup_enemy() -> void:
	if not is_instance_valid( ActorAnim ):
		ActorAnim 	= get_node( "ActorAnim" )
	if not is_instance_valid( ActorCol ):
		ActorCol 	= get_node( "ActorCol" )
		
	## A.I.
	if not is_instance_valid( inactive_ai ):
		push_error("%s: inactive_ai not set." % name)
	else:
		if my_nest:		inactive_ai.home_point = my_nest.global_position
		else:			inactive_ai.home_point = global_position
		inactive_ai.emote.connect( _emote )
		
	if not is_instance_valid( combat_ai ):
		push_error("%s:combat_ai not set." % name)
		
	if cast_shadow:
		my_shadow = O_SHADOW.instantiate()
		my_shadow.scale *= shadow_scale
		add_child( my_shadow, true)
		
	if enemy_name:
		if not enemy_data:
			enemy_data = B2_EnemyData.new()
		enemy_data.apply_stats( enemy_name )
		
	#enemy_ranged = B2_Gun.generate_gun( enemy_weapon_type, enemy_weapon_material )
	set_mode( MODE.INACTIVE )
	
func _emote( type : String ) -> void:
	var emote = O_EFFECT_EMOTEBUBBLE_EVENT.instantiate()
	emote.type = "!"
	emote.position  = position + Vector2( 0, -20 )
	add_sibling( emote )

func _animations() -> void:
	if is_instance_valid( actor_animations ):
		if is_moving:
			var _dir := "default"
					
			match movement_vector:
				Vector2.UP + Vector2.LEFT: 		_dir = actor_animations.ANIMATION_NORTHWEST
				Vector2.UP + Vector2.RIGHT: 	_dir = actor_animations.ANIMATION_NORTHEAST
				Vector2.DOWN + Vector2.LEFT: 	_dir = actor_animations.ANIMATION_SOUTHWEST
				Vector2.DOWN + Vector2.RIGHT: 	_dir = actor_animations.ANIMATION_SOUTHEAST
						
				Vector2.UP: 		_dir = actor_animations.ANIMATION_NORTH
				Vector2.LEFT: 		_dir = actor_animations.ANIMATION_WEST
				Vector2.DOWN: 		_dir = actor_animations.ANIMATION_SOUTH
				Vector2.RIGHT: 		_dir = actor_animations.ANIMATION_EAST
			
			if playing_animation != _dir:
				ActorAnim.play(_dir, animation_speed)
				playing_animation = _dir
				
		else: ## is stopped
			ActorAnim.stop()
			ActorAnim.animation 	= actor_animations.ANIMATION_STAND
			playing_animation 		= actor_animations.ANIMATION_STAND
			
			match movement_vector:
				Vector2.UP + Vector2.LEFT: 		ActorAnim.frame = actor_animations.ANIMATION_STAND_SPRITE_INDEX[ 7 ]
				Vector2.UP + Vector2.RIGHT: 	ActorAnim.frame = actor_animations.ANIMATION_STAND_SPRITE_INDEX[ 1 ]
				Vector2.DOWN + Vector2.LEFT: 	ActorAnim.frame = actor_animations.ANIMATION_STAND_SPRITE_INDEX[ 5 ]
				Vector2.DOWN + Vector2.RIGHT: 	ActorAnim.frame = actor_animations.ANIMATION_STAND_SPRITE_INDEX[ 3 ]
						
				Vector2.UP: 	ActorAnim.frame = actor_animations.ANIMATION_STAND_SPRITE_INDEX[ 0 ]
				Vector2.LEFT: 	ActorAnim.frame = actor_animations.ANIMATION_STAND_SPRITE_INDEX[ 6 ]
				Vector2.DOWN: 	ActorAnim.frame = actor_animations.ANIMATION_STAND_SPRITE_INDEX[ 4 ]
				Vector2.RIGHT: 	ActorAnim.frame = actor_animations.ANIMATION_STAND_SPRITE_INDEX[ 2 ]
				
		## Flip sprite, if necessary
		#if is_moving:
		if movement_vector.x < 0:
			ActorAnim.flip_h = true
		else:
			ActorAnim.flip_h = false
		
func play_idle_anim() -> void:
	if not actor_animations.ANIMATION_IDLE.is_empty():
		ActorAnim.play( actor_animations.ANIMATION_IDLE.pick_random() )
	else:
		push_warning( name, ": No Idle animations.")
	
func set_mode( mode : MODE ) -> void:
	curr_MODE = mode
	if curr_MODE == MODE.INACTIVE: 	set_inactive_ai(); 	speed = speed_slow
	if curr_MODE == MODE.COMBAT: 	set_combat_ai(); 	speed = speed_normal
	
func _physics_process( delta: float ) -> void:
	match curr_MODE:
		MODE.INACTIVE:
			inactive_ai.step()
			_animations()
			
		MODE.COMBAT:
			if is_changing_states:
				return
			_animations()
			
		MODE.DEATH:
			if is_changing_states:
				return
			pass
			
		MODE.CHARGING:
			if is_changing_states:
				return
				
			if global_position.distance_to( charge_target ) > 10.0 and not charge_stopping:
				apply_central_force( global_position.direction_to( charge_target ) * charge_speed )
			else:
				charge_stopping = true
				
			if linear_velocity.length() < 1.0 and charge_stopping:
				linear_damp = 10.0
				finished_charge_action.emit()
				curr_MODE = MODE.COMBAT
			pass
		
	## Anim stuff
	last_movement_vector 	= movement_vector
	_process_movement( delta )

func cinema_look( _direction : Vector2 ) -> void:
	stop_animation.emit()
	movement_vector = _direction

func cinema_jump( times := 1 ) -> void:
	var t := create_tween()
	t.tween_interval(0.1)
	for i in times:
		t.tween_callback( B2_Sound.play.bind("hoopzweap_chitin_jump") )
		t.tween_property( ActorAnim, "position:y", -16.0, 0.1).set_ease(Tween.EASE_OUT)
		t.tween_property( ActorAnim, "position:y", 0.0, 0.2).set_ease(Tween.EASE_IN)
	await t.finished
	ActorAnim.position.y = 0.0
	return
	
func cinema_charge_telegraph( target_dir : Vector2 ) -> void:
	## TODO add charging animation
	curr_MODE = MODE.AIMING
	if target_dir.y >= 0:
		ActorAnim.play( actor_animations.CHARGE_DOWN )
	else:
		ActorAnim.play( actor_animations.CHARGE_UP )
	ActorAnim.flip_h = target_dir.x < 0
	return
	
func cinema_charge_at( _charge_target : Vector2, _charge_speed : float ) -> void:
	## TODO add charging action
	charge_target 	= _charge_target
	charge_speed 	= _charge_speed
	curr_MODE 		= MODE.CHARGING
	charge_stopping = false
	var my_dir := global_position.direction_to( charge_target )
	linear_damp = 5.0
	apply_central_impulse( my_dir * charge_speed * 0.35)
	smoke_emitter.get_process_material().direction = Vector3( -my_dir.x, -my_dir.y, 0 )
	smoke_emitter.emitting = true
	B2_Sound.play( sound_charge )

## Combat stuff
func get_combat_ai() -> B2_AI_Combat:
	if combat_ai:
		return combat_ai
	else:
		return B2_AI_Combat.new()
		
func get_inactive_ai() -> B2_AI_Wander:
	if inactive_ai:
		return inactive_ai
	else:
		return B2_AI_Wander.new()

func set_combat_ai() -> void:
	inactive_ai.is_active 	= false
	combat_ai.is_active 	= true
	
func set_inactive_ai() -> void:
	inactive_ai.is_active 	= true
	combat_ai.is_active 	= false

func damage_actor( damage : int, force : Vector2 ) -> void:
	if actor_is_dying: # dont process damage if the actor is dying.
		return
		
	print( "Damaged actor %s with %s points of damage." % [self.name, damage] ) ## DEBUG
	
	B2_Screen.display_damage_number( self, damage )
	B2_Sound.play( sound_damage )
	apply_central_impulse( force )
	
	@warning_ignore("narrowing_conversion")
	enemy_data.curr_health = clampi( enemy_data.curr_health - damage, 0, enemy_data.max_health )
	
	actor_died.emit()
	
	if enemy_data.curr_health <= 0:
		actor_is_dying = true
		destroy_actor()
	else:
		if hit_tween:
			hit_tween.kill()
		hit_tween = create_tween()
		modulate = Color.WHITE * 5.0
		hit_tween.tween_property(self, "modulate", Color.WHITE, 0.1)

func destroy_actor() -> void:
	const O_GIBS = preload("res://barkley2/scenes/Objects/_enemies/o_gibs.tscn")
	B2_Sound.play( sound_death )
	B2_CManager.combat_manager.enemy_defeated(self)
	combat_ai.combat_cancel( true )
	
	for i in randi_range(3,8):
		var off := Vector2( randf_range(-16,16), randf_range(-16,16) )
		B2_Screen.make_explosion( 2, global_position + off, Color.WHITE, randf_range(0.1,0.5) )
	
	## TEMP
	for i in randi_range(0,8) + 2:
		var gib = O_GIBS.instantiate()
		gib.global_position = global_position + Vector2( randf_range(-16,16), randf_range(-16,16) )
		gib.gib_sprite = "s_enemyDeath_parts"
		gib.splatSound = "junkbot_death_partclink"
		gib.bloodburst = ""
		add_sibling( gib, true )
		for p in randf_range(0,10): ## add some random delays
			await get_tree().process_frame
	
	var t := create_tween()
	t.tween_property( self, "modulate", Color.TRANSPARENT, randf_range( 0.1, 0.5 ) )
	## Disabled 21-04-25
	#if is_instance_valid(B2_CManager.combat_manager):
		#t.tween_callback( B2_CManager.combat_manager.enemy_defeated.bind(self) )
	#else:
		#push_warning( "Combat manager not loaded" )
	t.tween_callback( get_parent().remove_child.bind(self) )

func _on_body_entered(body: Node) -> void:
	if curr_MODE == MODE.CHARGING:
		if body is B2_CombatActor:
			body.damage_actor( enemy_data.weight * randf(), body.global_position.direction_to( global_position ) ) ## TEMP
			finished_charge_action.emit()
			linear_damp = 10.0
			curr_MODE = MODE.COMBAT
