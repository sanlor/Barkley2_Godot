extends PanelContainer

signal gun_updated( gun : B2_Weapon )

@onready var gun_title_lbl: Label = $gun_container/gun_title_lbl
@onready var gun_texture: TextureRect = $gun_container/gun_texture

@onready var option_type: OptionButton = $gun_container/option_containers/option_type
@onready var option_material: OptionButton = $gun_container/option_containers/option_material

@onready var attack_stat_lbl: Label = $gun_container/stat_container/attack_stat_lbl
@onready var speed_stat_lbl: Label = $gun_container/stat_container/speed_stat_lbl
@onready var ammo_stat_lbl: Label = $gun_container/stat_container/ammo_stat_lbl
@onready var affix_stat_lbl: Label = $gun_container/stat_container/affix_stat_lbl
@onready var weight_stat_lbl: Label = $gun_container/stat_container/weight_stat_lbl

var my_gun : B2_Weapon

func _ready() -> void:
	option_type.clear()
	option_material.clear()
	
	for t in B2_Gun.TYPE:
		option_type.add_item( t )
	for m in B2_Gun.MATERIAL:
		option_material.add_item( m )
		
	await get_tree().process_frame
	_on_rand_btn_pressed()
	_on_gen_btn_pressed()
	_update_data()

func _update_data() -> void:
	if my_gun:
		gun_title_lbl.text = my_gun.get_full_name()
		gun_texture.texture = my_gun.get_weapon_hud_sprite()
		attack_stat_lbl.text 	= str("POWER:  	%s x %s = %s" % [my_gun.att, my_gun.get_att_mod(), my_gun.get_effective_att() ])
		speed_stat_lbl.text 	= str("SPEED:  	%s x %s = %s" % [my_gun.spd, my_gun.get_spd_mod(), my_gun.get_effective_spd() ])
		ammo_stat_lbl.text 		= str("AMMO:  	%s x %s = %s" % [my_gun.max_ammo, my_gun.get_amm_mod(), my_gun.get_effective_amm() ])
		affix_stat_lbl.text 	= str("AFFIX:  	%s x %s = %s" % [my_gun.afx, my_gun.get_afx_mod(), my_gun.get_effective_afx() ])
		weight_stat_lbl.text 	= str("WEIGHT: 	 %s x %s = %s" % [my_gun.wgt, my_gun.get_wgt_mod(), my_gun.get_effective_wgt() ])
	else:
		gun_title_lbl.text = "No gun :("
		gun_texture.texture = PlaceholderTexture2D.new()
		gun_texture.texture.size = Vector2(49.0, 24.0)

func _on_gen_btn_pressed() -> void:
	my_gun = B2_Gun.generate_generic_gun( option_type.get_selected_id(), option_material.get_selected_id() )
	gun_updated.emit( my_gun )
	_update_data()

func _on_rand_btn_pressed() -> void:
	option_type.select( B2_Gun.TYPE.values().pick_random() )
	option_material.select( B2_Gun.MATERIAL.values().pick_random() )
