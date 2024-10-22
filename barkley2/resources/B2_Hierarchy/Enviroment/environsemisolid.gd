extends B2_Environ
class_name B2_EnvironSemisolid

var EnvSolid				: StaticBody2D
var EnvCol					: CollisionShape2D

@export var shape 			:= SHAPES.CIRCLE
@export var circle_radius 	:= 10
@export var square_size 	:= Vector2(10,10)

func _enter_tree() -> void:
	make_collision()
	
func make_collision():
	EnvCol = CollisionShape2D.new()
	EnvSolid = StaticBody2D.new()
	match shape:
		SHAPES.CIRCLE:
			var s := CircleShape2D.new()
			s.radius = circle_radius
			EnvCol.shape = s
		SHAPES.SQUARE:
			var s := RectangleShape2D.new()
			s.size = square_size
			EnvCol.shape = s
		_:
			breakpoint # ??? Weird shape
	add_child(EnvSolid, true)
	EnvSolid.add_child(EnvCol, true)
	
func disable( state : bool ):
	EnvCol.disabled = state
