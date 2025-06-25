extends Control
## Handle Settings

@onready var o_dnet_control: Control = $".."

@onready var skin_1: Button = $custom_box/skin_1
@onready var skin_2: Button = $custom_box/skin_2
@onready var skin_3: Button = $custom_box/skin_3
@onready var skin_4: Button = $custom_box/skin_4
@onready var skin_5: Button = $custom_box/skin_5
@onready var skin_6: Button = $custom_box/skin_6

@onready var profile_1: Button = $profiles/profile_1
@onready var profile_2: Button = $profiles/profile_2
@onready var profile_3: Button = $profiles/profile_3
@onready var profile_4: Button = $profiles/profile_4
@onready var profile_5: Button = $profiles/profile_5


func _on_skin_1_pressed() -> void:
	o_dnet_control.change_menu_color( Color.BLUE )

func _on_skin_2_pressed() -> void:
	o_dnet_control.change_menu_color( Color.SADDLE_BROWN )

func _on_skin_3_pressed() -> void:
	o_dnet_control.change_menu_color( Color.CYAN )

func _on_skin_4_pressed() -> void:
	o_dnet_control.change_menu_color( Color.ORANGE )

func _on_skin_5_pressed() -> void:
	o_dnet_control.change_menu_color( Color.RED )

func _on_skin_6_pressed() -> void:
	o_dnet_control.change_menu_color( Color.WHITE )
