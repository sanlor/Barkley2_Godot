extends Node2D
## Generic Gibs object for defeated enemies.

@onready var part_sprite		: AnimatedSprite2D 		= $part_sprite
@onready var gib_life_timer		: Timer 				= $gib_life_timer
@onready var gib_sfx			: AudioStreamPlayer2D 	= $gib_sfx

var dir := Vector2.RIGHT.rotated( randf_range( -PI, PI ) )

## sound used when the gib bonces on the ground or the wall.
var splatSound := ""
var gib_sprite := ""
var sprite_set := 0

## how many times the gib can bounce on the ground.
var bounces = [1,2,2,3,3,3].pick_random()

## ??????
var bloodburst = "s_fx_bloodBurst"

## Code stolen from o_casing
var velocity 			:= Vector2()
var angular_velocity 	:= 0.0
var friction 			:= 0.985
var bounce 				:= -0.65

var gravity 			:= 98.0 * 6.0
var upward_velocity 	:= 0.0

var original_y			:= 0.0

var is_active := true

func _ready() -> void:
	# Set the initial velocity of the bullet casing
	velocity 			= dir * randf_range( 50.0, 150.0 )
	angular_velocity 	= randf_range(-15, 15) ## Speen
	upward_velocity 	= randf_range(150,350) ## How high the gib initially can go.
	
	gib_life_timer.start( gib_life_timer.wait_time * randf_range( 0.6, 2.0 ) )
	gib_life_timer.timeout.connect( cleanup )
	
	## set a random sprite
	part_sprite.frame = randi_range( 0, part_sprite.sprite_frames.get_frame_count( part_sprite.animation ) )
	
	if splatSound: gib_sfx.stream = load( B2_Sound.get_sound( splatSound ) )

	
func _physics_process( delta: float ) -> void:
	position 			+= velocity * delta
	
	part_sprite.rotation 		+= angular_velocity * delta
	part_sprite.position.y 		-= upward_velocity * delta
	upward_velocity 			-= gravity * delta
	
	## gib hit the floor. should bounce back and lose some velocity
	if part_sprite.global_position.y > global_position.y:
		z_index = 0
		if splatSound: gib_sfx.play()
		
		part_sprite.global_position.y = global_position.y
		
		bounces -= 1 ## Stop bouncing
		if bounces <= 0:
			velocity = Vector2.ZERO
		
		if velocity.length() < 8.0:
			## gib basically stopped bouncing. stop processing.
			set_process( false )
			set_physics_process( false )
			return
		else:
			#velocity			*= bounce
			upward_velocity 	*= bounce
			angular_velocity 	*= bounce
			
	else:
		z_index = 1
		
	velocity 			*= friction
	angular_velocity 	*= friction

func cleanup() -> void:
	var t := create_tween()
	t.tween_property( self, "modulate", Color.TRANSPARENT, randf_range( 8.0, 16.0 ) )
	t.tween_callback( queue_free )
