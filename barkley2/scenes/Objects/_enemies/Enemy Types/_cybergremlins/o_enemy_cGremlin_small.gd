@icon("uid://clq6vos2qs815")
extends B2_EnemyCombatActor
class_name B2_Enemy_CGremlin
## Funky little guys. They seem to use random body pieces. What. A. Chore.

const BODY_ANIM_FRAME_STAND 				:= 0		# The sprite frame used for standing
const BODY_ANIM_FRAME_HURT 					:= 1		# The sprite frame used for hurting
const BODY_ANIM_FRAME_WALK 					:= 2		# The sprite frame that starts the walking animation
const BODY_ANIM_FRAME_WALK_RANGE			:= 5		# The amount of frames in said walking animations
const BODY_ANIM_FRAME_UP_OFFSET				:= 7		# The amount of offset needed to reach the "up" animations
const BODY_ANIM_FRAME_TYPE_OFFSET			:= 12		# The amount of offset needed to reach another type of animation

const HEAD_ANIM_FRAME_STAND 				:= 0		# The sprite frame used for standing
const HEAD_ANIM_FRAME_HURT 					:= 1		# The sprite frame used for hurting
const HEAD_ANIM_FRAME_UP_OFFSET				:= 2		# The amount of offset needed to reach the "up" animations
const HEAD_ANIM_FRAME_TYPE_OFFSET			:= 4		# The amount of offset needed to reach another type of animation

## Left being, Grem is looking downward and to the right.
const LEFT_ARM_ANIM_FRAME_STAND 			:= 0		# The sprite frame used for standing
const LEFT_ARM_ANIM_FRAME_HURT 				:= 1		# The sprite frame used for hurting
const LEFT_ARM_ANIM_FRAME_UP_OFFSET			:= 10		# The amount of offset needed to reach the "up" animations

## Right being, Grem is looking downward and to the right.
const RIGHT_ARM_ANIM_FRAME_STAND 			:= 0		# The sprite frame used for standing
const RIGHT_ARM_ANIM_FRAME_HURT 			:= 1		# The sprite frame used for hurting
const RIGHT_ARM_ANIM_FRAME_UP_OFFSET		:= 10		# The amount of offset needed to reach the "up" animations

@onready var actor_anim_head: 		AnimatedSprite2D = $ActorAnimHead
@onready var actor_anim_weapon: 	AnimatedSprite2D = $ActorAnimWeapon
@onready var actor_anim_arm_r: 		AnimatedSprite2D = $ActorAnimArmR
@onready var actor_anim_body: 		AnimatedSprite2D = $ActorAnimBody
@onready var actor_anim_atk_arm: 	AnimatedSprite2D = $ActorAnimAtkArm
@onready var actor_anim_arm_l: 		AnimatedSprite2D = $ActorAnimArmL

var pType 		:= 0
var headType 	:= 0
var weaponType 	:= 0
var armTypeR 	:= 0
var armTypeL	:= 0

func _ready() -> void:
	super()
	_roll_dice()
	_head_setup()
	_body_setup()
	
func _roll_dice() -> void:
	pType 		= [0,0,0,0,4					].pick_random()
	headType 	= [3,3,3,3,3,4,5,6,7,8			].pick_random()
	weaponType 	= [0,1,2,3,4,5					].pick_random()
	armTypeR 	= [0,0,0,1,2					].pick_random()
	armTypeL 	= [armTypeR,armTypeR,0,1,2		].pick_random()
	
## Setup the sprite frames
func _head_setup() -> void:
	actor_anim_head.sprite_frames.add_animation("normal")
	var normal_down 	:= actor_anim_head.sprite_frames.get_frame_texture("default", HEAD_ANIM_FRAME_STAND + pType)
	var normal_up 	:= actor_anim_head.sprite_frames.get_frame_texture("default", HEAD_ANIM_FRAME_STAND + HEAD_ANIM_FRAME_UP_OFFSET + pType)
	actor_anim_head.sprite_frames.add_frame("normal", normal_down)
	actor_anim_head.sprite_frames.add_frame("normal", normal_up)
	
	actor_anim_head.sprite_frames.add_animation("hurt")
	var hurt_down 	:= actor_anim_head.sprite_frames.get_frame_texture("default", HEAD_ANIM_FRAME_HURT + pType)
	var hurt_up 	:= actor_anim_head.sprite_frames.get_frame_texture("default", HEAD_ANIM_FRAME_HURT + HEAD_ANIM_FRAME_UP_OFFSET + pType)
	actor_anim_head.sprite_frames.add_frame("hurt", hurt_down)
	actor_anim_head.sprite_frames.add_frame("hurt", hurt_up)

## Setup the sprite frames
func _body_setup() -> void:
	actor_anim_body.sprite_frames.add_animation("stand")
	var stand_down 	:= actor_anim_body.sprite_frames.get_frame_texture("default", BODY_ANIM_FRAME_STAND + pType)
	var stand_up 	:= actor_anim_body.sprite_frames.get_frame_texture("default", BODY_ANIM_FRAME_STAND + BODY_ANIM_FRAME_UP_OFFSET + pType)
	actor_anim_body.sprite_frames.add_frame("stand", stand_down)
	actor_anim_body.sprite_frames.add_frame("stand", stand_up)
	
	actor_anim_body.sprite_frames.add_animation("hurt")
	var hurt_down 	:= actor_anim_body.sprite_frames.get_frame_texture("default", BODY_ANIM_FRAME_HURT + pType)
	var hurt_up 	:= actor_anim_body.sprite_frames.get_frame_texture("default", BODY_ANIM_FRAME_HURT + BODY_ANIM_FRAME_UP_OFFSET + pType)
	actor_anim_body.sprite_frames.add_frame("hurt", hurt_down)
	actor_anim_body.sprite_frames.add_frame("hurt", hurt_up)
	
	## Set walking animation (up and down)
	actor_anim_body.sprite_frames.add_animation("south")
	actor_anim_body.sprite_frames.add_animation("north")
	for i : int in BODY_ANIM_FRAME_WALK_RANGE:
		var south := actor_anim_body.sprite_frames.get_frame_texture("default", BODY_ANIM_FRAME_WALK + i + pType)
		var north := actor_anim_body.sprite_frames.get_frame_texture("default", BODY_ANIM_FRAME_WALK + BODY_ANIM_FRAME_TYPE_OFFSET + i + pType)
		actor_anim_body.sprite_frames.add_frame("south", south)
		actor_anim_body.sprite_frames.add_frame("north", north)

func _body_part_z_index() -> void:
	pass

func _normal_animation(_delta : float) -> void:
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
			flip_sprite( input, actor_anim_body )
			flip_sprite( input, actor_anim_head )
			
			if actor_anim_body: # Safety check. Thanks CyberGremlin!
				match input.round():
					Vector2.UP + Vector2.LEFT:			actor_anim_body.play( actor_animations.ANIMATION_NORTHWEST )
					Vector2.UP + Vector2.RIGHT:			actor_anim_body.play( actor_animations.ANIMATION_NORTHEAST )
					Vector2.DOWN + Vector2.LEFT:		actor_anim_body.play( actor_animations.ANIMATION_SOUTHWEST )
					Vector2.DOWN + Vector2.RIGHT:		actor_anim_body.play( actor_animations.ANIMATION_SOUTHEAST )
						
					Vector2.UP:							actor_anim_body.play( actor_animations.ANIMATION_NORTH )
					Vector2.LEFT:						actor_anim_body.play( actor_animations.ANIMATION_WEST )
					Vector2.DOWN:						actor_anim_body.play( actor_animations.ANIMATION_SOUTH )
					Vector2.RIGHT:						actor_anim_body.play( actor_animations.ANIMATION_EAST )
					Vector2.ZERO:						pass
					_: # Catch All
						print("Catch all 'input' for %s -> %s " % [name, input])
	else:
		# AI is not moving the actor anymore
		if actor_animations:
			if actor_anim_body.is_playing():
				actor_anim_body.stop()
			actor_anim_body.animation = actor_animations.ANIMATION_STAND
		
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
			
		STATE.WADING:			pass
		STATE.HIT:				pass
		STATE.NORMAL:
			_normal_animation(delta)
			var move := curr_input # Take the input from the keyboard / Gamepag and apply directly.
			velocity = ( walk_speed * delta ) * move
			
			velocity += external_velocity
			external_velocity = Vector2.ZERO # Reset Ext velocity
			apply_central_force( velocity / Engine.time_scale )
