#@tool
extends TextureRect

@onready var dir_changer: Timer = $dir_changer

## Im terrible with shaders. No idea how to code this with shaders...
## Fuck shaders! lets just move the texture around.
var backdrop_direction = Vector2.RIGHT
var enable_alt_bg := false

func _ready() -> void:
	backdrop_direction = backdrop_direction.rotated( randf_range(0.0, TAU) )

func _on_dir_changer_timeout() -> void:
	if visible:
		var dir :=  backdrop_direction.rotated( randf_range(0.0, TAU) )
		var t := create_tween()
		t.set_parallel(true)
		t.tween_property( self, "backdrop_direction", dir, randf_range(2.5, 4.0) )
		if enable_alt_bg:
			if randf() > 0.75:
				t.tween_method(texture_ratio, get_texture_ratio(), 0.0, 4.0)
			else:
				t.tween_method(texture_ratio, get_texture_ratio(), 1.0, 4.0)
		await t.finished
	dir_changer.start( 5.0 * randf_range(0.85, 3.0) )

func texture_ratio( ratio : float ) -> void:
	material.set_shader_parameter( "transform_ratio", ratio )

func get_texture_ratio() -> float:
	return material.get_shader_parameter( "transform_ratio" )

func _physics_process(_delta: float) -> void:
	position.x = wrap( position.x + backdrop_direction.x, -32.0, 0.0 )
	position.y = wrap( position.y + backdrop_direction.y, -32.0, 0.0 )
