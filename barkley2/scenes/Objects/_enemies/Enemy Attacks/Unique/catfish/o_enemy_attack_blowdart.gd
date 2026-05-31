## Dart Node
# A cheap version of a bullet.
extends Node2D

const S_EFFECT_SLUDGE_DRIP 		= preload("uid://bnbunxj15a4q1")

var gravity 		:= 0.025
var inaccuracy		:= 8.0

@onready var dart: AnimatedSprite2D = $dart

var my_shooter		: B2_CombatActor
var my_target 	:= Vector2.ZERO
var my_dir		:= Vector2.ZERO
var dart_rotation := 0.0
	
func set_target( _my_target : Vector2 ) -> void:
	my_target = _my_target
	my_dir = global_position.direction_to( my_target)
	my_target += my_dir * randf() * 2.0 # overshooting target
	dart_rotation = my_dir.lerp( my_target + Vector2.DOWN, 0.25 ).angle()
	
func _ready() -> void:
	gravity *= randf_range( 0.5, 3.0 )
	dart.rotation = ( position.direction_to(my_target) ).angle()
	
func _physics_process(_delta: float) -> void:
	position = position.lerp( my_target, 0.175 )
	dart.rotation = Vector2.from_angle(dart.rotation).move_toward( Vector2.DOWN, gravity).angle()
	
	## TODO collision logic
	var space	:= get_world_2d().direct_space_state
	var query 	:= PhysicsPointQueryParameters2D.new()
	query.position = global_position
	query.collision_mask 		= 0b00000000_00000000_00000000_00001111
	var coll 	:= space.intersect_point( query )
	if coll:
		for body_dict in coll:
			var body = body_dict.get("collider")
			if body is B2_CombatActor and not body == my_shooter:
				print("hit %s" % body.name)
				_hit( body )
				break
				
			elif body is TileMap:
				_hit()
				
				## Handle the dart jitting on different surfaces
				if not check_for_water():
					# fell in water
					var drip = S_EFFECT_SLUDGE_DRIP.instantiate()
					add_sibling( drip, true )
					drip.global_position = global_position
					set_physics_process(false)
					queue_free()
					return
				elif not check_for_abyss():
					set_physics_process(false)
					queue_free()
					return
					
				break
			else:
				print( body)
		_hit()
	
	if position.distance_to(my_target) < 05.0:
		_hit()

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

func _hit( body : B2_CombatActor = null ) -> void:
	if body:
		body.damage_actor( 5.0, my_dir * 50.0 )
		print("DEBUG: Dart damage with TEMP values.")
		queue_free()
	else:
		dart.animation = "hit"
		set_physics_process( false )
