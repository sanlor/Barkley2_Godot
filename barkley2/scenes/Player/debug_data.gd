extends Control

@onready var label: Label = $Label

func _physics_process(_delta: float) -> void:
	label.text = "Inputs:\n"
	label.text += "WX: %s, WY: %s\n" % [ str( snapped(get_parent().curr_input.x,0.01) ).pad_decimals(2), str( snapped(get_parent().curr_input.y,0.01) ).pad_decimals(2) ]
	label.text += "AX: %s, AY: %s\n" % [ str( snapped(get_parent().curr_aim.x,0.01) ).pad_decimals(2), str( snapped(get_parent().curr_aim.y,0.01) ).pad_decimals(2) ]
