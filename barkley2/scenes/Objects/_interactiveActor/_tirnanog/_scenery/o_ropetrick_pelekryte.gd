@tool
extends Node2D

@onready var path_2d: Path2D = $Path2D
@onready var rope_line: Line2D = $rope_line
@onready var actor_anim: AnimatedSprite2D = $ActorAnim

var pRopePelekryte := [
	Vector2(0,0),
	Vector2(0,-8),
	Vector2(8,-8),
	Vector2(16,16),
	Vector2(40,16),
	Vector2(40,8),
	Vector2(16,8),
	Vector2(16,0),
	Vector2(40,0),
	Vector2(40,-8),
	Vector2(16,-8),
	Vector2(16,-16),
	Vector2(40,-16),
	Vector2(40,-24),
	Vector2(16,-24),
	Vector2(16,-32),
	Vector2(40,-32),
	Vector2(40,-40),
	Vector2(16,-40),
	Vector2(16,-48),
	Vector2(40,-48),
	Vector2(40,-56),
	Vector2(16,-56),
	Vector2(16,-64),
	Vector2(40,-64),
	Vector2(40,-72),
	Vector2(16,-72),
	Vector2(16,-80),
	Vector2(40,-80),
	Vector2(40,-88),
	Vector2(16,-88),
	Vector2(16,-96)]
	
@export_tool_button("set") var a : Callable = _a

func _a():
	path_2d.curve.clear_points()
	for i in pRopePelekryte:
		path_2d.curve.add_point(i)
		
func _ready() -> void:
	rope_line.clear_points()
	var points := path_2d.curve.get_baked_points()
	var index := 0
	for i in points:
		rope_line.add_point( i, 0 )
		if index > 50:
			actor_anim.position = Vector2( 243.0, 215.0 ) + i
		index += 1
		await get_tree().physics_frame
	
	var index_2 := points.size()
	for i in points:
		index_2 -= 1
		rope_line.remove_point( index_2 )
		await get_tree().physics_frame
