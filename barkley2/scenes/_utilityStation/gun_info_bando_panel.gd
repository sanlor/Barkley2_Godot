extends B2_UtilityPanel

@export var spin_gun := false
@export var spin_speed := 1.0

## Top Buttons
@onready var bando_gun_sel: 		Panel = $bando_sel/bando_gun_sel
@onready var bando_gun_text: 		TextureRect = $bando_sel/bando_gun_sel/bando_gun_text
@onready var bando_gun_value: 		Label = $bando_sel/bando_gun_sel/bando_gun_value

@onready var bando_gun_sel_2: 		Panel = $bando_sel/bando_gun_sel2
@onready var bando_gun_text_2: 		TextureRect = $bando_sel/bando_gun_sel2/bando_gun_text
@onready var bando_gun_value_2: 	Label = $bando_sel/bando_gun_sel2/bando_gun_value

@onready var bando_gun_sel_3: Panel = $bando_sel/bando_gun_sel3
@onready var bando_gun_text_3: TextureRect = $bando_sel/bando_gun_sel3/bando_gun_text
@onready var bando_gun_value_3: Label = $bando_sel/bando_gun_sel3/bando_gun_value

## GunMap
@onready var gun_map_text: TextureRect = $gun_map/gun_map_text
@onready var gun_marker_bottom: TextureRect = $gun_map/gun_map_text/gun_marker_bottom
@onready var gun_marker_top: TextureRect = $gun_map/gun_map_text/gun_marker_top
@onready var gun_marker_occupied: TextureRect = $gun_map/gun_map_text/gun_marker_occupied

## Gun Data
@onready var gun_bullet_text: TextureRect = $gun_data/gun_bullet/gun_bullet_text
@onready var dmg_value: Label = $gun_data/gun_dmg/dmg_value
@onready var rte_value: Label = $gun_data/gun_rte/rte_value
@onready var spc_value: Label = $gun_data/gun_spc/spc_value
@onready var cap_value: Label = $gun_data/gun_cap/cap_value

@onready var gun_name_value: 		Label = $more_gun_data/gun_texture/gun_name_value
@onready var gun_texture: 			TextureRect = $more_gun_data/gun_texture/gun_texture
@onready var pts_value: 			Label = $more_gun_data/gun_texture/pts_value
@onready var wgt_value: 			Label = $more_gun_data/gun_texture/wgt_value

## Affixes
@onready var affix_name_1: 			Label = $more_gun_data/affix1/affix_name_1
@onready var affix_description_1: 	Label = $more_gun_data/affix1/affix_description_1
@onready var affix_name_2: 			Label = $more_gun_data/affix2/affix_name_2
@onready var affix_description_2: 	Label = $more_gun_data/affix2/affix_description_2
@onready var affix_name_3: 			Label = $more_gun_data/affix3/affix_name_3
@onready var affix_description_3: 	Label = $more_gun_data/affix3/affix_description_3

## Lineage
@onready var daddy_cont: 		HBoxContainer = $gun_lineage/gun_name_lineage_1/daddy_cont
@onready var lin_gun_texture: 	TextureRect = $gun_lineage/gun_text_lineage_1/gun_texture
@onready var lin_wgt_value: 	Label = $gun_lineage/gun_text_lineage_1/wgt_value
@onready var prefix_1_label: 	Label = $gun_lineage/gun_name_lineage_1/daddy_cont/prefix_1_label
@onready var prefix_2_label: 	Label = $gun_lineage/gun_name_lineage_1/daddy_cont/prefix_2_label
@onready var name_label: 		Label = $gun_lineage/gun_name_lineage_1/daddy_cont/name_label
@onready var suffix_label: 		Label = $gun_lineage/gun_name_lineage_1/daddy_cont/suffix_label

@onready var mommy_cont: 		HBoxContainer = $gun_lineage/gun_name_lineage_2/mommy_cont
@onready var lin_gun_texture_2: TextureRect = $gun_lineage/gun_text_lineage_2/gun_texture
@onready var lin_wgt_value_2: 	Label = $gun_lineage/gun_text_lineage_2/wgt_value
@onready var prefix_1_label_2: 	Label = $gun_lineage/gun_name_lineage_2/mommy_cont/prefix_1_label
@onready var prefix_2_label_2: 	Label = $gun_lineage/gun_name_lineage_2/mommy_cont/prefix_2_label
@onready var name_label_2: 		Label = $gun_lineage/gun_name_lineage_2/mommy_cont/name_label
@onready var suffix_label_2: 	Label = $gun_lineage/gun_name_lineage_2/mommy_cont/suffix_label

var selected_gun : B2_Weapon

func update_menu() -> void:
	if not is_node_ready():
		return

func _on_visibility_changed() -> void:
	if not is_node_ready():
		return
		
	bando_gun_sel.hide()
	bando_gun_sel_2.hide()
	bando_gun_sel_3.hide()
	var btn := [bando_gun_sel, bando_gun_sel_2, bando_gun_sel_3]
	var i := 0
	for gun in B2_Gun.get_bandolier():
		if i == 0: update_data( gun )
		btn[i].show()
		btn[i].setup( gun )
		i += 1

func update_data( gun : B2_Weapon ) -> void:
	if not is_node_ready():
		return
		
	selected_gun = gun
	
	var map_size := Vector2(60,60)
	gun_map_text.texture 			= B2_Gunmap.get_gun_map( map_size )
	gun_marker_bottom.position 		= B2_Gunmap.get_gun_map_position( 0, gun.weapon_name, map_size )
	gun_marker_top.position 		= B2_Gunmap.get_gun_map_position( 1, gun.weapon_name, map_size )
	gun_marker_occupied.position 	= B2_Gunmap.get_gun_map_position( 2, gun.weapon_name, map_size )
	
	gun_bullet_text.texture.region.position.x = 15 * B2_Gun.TYPE_ICON_LIST.get( gun.weapon_type, 0 )
	dmg_value.text 			= str( int(gun.get_att()) )
	rte_value.text 			= str( int(gun.get_spd()) )
	spc_value.text 			= str( gun.afx_count() )
	cap_value.text 			= "%s ( %s )" % [ str(gun.curr_ammo), str(gun.max_ammo) ]
	
	gun_name_value.text = Text.pr( gun.weapon_name )
	gun_texture.texture = gun.get_weapon_hud_sprite()
	pts_value.text = str( int( gun.pts ) )
	wgt_value.text = str( int( gun.wgt ) )
	
	## Affix
	if gun.prefix1:
		affix_name_1.text = Text.pr( gun.prefix1 )
		affix_description_1.text = Text.pr( B2_Gun.prefix1[gun.prefix1][2] )
		affix_name_1.modulate = Color.WHITE
		affix_description_1.modulate = Color.WHITE
	else:
		affix_name_1.modulate = Color.TRANSPARENT
		affix_description_1.modulate = Color.TRANSPARENT
		
	if gun.prefix2:
		affix_name_2.text = Text.pr( gun.prefix2 )
		affix_description_2.text = Text.pr( B2_Gun.prefix2[gun.prefix2][3] )
		affix_name_2.modulate = Color.WHITE
		affix_description_2.modulate = Color.WHITE
	else:
		affix_name_2.modulate = Color.TRANSPARENT
		affix_description_2.modulate = Color.TRANSPARENT
		
	if gun.suffix:
		affix_name_3.text = Text.pr( gun.suffix )
		affix_description_3.text = Text.pr( B2_Gun.suffix[gun.suffix][3] )
		affix_name_3.modulate = Color.WHITE
		affix_description_3.modulate = Color.WHITE
	else:
		affix_name_3.modulate = Color.TRANSPARENT
		affix_description_3.modulate = Color.TRANSPARENT
	
	## Lineage
	if gun.lineage_top:
		lin_wgt_value.text = "???ç"
		prefix_1_label.text = "???"
		prefix_2_label.text = "???"
		name_label.text = "???"
		suffix_label.text = "???"
	else:
		lin_wgt_value.text = "0ç"
		prefix_1_label.text = ""
		prefix_2_label.text = ""
		name_label.text = "Not Implemented"
		suffix_label.text = ""
	
	if gun.lineage_bot:
		lin_wgt_value_2.text = "???ç"
		prefix_1_label_2.text = "???"
		prefix_2_label_2.text = "???"
		suffix_label_2.text = "???"
	else:
		lin_wgt_value_2.text = "0ç"
		prefix_1_label_2.text = ""
		prefix_2_label_2.text = ""
		name_label_2.text = "Not Implemented"
		suffix_label_2.text = ""
	
var t := 0.0
func _process(delta: float) -> void:
	t += 3.0 * delta
	var c := Color.WHITE * ( 1.0 + sin( t ) )
	if spin_gun: gun_texture.scale.x = sin( t * spin_speed )
	gun_marker_bottom.modulate 		= c
	gun_marker_top.modulate 		= c
	gun_marker_occupied.modulate 	= c
