extends B2_CombatActor
class_name B2_EnemyCombatActor
## Base class for all Combat enemieso_enemy_drone_egg

const O_SHADOW 						= preload("res://barkley2/scenes/Objects/System/o_shadow.tscn")
const O_EFFECT_EMOTEBUBBLE_EVENT 	= preload("res://barkley2/scenes/_event/Misc/o_effect_emotebubble_event.tscn")

@onready var action_timer: Timer = $action_timer

enum MODE{WANDER,CHASE,COMBAT,DEATH}
var curr_MODE := MODE.WANDER
var is_changing_states := false

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

@export_category("A.I") ## Artificial... Inteligence... -Neil Breen
@export var wander_ai 	: B2_AI_Wander
@export var chase_ai 	: B2_AI_Chase
@export var combat_ai 	: B2_AI_Chase

var wander_target_pos := Vector2.ZERO 

var home_point 		:= Vector2.ZERO
var home_radius 	:= 100.0

## Player Detection
var detection_radius := 80.0

func _ready() -> void:
	_setup_enemy()
	
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
	action_timer.start( 5.0 )
	
	wander_ai.resource_local_to_scene = true
	wander_ai.emote.connect( _emote )
	action_timer.timeout.connect( _debug_get_random_pos )

func _emote( type : String ) -> void:
	var emote = O_EFFECT_EMOTEBUBBLE_EVENT.instantiate()
	emote.type = "!"
	emote.position  = position + Vector2( 0, -20 )
	add_sibling( emote )

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
	match curr_MODE:
		MODE.WANDER:
			wander_ai.step( self )
				
		MODE.CHASE:
			if is_changing_states:
				return
			pass
			
		MODE.COMBAT:
			if is_changing_states:
				return
			pass
			
		MODE.DEATH:
			if is_changing_states:
				return
			pass
		
	## Anim stuff
	movement_vector 		= velocity.normalized().round()
	_animations()
	last_movement_vector 	= movement_vector
			
	## DEBUG
	queue_redraw()

func _draw() -> void:
	draw_circle( to_local(home_point), home_radius, Color( Color.PINK, 0.25 ), true )
	draw_circle( to_local(wander_target_pos), 8.0, Color.YELLOW, false )
	draw_string(ThemeDB.fallback_font, Vector2(0, -30), str(movement_vector), HORIZONTAL_ALIGNMENT_CENTER)
