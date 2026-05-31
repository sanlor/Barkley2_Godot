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
const LEFT_ARM_ANIM_FRAME_STAND 			:= 1		# The sprite frame used for standing
const LEFT_ARM_ANIM_FRAME_HURT 				:= 0		# The sprite frame used for hurting
const LEFT_ARM_ANIM_FRAME_TYPE_OFFSET		:= 5		# The amount of offset needed to reach another type of animation
const LEFT_ARM_ANIM_FRAME_RANGE				:= 4

## Right being, Grem is looking downward and to the right.
const RIGHT_ARM_ANIM_FRAME_STAND 			:= 1		# The sprite frame used for standing
const RIGHT_ARM_ANIM_FRAME_HURT 			:= 0		# The sprite frame used for hurting
const RIGHT_ARM_ANIM_FRAME_TYPE_OFFSET		:= 5		# The amount of offset needed to reach another type of animation
const RIGHT_ARM_ANIM_FRAME_RANGE			:= 4

@onready var actor_anim_head: 		AnimatedSprite2D = $ActorAnimHead
@onready var actor_anim_weapon: 	AnimatedSprite2D = $ActorAnimWeapon
@onready var actor_anim_arm_r: 		AnimatedSprite2D = $ActorAnimArmR
@onready var actor_anim_body: 		AnimatedSprite2D = $ActorAnimBody
@onready var actor_anim_atk_arm: 	AnimatedSprite2D = $ActorAnimAtkArm
@onready var actor_anim_arm_l: 		AnimatedSprite2D = $ActorAnimArmL

var pType 		:= 0	## Grem type, makes different body parts
var headType 	:= 0	## Grem head
var weaponType 	:= 0	## ????
var armTypeR 	:= 0	## Grem arm
var armTypeL	:= 0	## Grem other arm

func _ready() -> void:
	super()
	_roll_dice()
	_head_setup()
	_body_setup()
	_l_arm_setup()
	_r_arm_setup()
	_weapon_setup()
	
## Randomize stuff.
func _roll_dice() -> void:
	pType 		= [0,0,0,0,4					].pick_random()
	#pType 		= 4
	headType 	= [3,3,3,3,3,4,5,6,7,8			].pick_random()
	weaponType 	= [0,1,2,3,4,5					].pick_random()
	armTypeR 	= [0,0,0,1,2					].pick_random()
	armTypeL 	= [armTypeR,armTypeR,0,1,2		].pick_random()
	
	# Randomize the snimation speed
	actor_anim_arm_l.speed_scale 	= randf_range(1.0,2.0)
	actor_anim_arm_r.speed_scale 	= randf_range(1.0,2.0)
	actor_anim_body.speed_scale 	= randf_range(1.0,2.0)
	
func _weapon_setup() -> void:
	actor_anim_weapon.frame = weaponType
	
## Setup the sprite frames
func _head_setup() -> void:
	actor_anim_head.sprite_frames.add_animation("normal")
	var normal_down 	:= actor_anim_head.sprite_frames.get_frame_texture("default", ( HEAD_ANIM_FRAME_STAND ) + ( HEAD_ANIM_FRAME_TYPE_OFFSET * pType ) )
	var normal_up 	:= actor_anim_head.sprite_frames.get_frame_texture("default", ( HEAD_ANIM_FRAME_STAND + HEAD_ANIM_FRAME_UP_OFFSET ) + ( HEAD_ANIM_FRAME_TYPE_OFFSET * pType ) )
	actor_anim_head.sprite_frames.add_frame("normal", normal_down)
	actor_anim_head.sprite_frames.add_frame("normal", normal_up)
	
	actor_anim_head.sprite_frames.add_animation("hurt")
	var hurt_down 	:= actor_anim_head.sprite_frames.get_frame_texture("default", ( HEAD_ANIM_FRAME_HURT ) + ( HEAD_ANIM_FRAME_TYPE_OFFSET * pType ) )
	var hurt_up 	:= actor_anim_head.sprite_frames.get_frame_texture("default", ( HEAD_ANIM_FRAME_HURT + HEAD_ANIM_FRAME_UP_OFFSET) + (HEAD_ANIM_FRAME_TYPE_OFFSET * pType ) )
	actor_anim_head.sprite_frames.add_frame("hurt", hurt_down)
	actor_anim_head.sprite_frames.add_frame("hurt", hurt_up)

## Setup the sprite frames
func _body_setup() -> void:
	actor_anim_body.sprite_frames.add_animation("stand")
	var stand_down 	:= actor_anim_body.sprite_frames.get_frame_texture("default", ( BODY_ANIM_FRAME_STAND ) + ( BODY_ANIM_FRAME_TYPE_OFFSET * pType ) )
	var stand_up 	:= actor_anim_body.sprite_frames.get_frame_texture("default", ( BODY_ANIM_FRAME_STAND + BODY_ANIM_FRAME_UP_OFFSET ) + ( BODY_ANIM_FRAME_TYPE_OFFSET * pType ) )
	actor_anim_body.sprite_frames.add_frame("stand", stand_down)
	actor_anim_body.sprite_frames.add_frame("stand", stand_up)
	
	actor_anim_body.sprite_frames.add_animation("hurt")
	var hurt_down 	:= actor_anim_body.sprite_frames.get_frame_texture("default", ( BODY_ANIM_FRAME_HURT ) + ( BODY_ANIM_FRAME_TYPE_OFFSET * pType ) )
	var hurt_up 	:= actor_anim_body.sprite_frames.get_frame_texture("default", ( BODY_ANIM_FRAME_HURT + BODY_ANIM_FRAME_UP_OFFSET ) + ( BODY_ANIM_FRAME_TYPE_OFFSET * pType ) )
	actor_anim_body.sprite_frames.add_frame("hurt", hurt_down)
	actor_anim_body.sprite_frames.add_frame("hurt", hurt_up)
	
	## Set walking animation (up and down)
	actor_anim_body.sprite_frames.add_animation("south")
	actor_anim_body.sprite_frames.add_animation("north")
	for i : int in BODY_ANIM_FRAME_WALK_RANGE - 1: # The animation is a bit weird here, need to add a few specific offsets.
		var south := actor_anim_body.sprite_frames.get_frame_texture("default", ( BODY_ANIM_FRAME_WALK + i ) + ( BODY_ANIM_FRAME_TYPE_OFFSET * pType ) )
		var north := actor_anim_body.sprite_frames.get_frame_texture("default", ( BODY_ANIM_FRAME_UP_OFFSET + 1 + i ) + ( BODY_ANIM_FRAME_TYPE_OFFSET * pType ) )
		actor_anim_body.sprite_frames.add_frame("south", south)
		actor_anim_body.sprite_frames.add_frame("north", north)

## Setup the sprite frames
func _l_arm_setup() -> void:
	actor_anim_arm_l.sprite_frames.add_animation("normal")
	for i : int in LEFT_ARM_ANIM_FRAME_RANGE - 1:
		var normal := actor_anim_arm_l.sprite_frames.get_frame_texture("default", ( LEFT_ARM_ANIM_FRAME_STAND + i ) + ( LEFT_ARM_ANIM_FRAME_TYPE_OFFSET * pType ) )
		actor_anim_arm_l.sprite_frames.add_frame("normal", normal)
		
	actor_anim_arm_l.sprite_frames.add_animation("hurt")
	var hurt 	:= actor_anim_arm_l.sprite_frames.get_frame_texture("default", ( LEFT_ARM_ANIM_FRAME_HURT ) + ( LEFT_ARM_ANIM_FRAME_TYPE_OFFSET * pType ) )
	
## Setup the sprite frames
func _r_arm_setup() -> void:
	actor_anim_arm_r.sprite_frames.add_animation("normal")
	for i : int in RIGHT_ARM_ANIM_FRAME_RANGE - 1:
		var normal := actor_anim_arm_r.sprite_frames.get_frame_texture("default", ( RIGHT_ARM_ANIM_FRAME_STAND + i ) + ( RIGHT_ARM_ANIM_FRAME_TYPE_OFFSET * pType ) )
		actor_anim_arm_r.sprite_frames.add_frame("normal", normal)
		
	actor_anim_arm_r.sprite_frames.add_animation("hurt")
	var hurt 	:= actor_anim_arm_r.sprite_frames.get_frame_texture("default", ( RIGHT_ARM_ANIM_FRAME_HURT ) + ( RIGHT_ARM_ANIM_FRAME_TYPE_OFFSET * pType ) )

## Handles the sprite draw order
func _z_index_organizer( input 	:= curr_input ) -> void:
	if roundf(input.y) == -1:
		actor_anim_body.z_index 	= 0
		actor_anim_head.z_index 	= 0
		actor_anim_arm_r.z_index 	= 0
		actor_anim_arm_l.z_index 	= 0
		actor_anim_weapon.z_index 	= 1
	elif roundf(input.y) == 1:
		actor_anim_body.z_index 	= 0
		actor_anim_head.z_index 	= 0
		actor_anim_arm_r.z_index 	= 0
		actor_anim_arm_l.z_index 	= 0
		actor_anim_weapon.z_index 	= -1
	else:
		## avoid actions when input.y == 0
		pass

func _normal_animation(_delta : float) -> void:
	if is_playingset: # Stop normal animations when a cinema_playset is playing.
		return
		
	var input 	:= curr_input
	var aim		:= curr_aim
	
	## Overide input with aim, it the actor is aiming at something.
	#if curr_aim != Vector2.ZERO: input = curr_aim
	#print(input)
	
	if input != Vector2.ZERO: # AI is moving the Actor
		if last_input != input:
			## Flip sprite if needed.
			flip_sprite( input, actor_anim_body )
			flip_sprite( input, actor_anim_head )
			flip_sprite( input, actor_anim_arm_r )
			flip_sprite( input, actor_anim_arm_l )
			flip_sprite( input, actor_anim_weapon )
			_z_index_organizer( input )
			
			if actor_anim_body and actor_anim_head: # Safety check. Thanks CyberGremlin!
				match input.round():
					Vector2.UP + Vector2.LEFT:			
						actor_anim_body.play( actor_animations.ANIMATION_NORTHWEST ); 
						actor_anim_head.animation = "normal"
						actor_anim_head.frame = 1
					Vector2.UP + Vector2.RIGHT:			
						actor_anim_body.play( actor_animations.ANIMATION_NORTHEAST )
						actor_anim_head.animation = "normal"
						actor_anim_head.frame = 1
					Vector2.DOWN + Vector2.LEFT:		
						actor_anim_body.play( actor_animations.ANIMATION_SOUTHWEST )
						actor_anim_head.animation = "normal"
						actor_anim_head.frame = 0
					Vector2.DOWN + Vector2.RIGHT:		
						actor_anim_body.play( actor_animations.ANIMATION_SOUTHEAST )
						actor_anim_head.animation = "normal"
						actor_anim_head.frame = 0
						
					Vector2.UP:							
						actor_anim_body.play( actor_animations.ANIMATION_NORTH )
						actor_anim_head.animation = "normal"
						actor_anim_head.frame = 1
					Vector2.LEFT:						
						actor_anim_body.play( actor_animations.ANIMATION_WEST )
						actor_anim_head.animation = "normal"
						actor_anim_head.frame = 0
					Vector2.DOWN:						
						actor_anim_body.play( actor_animations.ANIMATION_SOUTH )
						actor_anim_head.animation = "normal"
						actor_anim_head.frame = 0
					Vector2.RIGHT:						
						actor_anim_body.play( actor_animations.ANIMATION_EAST )
						actor_anim_head.animation = "normal"
						actor_anim_head.frame = 0
					Vector2.ZERO:						
						pass
					_: # Catch All
						print("Catch all 'input' for %s -> %s " % [name, input])
				
				## Head offset for lookung up and down.
				if actor_anim_head.frame == 0:
					actor_anim_head.offset.x = -14.0
				elif actor_anim_head.frame == 1:
					actor_anim_head.offset.x = -15.0
					
				## Hand animations
				actor_anim_arm_l.play("normal")
				actor_anim_arm_r.play("normal")
				
				## Step Smoke
				if ActorSmokeEmitter:
					ActorSmokeEmitter.emitting = true
	else:
		# AI is not moving the actor anymore
		if actor_animations:
			if actor_anim_body.is_playing():
				actor_anim_body.stop()
			
			# Head sprite
			actor_anim_head.animation = "normal"
			actor_anim_head.frame = 0
			
			# Body sprite
			actor_anim_body.animation = actor_animations.ANIMATION_STAND
			actor_anim_body.frame = 0
			
			# Hand animations
			if actor_anim_arm_l.is_playing(): actor_anim_arm_l.stop()
			if actor_anim_arm_r.is_playing(): actor_anim_arm_r.stop()
			actor_anim_arm_r.frame = RIGHT_ARM_ANIM_FRAME_STAND
			actor_anim_arm_l.frame = LEFT_ARM_ANIM_FRAME_STAND
		
		var curr_direction : Vector2 = input
	
		# Update var
		last_direction = curr_direction
		
	# Update var
	last_input = input

## Correcly flip the 'ActorAnim' according to the input.
## NOTE This flips the scale instead of just flipping the sprite normally
func flip_sprite( input_override := Vector2.ZERO, sprite := ActorAnim ) -> void:
	if not sprite: return ## Safety check
	
	var input := 			curr_input					## Use the current input
	if curr_aim:			input = curr_aim			## Use current aim
	if input_override:		input = input_override		## Use input override
		
	sprite.scale.x = roundf(input.x) ## If going left, flip the sprite
	if roundf(input.x) == 0.0: sprite.scale.x = 1.0 # Avoid 0.0 values.
		
	if roundf(input.y) < 0.0: # needs to be rounded, or else it will flip all the time.
		# If going up, toggle the sprite flip. This is because of how the sprites were created. Check the ActorAnim node.
		sprite.scale.x *= -1.0
		
		# Yeah, just invert it again.
		if invert_north_facing_sprite: 
			sprite.scale.x *= -1.0

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
