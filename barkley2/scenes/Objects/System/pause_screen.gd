extends CanvasLayer

@onready var resume: Button 				= $pause_screen/resume
@onready var button_bg_resume: TextureRect 	= $pause_screen/resume/button_bg_resume
@onready var exit: Button 					= $pause_screen/exit
@onready var button_bg_exit: TextureRect 	= $pause_screen/exit/button_bg_exit

var time := 0.0

func _ready() -> void:
	layer = B2_Config.PAUSE_LAYER
	get_tree().paused = true
	show()
	
	resume.mouse_entered.connect( 	button_bg_resume.show )
	resume.focus_entered.connect( 	button_bg_resume.show )
	resume.mouse_exited.connect( 	button_bg_resume.hide )
	resume.focus_exited.connect( 	button_bg_resume.hide )
	exit.mouse_entered.connect( 	button_bg_exit.show )
	exit.focus_entered.connect( 	button_bg_exit.show )
	exit.mouse_exited.connect( 		button_bg_exit.hide )
	exit.focus_exited.connect( 		button_bg_exit.hide )
	
	exit.pressed.connect( 		B2_Screen.return_to_title )
	resume.pressed.connect( 	B2_Screen.hide_pause_menu )
	
	resume.grab_focus()

func _exit_tree() -> void:
	hide()

func _process(delta: float) -> void:
	## Pause screen stuff
	time += 3.5 * delta
	
	var alpha := ( sin(time) + PI ) / TAU
	button_bg_resume.self_modulate.a 	= alpha
	button_bg_exit.self_modulate.a 		= alpha
