## B2_Shader <- The weird one.
# Applies shaders to the whole screen. Was negleted for a long time.
extends CanvasLayer
const DEBUG := true



func toggle_rain_shader( state : bool ):
	var rain_shader: 		ColorRect = $rain_shader
	rain_shader.visible = state
	if DEBUG: print_rich("[color=pink] shader '%s' is %s." % ["rain_shader",state] )

func toggle_fog_shader( state : bool ):
	var fog_shader: 		ColorRect = $fog_shader
	fog_shader.visible = state
	if DEBUG: print_rich("[color=pink] shader '%s' is %s." % ["fog_shader",state] )

func toggle_crt_shader( state : bool ):
	var shader_canvas: 	ColorRect = $shader_canvas
	shader_canvas.visible 	= state
	if DEBUG: print_rich("[color=pink] shader '%s' is %s." % ["shader_canvas",state] )
	
func toggle_ff_shader( state : bool ): # toggled by the B2_Input autoload
	var ff_shader: 		ColorRect = $ff_shader
	ff_shader.visible 		= state
	if DEBUG: print_rich("[color=pink] shader '%s' is %s." % ["ff_shader",state] )

func _process(_delta: float) -> void:
	if is_node_ready():
		if $fog_shader.visible:
			if B2_CManager.camera: ## FIXME 
				$fog_shader.material.set_shader_parameter( "camera_position", B2_CManager.camera.global_position )
				$fog_shader.material.set_shader_parameter( "camera_offset", B2_CManager.camera.offset )
		#if $rain_shader.visible:
			#if B2_CManager.camera: ## FIXME 
				#$rain_shader.material.set_shader_parameter( "camera_position", B2_CManager.camera.global_position )
				#$rain_shader.material.set_shader_parameter( "camera_offset", B2_CManager.camera.offset )
