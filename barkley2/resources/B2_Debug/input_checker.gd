extends CenterContainer

## Stupid debug script to check how inputs are handled.

@onready var button_a: Sprite2D = $PanelContainer/VBoxContainer/button_a
@onready var button_b: Sprite2D = $PanelContainer/VBoxContainer/button_b
@onready var button_x: Sprite2D = $PanelContainer/VBoxContainer/button_x
@onready var button_y: Sprite2D = $PanelContainer/VBoxContainer/button_y
@onready var button_lb: Sprite2D = $PanelContainer/VBoxContainer/button_lb
@onready var button_rb: Sprite2D = $PanelContainer/VBoxContainer/button_rb
@onready var button_lt: Sprite2D = $PanelContainer/VBoxContainer/button_lt
@onready var analog_right: Sprite2D = $PanelContainer/VBoxContainer/analog_right
@onready var analog_left: Sprite2D = $PanelContainer/VBoxContainer/analog_left
@onready var button_rt: Sprite2D = $PanelContainer/VBoxContainer/button_rt
@onready var button_select: Sprite2D = $PanelContainer/VBoxContainer/button_select
@onready var button_start: Sprite2D = $PanelContainer/VBoxContainer/button_start
@onready var arrow_up: Sprite2D = $PanelContainer/VBoxContainer/arrow_up
@onready var arrow_right: Sprite2D = $PanelContainer/VBoxContainer/arrow_right
@onready var arrow_down: Sprite2D = $PanelContainer/VBoxContainer/arrow_down
@onready var arrow_left: Sprite2D = $PanelContainer/VBoxContainer/arrow_left

@onready var input_name: Label = $PanelContainer/VBoxContainer/input_name
@onready var input_name_2: Label = $PanelContainer/VBoxContainer/input_name2
@onready var input_type: Label = $PanelContainer/VBoxContainer/input_type

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventJoypadButton:
		input_name.text = str( event.button_index )
	if event is InputEventKey:
		input_name_2.text = str( event.as_text_key_label() )

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if visible:
		if B2_Input.curr_CONTROL == B2_Input.CONTROL.GAMEPAD:
			input_type.text = "GAMEPAD"
		else:
			input_type.text = "KEYBOARD"
			
		button_a.modulate = Color.WHITE.lerp( Color.PINK, float( Input.is_joy_button_pressed(0,JOY_BUTTON_A) ) * 3.0 )
		button_b.modulate = Color.WHITE.lerp( Color.PINK, float( Input.is_joy_button_pressed(0,JOY_BUTTON_B) ) * 3.0 )
		button_x.modulate = Color.WHITE.lerp( Color.PINK, float( Input.is_joy_button_pressed(0,JOY_BUTTON_X) ) * 3.0 )
		button_y.modulate = Color.WHITE.lerp( Color.PINK, float( Input.is_joy_button_pressed(0,JOY_BUTTON_Y) ) * 3.0 )
		
		button_lb.modulate = Color.WHITE.lerp( Color.PINK, float( Input.is_joy_button_pressed(0,JOY_BUTTON_LEFT_SHOULDER) ) * 3.0 )
		button_rb.modulate = Color.WHITE.lerp( Color.PINK, float( Input.is_joy_button_pressed(0,JOY_BUTTON_RIGHT_SHOULDER) ) * 3.0 )
		button_lt.modulate = Color.WHITE.lerp( Color.PINK, float( Input.get_joy_axis(0,JOY_AXIS_TRIGGER_LEFT) ) * 3.0 )
		button_rt.modulate = Color.WHITE.lerp( Color.PINK, float( Input.get_joy_axis(0,JOY_AXIS_TRIGGER_RIGHT) ) * 3.0 )
		
		analog_left.offset = Vector2( Input.get_joy_axis(0, JOY_AXIS_LEFT_X), Input.get_joy_axis(0, JOY_AXIS_LEFT_Y) ) * 10.0
		analog_right.offset = Vector2( Input.get_joy_axis(0, JOY_AXIS_RIGHT_X), Input.get_joy_axis(0, JOY_AXIS_RIGHT_Y) ) * 10.0
		
		analog_left.modulate = Color.WHITE.lerp( Color.PINK, float( Input.is_joy_button_pressed(0,JOY_BUTTON_LEFT_STICK) ) * 3.0 )
		analog_right.modulate = Color.WHITE.lerp( Color.PINK, float( Input.is_joy_button_pressed(0,JOY_BUTTON_RIGHT_STICK) ) * 3.0 )
		
		button_select.modulate = Color.WHITE.lerp( Color.PINK, float( Input.is_joy_button_pressed(0,JOY_BUTTON_BACK) ) * 3.0 )
		button_start.modulate = Color.WHITE.lerp( Color.PINK, float( Input.is_joy_button_pressed(0,JOY_BUTTON_START) ) * 3.0 )
		
		arrow_up.modulate = Color.WHITE.lerp( Color.PINK, float( Input.is_joy_button_pressed(0,JOY_BUTTON_DPAD_UP) ) * 3.0 )
		arrow_down.modulate = Color.WHITE.lerp( Color.PINK, float( Input.is_joy_button_pressed(0,JOY_BUTTON_DPAD_DOWN) ) * 3.0 )
		arrow_left.modulate = Color.WHITE.lerp( Color.PINK, float( Input.is_joy_button_pressed(0,JOY_BUTTON_DPAD_LEFT) ) * 3.0 )
		arrow_right.modulate = Color.WHITE.lerp( Color.PINK, float( Input.is_joy_button_pressed(0,JOY_BUTTON_DPAD_RIGHT) ) * 3.0 )


func _on_visibility_changed() -> void:
	if visible:
		Input.start_joy_vibration(0, 0.0,1.0, 1.0)
