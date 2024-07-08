extends CanvasLayer

@onready var shader_canvas = $shader_canvas

func toggle_crt_shader( state : bool ):
	shader_canvas = $shader_canvas
	shader_canvas.visible = state
