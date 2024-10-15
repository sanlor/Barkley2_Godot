@tool
extends B2_Border

@onready var mouse_tim = $MarginContainer/VBoxContainer/mouse_tim
@onready var dev_nodes = $MarginContainer/VBoxContainer/dev_notes


func _ready():
	set_panel_size( 210, 200 ) # why this keeps reseting to 50x50 using the @export? had to set it manually
	mouse_tim.button_pressed = B2_Config.tim_follow_mouse
	dev_nodes.button_pressed = B2_Config.dev_notes

func _on_close_pressed():
	get_parent().queue_free()

func _on_mouse_tim_pressed() -> void:
	B2_Config.tim_follow_mouse = mouse_tim.button_pressed

func _on_dev_notes_pressed() -> void:
	B2_Config.dev_notes = dev_nodes.button_pressed
