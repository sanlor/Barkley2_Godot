extends Node2D
## visual effect of a blood drop. similar to a bullet casing, without bouncing.
# Check scr_player_hitfxHook line 81

@onready var spr: 			Sprite2D 			= $spr
@onready var spr_shadow: 	Sprite2D 			= $spr_shadow
@onready var puddle: 		AnimatedSprite2D 	= $puddle

var velocity 			:= Vector2()
var friction 			:= 0.99

var velocity_mod := 1.0

var gravity 			:= 98.0 * 1.0
var upward_velocity 	:= 0.0

var original_y			:= 0.0

var is_active := true

## Puddle Setup
var puddle_color := Color.RED

func _ready() -> void:
	# Set the initial velocity of the bullet casing
	velocity 			= Vector2.DOWN.rotated( randf_range( 0, TAU ) ) * randf_range( 0.0, 40.0 ) * velocity_mod
	upward_velocity 	= randf_range(20,100) * velocity_mod ## How high the blood splatter initially can go.
	spr.scale = Vector2(0.5,0.5) * randf_range( 0.8, 1.6 )
	spr_shadow.scale = spr.scale
	
	puddle.hide()
	puddle.speed_scale = randf_range( 0.6, 1.0 ) # 0.95 + randf_range(0.0,0.45)
	puddle.modulate = puddle_color
	puddle.modulate.a = randf_range( 0.50, 0.85 ) # 0.75
	puddle.scale = Vector2.ONE * randf_range(0.85,1.35)
	
	var temp := randi_range(0,99)
	if temp <= 35:
		puddle.animation = "s_effect_puddle_small01"
	elif temp <= 55:
		puddle.animation = "s_effect_puddle_small02"
	else:
		puddle.animation = "s_effect_puddle_small03"

func _physics_process(delta: float) -> void:
	if is_active:
		position 			+= velocity * delta
		
		spr.position.y 		-= upward_velocity * delta
		upward_velocity 	-= gravity * delta
		
		## blood hit the floor. hide the blood drop and show the puddle.
		if spr.global_position.y > global_position.y:
			z_index = 0
			spr.global_position.y = global_position.y
			spr.hide()
			spr_shadow.hide()
			puddle.show()
			puddle.play()
			set_process( false )
			set_physics_process( false )
			is_active = false
		else:
			z_index = 1
			
		velocity 			*= friction

func cleanup() -> void:
	var t := create_tween()
	t.tween_property( self, "modulate", Color.TRANSPARENT, randf_range( 8.0, 16.0 ) )
	t.tween_callback( queue_free )

func _on_puddle_animation_finished() -> void:
	#cleanup()
	## or...
	queue_free()
