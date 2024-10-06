extends CanvasLayer

@onready var shader_canvas: 	ColorRect = $shader_canvas
@onready var ff_shader: 		ColorRect = $ff_shader

func toggle_crt_shader( state : bool ):
	shader_canvas 			= $shader_canvas
	shader_canvas.visible 	= state
	
func toggle_ff_shader( state : bool ): # toggled by the B2_Input autoload
	ff_shader 				= $ff_shader
	ff_shader.visible 		= state
