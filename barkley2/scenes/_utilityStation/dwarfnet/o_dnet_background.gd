extends TextureRect

@onready var dir_changer: Timer = $dir_changer

## Im terrible with shaders. No idea how to code this with shaders...
## Fuck shaders! lets just move the texture around.
var backdrop_direction = Vector2.RIGHT

func _on_dir_changer_timeout() -> void:
	if visible:
		var dir :=  backdrop_direction.rotated( randf_range(0.0, TAU) )
		var t := create_tween()
		t.tween_property( self, "backdrop_direction", dir, randf_range(2.5, 3.0) )
		await t.finished
	dir_changer.start( 5.0 * randf_range(0.5,2) )

func _physics_process(_delta: float) -> void:
	position.x = wrap( position.x + backdrop_direction.x, -32.0, 0.0 )
	position.y = wrap( position.y + backdrop_direction.y, -32.0, 0.0 )
