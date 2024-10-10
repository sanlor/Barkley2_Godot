extends Node2D

const BROKEN_GLASS = preload("res://barkley2/resources/misc/broken_glass.tres")

func _ready() -> void:
	queue_redraw()
	
func _draw() -> void:
	for i in 20:
		var tex = BROKEN_GLASS.duplicate() as AtlasTexture
		tex.region.position.x = randi_range( 0, 19 )
		draw_texture( tex, Vector2(0, i * 4) - Vector2( 4, 10 * 4 ) )
		
