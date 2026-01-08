#extends CanvasLayer
extends Control

@onready var resume: 				Button 				= $pause_screen/VBoxContainer/resume
@onready var button_bg_resume: 		TextureRect 		= $pause_screen/VBoxContainer/resume/button_bg_resume
@onready var exit: 					Button 				= $pause_screen/VBoxContainer/exit
@onready var button_bg_exit: 		TextureRect 		= $pause_screen/VBoxContainer/exit/button_bg_exit
@onready var options: 				Button 				= $pause_screen/VBoxContainer/options
@onready var button_bg_options: 	TextureRect 		= $pause_screen/VBoxContainer/options/button_bg_options

@onready var options_screen: 		Control 			= $pause_screen/options_screen
@onready var pause_container: 		VBoxContainer 		= $pause_screen/VBoxContainer

var time := 0.0

var tween : Tween

func _ready() -> void:
	#layer = B2_Config.PAUSE_LAYER
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
	
	options.mouse_entered.connect( 	button_bg_options.show )
	options.focus_entered.connect( 	button_bg_options.show )
	options.mouse_exited.connect( 	button_bg_options.hide )
	options.focus_exited.connect( 	button_bg_options.hide )
	
	exit.pressed.connect( 			B2_Screen.return_to_title 	)
	resume.pressed.connect( 		B2_Screen.hide_pause_menu 	)
	options.pressed.connect(		show_options				)
	options_screen.closed.connect( 	hide_options				)
	
	resume.grab_focus()

func _exit_tree() -> void:
	hide()

func show_options() -> void:
	pause_container.show()
	pause_container.modulate = Color.WHITE
	
	if tween: tween.kill()
	tween = create_tween()
	tween.tween_callback( options.release_focus )
	tween.tween_property( pause_container, "modulate", Color.TRANSPARENT, 0.125 )
	tween.tween_callback( pause_container.hide )
	options_screen.show_menu()
	
func hide_options() -> void:
	pause_container.hide()
	pause_container.modulate = Color.TRANSPARENT
	
	if tween: tween.kill()
	tween = create_tween()
	tween.tween_callback( pause_container.show )
	tween.tween_property( pause_container, "modulate", Color.WHITE, 0.125 )
	tween.tween_callback( options.grab_focus )
	options_screen.hide_menu()

func _process(delta: float) -> void:
	## Pause screen stuff
	time += 3.5 * delta
	
	var alpha := ( sin(time) + PI ) / TAU
	button_bg_resume.self_modulate.a 	= alpha
	button_bg_exit.self_modulate.a 		= alpha


func _on_resume_mouse_entered() -> void:
	resume.grab_focus()

func _on_options_mouse_entered() -> void:
	options.grab_focus()

func _on_exit_mouse_entered() -> void:
	exit.grab_focus()
