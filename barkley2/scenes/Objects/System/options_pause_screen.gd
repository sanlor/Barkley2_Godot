@tool
extends Control

signal closed

@onready var window_update_timer: 	Timer 				= $window_update_timer
@onready var options_screen_bg: 	ColorRect 			= $options_screen_bg
@onready var margin_container: 		MarginContainer 	= $options_screen_bg/MarginContainer
@onready var exit_button: 			B2_Button 			= $options_screen_bg/MarginContainer/VBoxContainer/exit_button

@onready var music_minus: 			B2_Button			= $options_screen_bg/MarginContainer/VBoxContainer/music_option/minus
@onready var music_slider: 			B2_Audio_Slider 	= $options_screen_bg/MarginContainer/VBoxContainer/music_option/music_slider
@onready var music_plus: 			B2_Button 			= $options_screen_bg/MarginContainer/VBoxContainer/music_option/plus

@onready var sound_minus: 			B2_Button 			= $options_screen_bg/MarginContainer/VBoxContainer/sound_option/minus
@onready var sound_slider: 			B2_Audio_Slider 	= $options_screen_bg/MarginContainer/VBoxContainer/sound_option/sound_slider
@onready var sound_plus: 			B2_Button 			= $options_screen_bg/MarginContainer/VBoxContainer/sound_option/plus

@onready var crt_button: 			B2_Button 			= $options_screen_bg/MarginContainer/VBoxContainer/filter_option/HBoxContainer/crt_button
@onready var bloom_button: 			B2_Button 			= $options_screen_bg/MarginContainer/VBoxContainer/filter_option/HBoxContainer/bloom_button
@onready var none_button: 			B2_Button 			= $options_screen_bg/MarginContainer/VBoxContainer/filter_option/HBoxContainer/none_button

@onready var fullscreen_button: 	B2_Button 			= $options_screen_bg/MarginContainer/VBoxContainer/fullscreen_option/VBoxContainer/fullscreen_button
@onready var window_button: 		B2_Button 			= $options_screen_bg/MarginContainer/VBoxContainer/fullscreen_option/VBoxContainer/window_button

@onready var _2x_button: 			B2_Button 			= $"options_screen_bg/MarginContainer/VBoxContainer/scaling_option/HBoxContainer/2x_button"
@onready var _3x_button: 			B2_Button 			= $"options_screen_bg/MarginContainer/VBoxContainer/scaling_option/HBoxContainer/3x_button"
@onready var _4x_button: 			B2_Button 			= $"options_screen_bg/MarginContainer/VBoxContainer/scaling_option/HBoxContainer/4x_button"

@onready var scaling_option: 		Label 				= $options_screen_bg/MarginContainer/VBoxContainer/scaling_option

@export var window_size := Vector2(200,200)
@export var window_speed := 0.125
var t : Tween

var update_requested := false

var n_prev_rect := 5
var prev_rect : Array[Rect2] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	crt_button.pressed.connect( 		func(): B2_Config.currentFilter = B2_Config.FILTER.CRT; 	B2_Sound.play( "sn_mouse_select01" );	B2_Config.apply_config() )
	bloom_button.pressed.connect( 		func(): B2_Config.currentFilter = B2_Config.FILTER.BLOOM; 	B2_Sound.play( "sn_mouse_select01" );	B2_Config.apply_config() )
	none_button.pressed.connect( 		func(): B2_Config.currentFilter = B2_Config.FILTER.OFF; 	B2_Sound.play( "sn_mouse_select01" );	B2_Config.apply_config() )
	
	fullscreen_button.pressed.connect( 	func(): B2_Config.fullscreen = B2_Config.ON; 	scaling_option.visible = false;	B2_Sound.play( "sn_digitalselect01" );	B2_Config.apply_config() ) ## The "scale" option should disappear when in fullscreen
	window_button.pressed.connect( 		func(): B2_Config.fullscreen = B2_Config.OFF; 	scaling_option.visible = true;	B2_Sound.play( "sn_digitalselect01" );	B2_Config.apply_config() ) ## The "scale" option should disappear when in fullscreen
	
	_2x_button.pressed.connect( 		func(): B2_Config.screen_scale = B2_Config.SCALE.X2; B2_Sound.play( "sn_mouse_select01" ); 			B2_Config.apply_config() )
	_3x_button.pressed.connect( 		func(): B2_Config.screen_scale = B2_Config.SCALE.X3; B2_Sound.play( "sn_mouse_select01" );			B2_Config.apply_config() )
	_4x_button.pressed.connect( 		func(): B2_Config.screen_scale = B2_Config.SCALE.X4; B2_Sound.play( "sn_mouse_select01" );			B2_Config.apply_config() )
	
	hide()

func _load_settings() -> void:
	music_slider.value = B2_Music.get_volume() * 100
	sound_slider.value = B2_Sound.get_volume() * 100
	
	match B2_Config.currentFilter: ## TODO
		B2_Config.FILTER.CRT:
			crt_button.button_pressed = true
		B2_Config.FILTER.BLOOM:
			bloom_button.button_pressed = true
		B2_Config.FILTER.CRT:
			crt_button.button_pressed = true

	match B2_Config.fullscreen:
		B2_Config.ON:
			fullscreen_button.button_pressed = true
			scaling_option.visible = false
		B2_Config.OFF:
			window_button.button_pressed = true
			scaling_option.visible = true
			
	match B2_Config.screen_scale:
		B2_Config.SCALE.X2:
			_2x_button.button_pressed = true
		B2_Config.SCALE.X3:
			_3x_button.button_pressed = true
		B2_Config.SCALE.X4:
			_4x_button.button_pressed = true

func show_menu() -> void:
	B2_Sound.play( "sn_utilitycursor_buttonclick01" )
	_load_settings()
	prev_rect.clear()
	show()
	window_update_timer.start()
	var center := get_viewport_rect().size / 2.0
	options_screen_bg.position = center
	options_screen_bg.size = Vector2.ZERO
	options_screen_bg.modulate.a = 0.0
	exit_button.disabled = false
	if t: t.kill()
	t = create_tween()
	t.tween_property( self, "modulate:a", 1.0, 0.25 )
	t.tween_property( options_screen_bg, "size", window_size, window_speed )
	t.parallel().tween_property( options_screen_bg, "position", center - window_size / 2.0, window_speed )
	t.tween_property( options_screen_bg, "modulate:a", 1.0, 0.25 )
	t.tween_callback( queue_redraw )
	t.tween_callback( exit_button.grab_focus )
	
func hide_menu() -> void:
	B2_Sound.play( "sn_utilitycursor_buttonclick01" )
	var center := get_viewport_rect().size / 2.0
	options_screen_bg.position = center - window_size / 2.0
	options_screen_bg.size = window_size
	options_screen_bg.modulate.a = 1.0
	exit_button.disabled = true
	if t: t.kill()
	t = create_tween()
	t.tween_property( options_screen_bg, "modulate:a", 0.0, 0.25 )
	t.tween_property( options_screen_bg, "size", Vector2.ZERO, window_speed )
	t.parallel().tween_property( options_screen_bg, "position", center, window_speed )
	t.tween_property( self, "modulate:a", 0.0, 0.25 )
	t.tween_callback( hide )
	#t.tween_callback( closed.emit )
	t.tween_callback( window_update_timer.stop )

func _input(event: InputEvent) -> void:
	if visible:
		if event is InputEventJoypadButton or event is InputEventMouseButton:
			if Input.is_action_just_pressed("Holster"):
				# Improves the gamepad menu navigation
				get_viewport().set_input_as_handled()
				_on_exit_button_pressed()

func _on_exit_button_pressed() -> void:
	closed.emit()

func _on_music_slider_value_changed(value):
	B2_Music.set_volume( value )
func _on_music_minus_pressed():
	music_slider.value -= 5.0
	B2_Sound.play("sn_digitalhover01")
func _on_music_plus_pressed():
	music_slider.value += 5.0
	B2_Sound.play("sn_digitalhover01")

func _on_sound_slider_value_changed(value):
	B2_Sound.set_volume( value )
func _on_sound_minus_pressed():
	sound_slider.value -= 5.0
	B2_Sound.play("sn_digitalhover01")
func _on_sound_plus_pressed():
	sound_slider.value += 5.0
	B2_Sound.play("sn_digitalhover01")

func _draw() -> void:
	if update_requested:
		prev_rect.append( Rect2(options_screen_bg.position - Vector2.ONE, options_screen_bg.size + Vector2(2,2)) )
		for rect in prev_rect:
			draw_rect( rect, Color.GREEN * randf_range(0.55,1.55), false )
		if prev_rect.size() > n_prev_rect:
			prev_rect.pop_front()
		update_requested = false

func _on_timer_timeout() -> void:
	update_requested = true
	queue_redraw()
