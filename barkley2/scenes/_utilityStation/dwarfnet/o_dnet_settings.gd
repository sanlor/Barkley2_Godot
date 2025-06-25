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

@onready var not_cannon_btn: 	Button = $not_cannon_btn
@onready var not_cannon: 		ColorRect = $not_cannon
@onready var time_value: 		Label = $not_cannon/MarginContainer/VBoxContainer/chaos_control/time_value
@onready var time_slider: HSlider = $not_cannon/MarginContainer/VBoxContainer/chaos_control/time_slider

func _ready() -> void:
	_on_not_cannon_btn_pressed()
	time_slider.max_value = B2_ClockTime.CLOCK_MAX
	time_slider.value = 0
	B2_DNET.set_time( 0 )

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

## Not Cannon stuff
func _on_not_cannon_btn_pressed() -> void:
	not_cannon.visible = not_cannon_btn.button_pressed

func _on_h_slider_value_changed(value: float) -> void:
	B2_DNET.set_time( value )
	time_value.text = str( B2_DNET.get_time_str() )
