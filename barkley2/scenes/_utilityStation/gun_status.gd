extends Control

@onready var id_value: 			Label 		= $id/id_value
@onready var sprite_value: 		TextureRect = $sprite/sprite_value
@onready var weight_value: 		Label 		= $sprite/weight_value
@onready var name_value: 		Label 		= $name/name_value
@onready var dmg_title: 		Label 		= $dmg/dmg_title
@onready var dmg_value: 		Label 		= $dmg/dmg_value
@onready var rte_title: 		Label 		= $rte/rte_title
@onready var rte_value: 		Label 		= $rte/rte_value
@onready var spc_title: 		Label 		= $spc/spc_title
@onready var spc_value: 		Label 		= $spc/spc_value
@onready var cap_title: 		Label 		= $cap/cap_title
@onready var cap_value: 		Label 		= $cap/cap_value

var id	:= 1
var my_gun : B2_Weapon

func setup( _gun : B2_Weapon ) -> void:
	my_gun = _gun
	_update_data()
	
func _update_data() -> void:
	if my_gun:
		id_value.text 			= str(id)
		sprite_value.texture 	= my_gun.get_weapon_hud_sprite()
		weight_value.text 		= str( int(my_gun.wgt) ) + "~"
		name_value.text 		= str( my_gun.get_short_name() )
		dmg_value.text 			= str( int(my_gun.get_att()) )
		rte_value.text 			= str( int(my_gun.get_spd()) )
		spc_value.text 			= str( my_gun.afx_count() )
		cap_value.text 			= "%s ( %s )" % [ str(my_gun.curr_ammo), str(my_gun.max_ammo) ]
