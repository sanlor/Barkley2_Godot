extends TextureRect

@onready var dir_changer: Timer = $dir_changer

## Im terrible with shaders. No idea how to code this with shaders...
var backdrop_direction = Vector2.RIGHT;
var backdrop_speed = randf();

var prev_dir : Vector2
func _on_dir_changer_timeout() -> void:
	if visible:
		prev_dir = material.get_shader_parameter("dir")
		var t := create_tween()
		#t.set_parallel( true )
		t.tween_method( change_dir, prev_dir, backdrop_direction.rotated( randf_range(0.0, TAU) ), 2.0 )
		#t.tween_property( self, "material:shader_parameter/speed", randf_range(0.0, 1.0), randf_range(0.1, 3.0) )
		await t.finished
	dir_changer.start( 5.0 * randf_range(0.5,2) )
	
func change_dir( dir : Vector2 ) -> void:
	material.set_shader_parameter( "dir", dir )
	
func change_speed( speed : float ) -> void:
	material.set_shader_parameter( "speed", speed )
