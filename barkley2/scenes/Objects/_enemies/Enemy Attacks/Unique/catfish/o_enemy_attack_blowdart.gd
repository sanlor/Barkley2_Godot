## Dart Node
# A cheap version of a bullet.
extends Node2D

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
				break
			else:
				print( body)
		_hit()
	
	if position.distance_to(my_target) < 05.0:
		_hit()

func _hit( body : B2_CombatActor = null ) -> void:
	if body:
		body.damage_actor( 5.0, my_dir * 50.0 )
		print("DEBUG: Dart damage with TEMP values.")
		queue_free()
	else:
		dart.animation = "hit"
		set_physics_process( false )
