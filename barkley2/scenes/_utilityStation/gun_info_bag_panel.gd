extends "res://barkley2/scenes/_utilityStation/gun_info_panel.gd"

func _on_gun_bag_fave_btn_pressed() -> void:
	if selected_gun:
		selected_gun.favorite = not selected_gun.favorite
		_on_visibility_changed()
