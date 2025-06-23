extends Control

signal finished_animation( abort : bool )

const high_color 		:= Color8(90, 110, 150)
const normal_color 		:= Color8(110, 130, 190)

@onready var user_field: 		ColorRect = $user_field
@onready var password_field: 	ColorRect = $password_field

@onready var user_input: Label = $user_field/user_input
@onready var pass_input: Label = $password_field/pass_input

@onready var exit_btn: Button = $exit_btn
@onready var register_btn: Button = $register_btn

enum {USER,PASS,CONFIRMATION}
var curr_mode := USER

func begin_animation() -> void:
	user_field.grab_focus()
	user_input.visible_characters 		= 0
	pass_input.visible_characters 		= 0
	
func finish_animation() -> void:
	hide()
	
func advance_input() -> void:
	match curr_mode:
		USER:
			user_input.visible_characters += 1
			if user_input.visible_ratio == 1.0:
				user_field.focus_mode 		= Control.FOCUS_NONE
				user_field.release_focus()
				password_field.focus_mode 	= Control.FOCUS_ALL
				password_field.grab_focus()
				
				curr_mode = PASS
		PASS:
			pass_input.visible_characters += 1
			if pass_input.visible_ratio == 1.0:
				password_field.release_focus()
				password_field.focus_mode 	= Control.FOCUS_NONE
				exit_btn.focus_mode 		= Control.FOCUS_ALL
				register_btn.focus_mode 	= Control.FOCUS_ALL
				exit_btn.disabled 			= false
				register_btn.disabled 		= false
				exit_btn.grab_focus()
				
				curr_mode = CONFIRMATION
			
	
func _input(event: InputEvent) -> void:
	if event is InputEventKey or event is InputEventJoypadButton:
		if event.is_pressed():
			advance_input()
	
var t := 0.0 ## Blink time
func _physics_process(delta: float) -> void:
	if visible:
		if t <= 0.0:
			t = 2.0
			if user_field.has_focus():
				if user_field.color == normal_color: user_field.color = high_color
				else: user_field.color = normal_color
			else: user_field.color = normal_color
			
			if password_field.has_focus():
				if password_field.color == normal_color: password_field.color = high_color
				else: password_field.color = normal_color
			else: password_field.color = normal_color
		else:
			t -= 10 * delta

func _on_register_btn_pressed() -> void:
	finished_animation.emit( true )
	finish_animation()

func _on_exit_btn_pressed() -> void:
	finished_animation.emit( false )
	finish_animation()
