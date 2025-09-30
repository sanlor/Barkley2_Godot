extends PanelContainer

@onready var type_stat_lbl: Label = $gun_container/stat_container/type_stat_lbl
@onready var material_stat_lbl: Label = $gun_container/stat_container/material_stat_lbl

@onready var points_stat_lbl: Label = $gun_container/stat_container/points_stat_lbl
@onready var attack_stat_lbl: Label = $gun_container/stat_container/attack_stat_lbl
@onready var speed_stat_lbl: Label = $gun_container/stat_container/speed_stat_lbl
@onready var ammo_stat_lbl: Label = $gun_container/stat_container/ammo_stat_lbl
@onready var affix_stat_lbl: Label = $gun_container/stat_container/affix_stat_lbl
@onready var weight_stat_lbl: Label = $gun_container/stat_container/weight_stat_lbl

@onready var affix_1_stat_lbl: Label = $gun_container/stat_container/affix1_stat_lbl
@onready var affix_2_stat_lbl: Label = $gun_container/stat_container/affix2_stat_lbl
@onready var affix_3_stat_lbl: Label = $gun_container/stat_container/affix3_stat_lbl

@onready var gun_parent_top: 		PanelContainer = $"../gun_top"
@onready var gun_parent_bottom: 	PanelContainer = $"../gun_bottom"

@onready var gun_title_lbl: 	Label = $gun_container/gun_title_lbl
@onready var gun_texture: 		TextureRect = $gun_container/gun_texture

@onready var v_slider: VSlider = $"../VSlider"

var top_gun : 		B2_Weapon
var bottom_gun : 	B2_Weapon
var my_gun : 		B2_Weapon

func _ready() -> void:
	gun_parent_top.gun_updated.connect(_load_top_gun)
	gun_parent_bottom.gun_updated.connect(_load_bottom_gun)

func _load_top_gun( gun : B2_Weapon ) -> void:
	if gun: top_gun = gun
	_make_offspring()
	
func _load_bottom_gun( gun : B2_Weapon ) -> void:
	if gun: bottom_gun = gun
	_make_offspring()

func _make_offspring() -> void:
	if top_gun and bottom_gun:
		my_gun = B2_Gun.generate_gun_from_parents(top_gun, bottom_gun, v_slider.value)
		_update_data()

func _update_data() -> void:
	if my_gun:
		gun_title_lbl.text = "%s (%s)" % [my_gun.get_full_name(), my_gun.get_short_name() ]
		gun_texture.texture = my_gun.get_weapon_hud_sprite()
		points_stat_lbl.text	= str("POINTS:		%s" % my_gun.pts)
		type_stat_lbl.text 		= str("TYPE: 	 	%s" % B2_Gun.TYPE.keys()[my_gun.weapon_type] )
		material_stat_lbl.text 	= str("MATERIAL:  	%s" % B2_Gun.MATERIAL.keys()[my_gun.weapon_material])
		attack_stat_lbl.text 	= str("POWER:	  	%s x %s = %s" % [my_gun.get_att(), my_gun.get_att_mod(), my_gun.get_effective_att() ])
		speed_stat_lbl.text 	= str("SPEED: 	 	%s x %s = %s" % [my_gun.get_spd(), my_gun.get_spd_mod(), my_gun.get_effective_spd() ])
		ammo_stat_lbl.text 		= str("AMMO:  		%s x %s = %s" % [my_gun.max_ammo, my_gun.get_amm_mod(), my_gun.get_effective_amm() ])
		affix_stat_lbl.text 	= str("AFFIX:  		%s x %s = %s" % [my_gun.get_afx(), my_gun.get_afx_mod(), my_gun.get_effective_afx() ])
		weight_stat_lbl.text 	= str("WEIGHT: 		 %s x %s = %s" % [my_gun.get_wgt(), my_gun.get_wgt_mod(), my_gun.get_effective_wgt() ])
		affix_1_stat_lbl.text	= "PREFFIX1:  		%s" % my_gun.prefix1
		affix_2_stat_lbl.text	= "PREFFIX2:  		%s" % my_gun.prefix2
		affix_3_stat_lbl.text	= "SUFFIX:  		%s" % my_gun.suffix
	else:
		gun_title_lbl.text = "No gun :("
		gun_texture.texture = PlaceholderTexture2D.new()
		gun_texture.texture.size = Vector2(49.0, 24.0)

func _on_rebreed_btn_pressed() -> void:
	_make_offspring()
