extends Button

@onready var gun_name: Label = $gun_name
@onready var gun_ammo: Label = $gun_ammo
@onready var gun_weight: Label = $gun_weight

@onready var pts_title: Label = $pts_title
@onready var dmg_title: Label = $dmg_title
@onready var rte_title: Label = $rte_title
@onready var spc_title: Label = $spc_title
@onready var cap_title: Label = $cap_title

@onready var pts_value: Label = $pts_value
@onready var dmg_value: Label = $dmg_value
@onready var rte_value: Label = $rte_value
@onready var spc_value: Label = $spc_value
@onready var cap_value: Label = $cap_value


const gunHeight := 16.0

const name_color := Color.ORANGE
const sel_name_color := Color.YELLOW

const ammo_color := Color.GRAY
const no_ammo_color := Color.ORANGE
const sel_ammo_color := Color.YELLOW

const weight_color := Color.GRAY
const sel_weight_color := Color.YELLOW

func _ready() -> void:
	_on_mouse_exited()
	_on_toggled( button_pressed )

func setup_button( wpn : B2_Weapon ) -> void:
	gun_name.text 		= wpn.get_short_name()
	gun_ammo.text 		= str(wpn.get_curr_ammo() ).pad_decimals(0)
	## NOTE The values bellow are very different from the original
	gun_weight.text 	= str( wpn.get_wgt() ).pad_decimals(0)
	pts_value.text		= str( min(wpn.get_pow()  + wpn.get_spd() + wpn.get_afx() + wpn.get_amm(), 999 ) ).pad_decimals(0)
	dmg_value.text		= str( wpn.get_damage() ).pad_decimals(0)
	rte_value.text		= wpn.get_rate_total() # str( wpn.get_spd() ).pad_decimals(0)
	spc_value.text		= str( wpn.get_afx() ).pad_decimals(0)
	cap_value.text		= str( wpn.get_max_ammo() ).pad_decimals(0)

func _on_mouse_entered() -> void:
	gun_ammo.modulate 		= sel_ammo_color
	gun_weight.modulate 	= sel_weight_color
	gun_name.modulate 		= sel_name_color
	
	pts_title.modulate		= Color.YELLOW
	dmg_title.modulate		= Color.YELLOW
	rte_title.modulate		= Color.YELLOW
	spc_title.modulate		= Color.YELLOW
	cap_title.modulate		= Color.YELLOW

func _on_mouse_exited() -> void:
	gun_ammo.modulate 		= ammo_color
	gun_weight.modulate 	= weight_color
	gun_name.modulate 		= name_color
	
	pts_title.modulate		= Color.ORANGE
	dmg_title.modulate		= Color.ORANGE
	rte_title.modulate		= Color.ORANGE
	spc_title.modulate		= Color.ORANGE
	cap_title.modulate		= Color.ORANGE

func _on_toggled(toggled_on: bool) -> void:
	custom_minimum_size.y = 0
	if toggled_on:
		size.y = (gunHeight * 2) + 4
	else:
		size.y = gunHeight
	custom_minimum_size.y = size.y

func _on_pressed() -> void:
	_on_toggled( button_pressed )

func _on_focus_entered() -> void:
	_on_mouse_entered()

func _on_focus_exited() -> void:
	_on_mouse_exited()
