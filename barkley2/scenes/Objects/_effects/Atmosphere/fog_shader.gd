extends ColorRect

const DEBUG := true

func _ready() -> void:
	toggle_fog_shader( true )

func toggle_fog_shader( state : bool ): # toggled by the current room settings
	visible = state
	if DEBUG: print_rich("[color=pink]%s: Shader '%s' is %s." % [name,"fog_shader",state] )

func _process(_delta: float) -> void:
	if is_node_ready():
		if visible:
			if B2_CManager.camera: ## FIXME 
				material.set_shader_parameter( "camera_position", B2_CManager.camera.global_position )
				material.set_shader_parameter( "camera_offset", B2_CManager.camera.offset )
				position = B2_CManager.camera.position - Vector2(384.0,240.0) / 2.0
				position += B2_CManager.camera.offset
