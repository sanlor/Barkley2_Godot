extends Control

@onready var gun_prefix_1: 	Label = $gun_name_container/prefix_1
@onready var gun_prefix_2: 	Label = $gun_name_container/prefix_2
@onready var gun_name_value: 		Label = $gun_name_container/gun_name
@onready var gun_suffix: 	Label = $gun_name_container/suffix

@onready var gun_texture: 		TextureRect = $gun_data_container/gun_texture
@onready var gun_point_lbl: 	Label = $gun_data_container/points_cont/gun_point_lbl
@onready var gun_weight: 		Label = $gun_data_container/gun_weight
@onready var dmg_value: 		Label = $gun_data_container/gun_dmg/dmg_value
@onready var rte_value: 		Label = $gun_data_container/gun_rte/rte_value
@onready var cap_value: 		Label = $gun_data_container/gun_cap/cap_value
@onready var spc_value: 		Label = $gun_data_container/gun_spc/spc_value
@onready var gen_value: 		Label = $gun_data_container/gun_gen/gen_value

func setup( gun : B2_Weapon ) -> void:
	gun_texture.texture = gun.get_weapon_hud_sprite()
	dmg_value.text 			= str( int(gun.get_att()) )
	rte_value.text 			= str( int(gun.get_spd()) )
	spc_value.text 			= str( gun.get_afx_count() )
	cap_value.text 			= str(gun.max_ammo)
	
	gun_prefix_1.text 		= Text.pr( gun.prefix1 )
	gun_prefix_2.text 		= Text.pr( gun.prefix2 )
	gun_name_value.text 	= Text.pr( gun.weapon_name )
	gun_suffix.text 		= Text.pr( gun.suffix )
	
	gun_point_lbl.text 		= str( int( gun.pts ) )
	gun_weight.text 		= str( int( gun.wgt ) ) + "ç"
	gen_value.text			= str( int( gun.generation ) )
