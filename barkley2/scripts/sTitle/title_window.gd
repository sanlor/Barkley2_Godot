extends CanvasLayer

@onready var r_title = get_parent()

# "basic", "settings", "keymap", "gamepad", "gameslot","destruct_confirm", "gamestart_character" ## NOTE This reeeealy should be an enum.
func _on_start_button_pressed():
	r_title.mode = "gameslot"
	hide()

func _on_settings_button_pressed():
	r_title.mode = "settings"
	hide()

func _on_quit_button_pressed():
	get_tree().quit()
