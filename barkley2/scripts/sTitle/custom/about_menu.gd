extends B2_Border

func _on_close_pressed():
	get_parent().queue_free()

func _on_mouse_tim_pressed():
	B2_Config.tim_follow_mouse = $MarginContainer/VBoxContainer/mouse_tim.button_pressed
