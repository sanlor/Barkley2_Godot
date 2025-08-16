extends Area2D
## Simmilar to casing and such.
# An object is trown. if hits something, it damages it.

const S_EFFECT_SLUDGE_DRIP = preload("uid://bnbunxj15a4q1")

@onready var object_sprite: Sprite2D = $object_sprite
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

var velocity 			:= Vector2()
var angular_velocity 	:= 0.0

var obj_gravity			:= 98.0 * 3.0
var upward_velocity 	:= 0.0

var original_y			:= 0.0

var hit_the_floor		:= false ## Object hit nothing and fell to the floor
var hit_something		:= false ## Object hit something solid.

var damage_amount		:= 1.0

func _ready() -> void:
	angular_velocity 	= randf_range(-35, 35) ## Speen
	upward_velocity 	= 100 ## How high the casings initially can go.

func setup( dir : Vector2, sprite : Texture2D ) -> void:
	velocity = dir.normalized() * 225.0
	object_sprite.texture = sprite

func check_for_water() -> bool:
	if get_parent() is B2_ROOMS:
		var room : B2_ROOMS = get_parent()
		return not room.check_tilemap_collision( global_position, 20 ) ## 20 is wading
	return true
	
func check_for_abyss() -> bool:
	if get_parent() is B2_ROOMS:
		var room : B2_ROOMS = get_parent()
		return not room.check_tilemap_collision( global_position, 19 ) ## 19 is abyss
	return true

func _physics_process(delta: float) -> void:
	position 			+= velocity * delta
	
	if not hit_the_floor:
		object_sprite.rotation 			+= angular_velocity * delta
		object_sprite.position.y 		-= upward_velocity * delta
		upward_velocity 				-= obj_gravity * delta
	
	## object hit the floor. Should be destroyed.
	if object_sprite.global_position.y > global_position.y:
		if hit_the_floor or hit_something:
			return
		z_index = 0
		object_sprite.global_position.y = global_position.y
		
		
		if not check_for_water():
			# fell in water
			var drip = S_EFFECT_SLUDGE_DRIP.instantiate()
			add_sibling( drip, true )
			drip.global_position = global_position
			queue_free()
		elif not check_for_abyss():
			queue_free()
		else:
			destroy_object( false )
			B2_Sound.play("general_impact")
				
	else:
		z_index = 1

func destroy_object( hit : bool ) -> void:
	if hit: hit_something = true; angular_velocity 	= randf_range(-75, 75); upward_velocity = 200
	else: hit_the_floor = true
	velocity = Vector2.ZERO
	
	var t := create_tween()
	t.tween_property( self, "modulate", Color.BLACK, 0.15 )
	t.tween_property( self, "modulate", Color.TRANSPARENT, 0.25 )
	t.tween_callback( queue_free )

func _on_body_entered(body: Node2D) -> void:
	if body is B2_PlayerCombatActor:
		return
		
	if body is B2_CombatActor:
		body.damage_actor( 500.0 * damage_amount, velocity.normalized() * 2000.0 )
		destroy_object( true )
		B2_Sound.play("slash_impact")
	if body is TileMapLayer:
		destroy_object( false )
		B2_Sound.play("general_impact")
	else:
		destroy_object( true )
		B2_Sound.play("general_impact")
