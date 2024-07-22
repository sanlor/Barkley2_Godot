@tool
extends Control

## This one is pretty simple. Still took me about 4 hours.
# The original code says this code is about gender selection. maybe some copy pasted code?

signal accept_pressed

@onready var blood_frame_bg = $blood_frame_bg
@onready var blood_frame = $blood_frame
@onready var accept_btn = $accept_btn

@onready var accept_btn_bg = $accept_btn_bg

const CC_BLOOD_BUTTON = preload("res://barkley2/scenes/CC/cc_blood_button.tscn")

var option_selected := 0
var blood_options := ["Blood A", "Blood B", "Blood AB", "Blood O", "10w-30", "Corn syrup"]
var blood_checkbox := []

var accept_is_hovering := false

func _ready():
	blood_frame_bg.color = Color(0.235, 0, 0.353, 0.5)
	blood_frame_bg.global_position = Vector2(132, 44)
	blood_frame_bg.size = Vector2(119, 137)
	
	accept_btn_bg.global_position = Vector2(162, 188)
	accept_btn_bg.mouse_entered.connect( func(): accept_is_hovering = true )
	accept_btn_bg.mouse_exited.connect( func(): accept_is_hovering = false )
	
	blood_frame.global_position = Vector2(120, 24)
	accept_btn.global_position = Vector2(192, 200) - (accept_btn.size / 2)
	
	for i in 6:
		var label := Label.new()
		add_child( label )
		label.global_position = Vector2( 169, 52 + i * 20 )
		label.text = blood_options[i]
		
		var check := CC_BLOOD_BUTTON.instantiate()
		add_child( check )
		check.global_position = Vector2(144, 52 + i * 20)
		check.modulate.a = 0.0
		check.pressed.connect( toggle_buttons )
		blood_checkbox.append(check)
		
		modulate.a = 0
		var tween := create_tween()
		tween.tween_property(self, "modulate:a", 1.0, 1.0)
		
func _process(_delta):
	if accept_is_hovering:
		accept_btn_bg.color = Color(0.157, 0.745, 0.98, 0.5)
		if Input.is_action_just_pressed("Action"):
			#is_selected = true
			
			accept_blood()
	else:
		accept_btn_bg.color = Color(0.235, 0, 0.353, 0.5)
		
func accept_blood():
	var selected := INF
	var index := 0
	
	for sel in blood_checkbox:
		if sel.is_selected:
			selected = index
		index += 1
	
	if selected < blood_checkbox.size():
		@warning_ignore("narrowing_conversion")
		option_selected = selected
		B2_Playerdata.character_blood = option_selected
		B2_Sound.play("sn_cc_button_accept")
		blood_hide()
	
func toggle_buttons( selected_node : TextureRect ):
	B2_Sound.play("sn_cc_generic_button1")
	for btn in blood_checkbox:
		if btn != selected_node:
			btn.is_selected = false

func blood_hide():
	var tween := create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 1.0)
	tween.tween_callback( emit_signal.bind("accept_pressed") )
	tween.tween_callback( queue_free )
