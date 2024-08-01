@tool
extends B2_Border

@onready var mouse_tim = $MarginContainer/VBoxContainer/mouse_tim
@onready var unused = $MarginContainer/VBoxContainer/unused


func _ready():
	set_panel_size( 210, 200 ) # why this keeps reseting to 50x50 using the @export? had to set it manually
	mouse_tim.button_pressed = B2_Config.tim_follow_mouse


func _on_close_pressed():
	get_parent().queue_free()

func _on_mouse_tim_pressed():
	B2_Config.tim_follow_mouse = mouse_tim.button_pressed
