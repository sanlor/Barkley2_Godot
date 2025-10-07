extends CanvasLayer

@onready var r_title = get_parent()

@onready var start_button: Button = $title_panel/start_button
@onready var settings_button: Button = $title_panel/settings_button
@onready var quit_button: Button = $title_panel/quit_button


@onready var extra_btn: B2_Border_Button = $extra_btn
@onready var extra_menu: B2_Border = $extra_menu
@onready var vr_btn: Button = $extra_menu/MarginContainer/ScrollContainer/VBoxContainer/vr_btn

func _ready() -> void:
	extra_menu.hide()
	extra_btn.show()

# "basic", "settings", "keymap", "gamepad", "gameslot","destruct_confirm", "gamestart_character" ## NOTE This reeeealy should be an enum.
func _on_start_button_pressed():
	r_title.mode = "gameslot"
	hide()

func _on_settings_button_pressed():
	r_title.mode = "settings"
	hide()

func _on_quit_button_pressed():
	get_tree().quit()


func _on_extra_btn_button_pressed() -> void:
	extra_menu.show()
	extra_btn.hide()
	vr_btn.grab_focus()
	
	start_button.focus_neighbor_left 		= vr_btn.get_path()
	settings_button.focus_neighbor_left 	= vr_btn.get_path()
	quit_button.focus_neighbor_left 		= vr_btn.get_path()

func _on_extra_back_btn_pressed() -> void:
	extra_menu.hide()
	extra_btn.show()
	extra_btn.grab_focus()
	
	start_button.focus_neighbor_left 		= extra_btn.get_path()
	settings_button.focus_neighbor_left 	= extra_btn.get_path()
	quit_button.focus_neighbor_left 		= extra_btn.get_path()
