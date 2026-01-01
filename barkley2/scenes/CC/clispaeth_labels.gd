@tool
extends Label

enum ERA{PRE_CLISPAETH, POS_CLISPAETH}
@export var whoami := ERA.PRE_CLISPAETH
@export var other_label : Label

@onready var check = $check

var is_selected := false :
	set(_s):
		is_selected = _s
		check.visible = is_selected
		_change_color()

var is_hovering := false

func _ready():
	mouse_entered.connect( func(): is_hovering = true; _change_color() )
	mouse_exited.connect( func(): is_hovering = false; _change_color() )
	
	check.play("default")
	check.hide()

func _toggle():
	if is_selected:
		other_label.is_selected = false

func _change_color():
	if is_hovering or is_selected:
		self_modulate = Color.RED
	else:
		self_modulate = Color.WHITE

func _input(event):
	if Engine.is_editor_hint():
		return
		
	# 01/01/26 gamepad fix
	var toggle := func():
		is_selected = true
		other_label.is_selected = false
		queue_redraw()
		B2_Sound.play("sn_cc_generic_button1")
		get_viewport().set_input_as_handled()
		
	if event is InputEventJoypadButton:
		if B2_Input.is_using_gamepad():
			if Input.is_action_just_pressed("Holster"):
				if not is_selected:
					toggle.call()
		
	if event is InputEventMouseButton:
		if Input.is_action_just_pressed("Action"):
			if is_hovering:
				toggle.call()

func _draw():
	pass
