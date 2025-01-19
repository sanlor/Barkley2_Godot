extends B2_CombatActor
class_name B2_EnemyCombatActor
## Base class for all Combat enemieso_enemy_drone_egg

const O_SHADOW = preload("res://barkley2/scenes/Objects/System/o_shadow.tscn")

@export_category("Actor Stuff")
@export var cast_shadow		:= true
@export var shadow_scale	:= 1.0
@export var ActorAnim 		: AnimatedSprite2D
@export var has_collision 	:= true
@export var ActorCol 		: CollisionShape2D

var my_shadow 		: Sprite2D

## Movement and animation variables.
var is_moving 			:= false
var playing_animation 	:= "stand"
var movement_vector 		:= Vector2.ZERO
var real_movement_vector 	:= Vector2.ZERO
var last_movement_vector 	:= Vector2.ZERO

@export_category("Animation")
@export var animation_speed 	:= 1.5			## Multiplier used on playset animations
@export var actor_animations 	: B2_Actor_Animations
@export var animation_attack 	:= ""
@export var animation_jump 		:= ""
@export var animation_stagger 	:= ""

@export_category("Sounds")
@export var sound_alert			:= ""
@export var sound_damage		:= ""
@export var sound_death			:= ""

@export_category("Movement Stuff")
var velocity				:= Vector2.ZERO
var speed_multiplier 		:= 5000.0 # was 900.0
@export var speed_slow 		:= 12.0 # was 1.5
@export var speed_normal 	:= 20.0 # was 2.5
@export var speed_fast 		:= 35.0 # was 5.0
var speed 					:= speed_normal

@export_category("A.I") ## Artificial... Inteligence... - Neil Breen
@export var wander_ai 	: String
@export var chase_ai 	: String
@export var combat_ai 	: String

var wander_target_pos := Vector2.ZERO 

var home_point 		:= Vector2.ZERO
var home_radius 	:= 150.0

func _enter_tree() -> void:
	_setup_enemy()
	$Timer.timeout.connect( _debug_get_random_pos )
	
func _setup_enemy() -> void:
	if not is_instance_valid( ActorAnim ):
		ActorAnim 	= get_node( "ActorAnim" )
	if not is_instance_valid( ActorCol ):
		ActorCol 	= get_node( "ActorCol" )
	if cast_shadow:
		my_shadow = O_SHADOW.instantiate()
		my_shadow.scale *= shadow_scale
		add_child( my_shadow, true)
		
	home_point = global_position

func _animations() -> void:
	if is_instance_valid( actor_animations ):
		if velocity.length() > 10: ## is moving
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
		if velocity != Vector2.ZERO:
			if movement_vector.x < 0:
				ActorAnim.flip_h = true
			else:
				ActorAnim.flip_h = false
			
func _debug_get_random_pos():
	is_moving = true
	wander_target_pos = home_point
	wander_target_pos += Vector2.LEFT.rotated( randf_range(0, TAU) ) * randf_range(0, home_radius)
	
func _physics_process(delta: float) -> void:
	if is_moving:
		velocity = global_position.direction_to(wander_target_pos) * 50000
	else:
		velocity = Vector2.ZERO
		
	apply_central_force( velocity )
	
	movement_vector 		= velocity.normalized().round()
	_animations()
	last_movement_vector 	= movement_vector
	
	if global_position.distance_to( wander_target_pos ) < 40:
		is_moving = false
		wander_target_pos = Vector2.ZERO
		
	queue_redraw()

func _draw() -> void:
	draw_circle( to_local(home_point), home_radius, Color( Color.PINK, 0.25 ), true )
	draw_circle( to_local(wander_target_pos), 8.0, Color.YELLOW, false )
	draw_string(ThemeDB.fallback_font, Vector2(0, -30), str(movement_vector), HORIZONTAL_ALIGNMENT_CENTER)
