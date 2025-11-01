## B2_Shader <- The weird one.
# Applies shaders to the whole screen. Was negleted for a long time.
# NOTE Not sure if this is useful or not. We already have B2_Screen that handles lots of "screen" related stuff.
extends CanvasLayer
const DEBUG := true

func toggle_crt_shader( state : bool ): # toggled by the game settings
	var shader_canvas: 	ColorRect = $shader_canvas
	shader_canvas.visible 	= state
	if DEBUG: print_rich("[color=pink]%s: Shader '%s' is %s." % [name,"shader_canvas",state] )
	
func toggle_ff_shader( state : bool ): # toggled by the B2_Input autoload
	var ff_shader: 		ColorRect = $ff_shader
	ff_shader.visible 		= state
	if DEBUG: print_rich("[color=pink]%s: Shader '%s' is %s." % [name,"ff_shader",state] )
