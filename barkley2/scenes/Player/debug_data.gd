extends Control

@onready var label: Label = $Label

func _physics_process(_delta: float) -> void:
	label.text = "Inputs:\n"
	label.text += "WX: %s, WY: %s\n" % [ str( snapped(Input.get_axis("Left","Right"),0.01) ).pad_decimals(2), str( snapped(Input.get_axis("Up","Down"),0.01) ).pad_decimals(2) ]
	label.text += "AX: %s, AY: %s\n" % [ str( snapped(Input.get_axis("Aim_Left","Aim_Right"),0.01) ).pad_decimals(2), str( snapped(Input.get_axis("Aim_Up","Aim_Down"),0.01) ).pad_decimals(2) ]
