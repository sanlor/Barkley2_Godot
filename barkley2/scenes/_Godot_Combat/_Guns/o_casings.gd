extends Node2D
## Bullet casings.
## NOTE Not all guns have bullet casings.

@onready var spr: Sprite2D = $spr

## Sound
var bounce_soundid := ""

var velocity 			:= Vector2()
var angular_velocity 	:= 0.0
var friction 			:= 0.98
var bounce 				:= -0.35

var gravity 			:= 98.0 * 4.0
var upward_velocity 	:= 0.0

var original_y			:= 0.0

var is_active := true

func _ready() -> void:
	# Set the initial velocity of the bullet casing
	velocity 			= Vector2.DOWN.rotated( randf_range(-PI/6, PI/6) ) * randf_range( 50.0, 150.0 ) ## Casings fly mostly downward
	angular_velocity 	= randf_range(-15, 15) ## Speen
	upward_velocity 	= randf_range(50,210) ## How high the casings initially can go.
	#position.y += 16.0

func setup( _bounce_soundid : String, _scale : float, _speed : float, _color : Color ) -> void:
	bounce_soundid = _bounce_soundid
	scale *= _scale ## 0.5 seems to be the default
	## TODO speed
	modulate = _color

func cleanup() -> void:
	var t := create_tween()
	t.tween_property( self, "modulate", Color.TRANSPARENT, randf_range( 0, 1 ) )
	t.tween_callback( queue_free )

func _physics_process(delta: float) -> void:
	position 			+= velocity * delta
	
	spr.rotation 		+= angular_velocity * delta
	spr.position.y 		-= upward_velocity * delta
	
	upward_velocity 	-= gravity * delta
	
	## casing hit the floor. should bounce back and lose some velocity
	if spr.global_position.y > global_position.y:
		z_index = 0
		B2_Sound.play_pick( bounce_soundid )
		
		velocity			*= bounce
		upward_velocity 	*= bounce
		angular_velocity 	*= bounce
		
		spr.global_position.y = global_position.y
		if upward_velocity > -8 and upward_velocity < 8:
			## Bullet basically stopped bouncing. stop processing.
			set_process( false )
			set_physics_process( false )
			return
	else:
		z_index = 1
		
	velocity 			*= friction
	angular_velocity 	*= friction
