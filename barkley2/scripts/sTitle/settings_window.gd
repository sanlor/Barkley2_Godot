extends CanvasLayer

@onready var r_title = get_parent()

@onready var general = $settings_panel/general
@onready var keys = $settings_panel/keys
@onready var gamepad = $settings_panel/gamepad


func _ready():
	pass
	
# "basic", "settings", "keymap", "gamepad", "gameslot","destruct_confirm", "gamestart_character" ## NOTE This reeeealy should be an enum.
func _on_settings_general_button_pressed():
	r_title.mode = "settings"
	general.show()
	keys.hide()
	gamepad.hide()

func _on_settings_keys_button_pressed():
	r_title.mode = "keymap"
	general.hide()
	keys.show()
	gamepad.hide()
	
func _on_settings_gamepad_button_pressed():
	r_title.mode = "gamepad"
	general.hide()
	keys.hide()
	gamepad.show()
	
func _on_settings_return_button_pressed():
	r_title.mode = "basic"
	hide()
