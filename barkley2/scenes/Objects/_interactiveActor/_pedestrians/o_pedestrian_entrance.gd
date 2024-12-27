@icon("res://barkley2/assets/b2_original/images/merged/s_pedestrianEntrance.png")
extends Sprite2D
class_name B2_Ped_Entrance

func _ready() -> void:
	if not Engine.is_editor_hint():
		hide()
	texture = preload("res://barkley2/assets/b2_original/images/merged/s_pedestrianEntrance.png")
