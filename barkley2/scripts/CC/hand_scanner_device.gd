extends Control

@onready var hand_left_bg = $hand_left_bg
@onready var hand_right_bg = $hand_right_bg
@onready var hand_bg = $hand_bg

func _ready():
	hand_left_bg.modulate = Color.TEAL
	hand_right_bg.modulate = Color.TEAL

func activate_device():
	hand_left_bg.play("default")
	hand_right_bg.play("default")
	hand_bg.show()
	
func deactivate_device():
	hand_bg.hide()
	
func set_bg_color( color : Color ):
	hand_left_bg.modulate = color
	hand_right_bg.modulate = color
