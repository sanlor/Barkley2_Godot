extends B2_UtilityPanel

signal renamed_gun( gun : B2_Weapon )

@export var gun_info_panel			: B2_UtilityPanel

@onready var gun_texture: 			TextureRect = $more_gun_data/gun_texture/gun_texture
@onready var gun_name_value: 		Label = $more_gun_data/gun_texture/gun_name_value
@onready var pts_value: 			Label = $more_gun_data/gun_texture/pts_value
@onready var wgt_value: 			Label = $more_gun_data/gun_texture/wgt_value

@onready var affix_name_1: 			Label = $more_gun_data/affix1/affix_name_1
@onready var affix_description_1: 	Label = $more_gun_data/affix1/affix_description_1
@onready var affix_name_2: 			Label = $more_gun_data/affix2/affix_name_2
@onready var affix_description_2: 	Label = $more_gun_data/affix2/affix_description_2
@onready var affix_name_3: 			Label = $more_gun_data/affix3/affix_name_3
@onready var affix_description_3: 	Label = $more_gun_data/affix3/affix_description_3

@onready var new_name: 				Label = $rename_bts/new_name

@onready var rename_bts: 			Control = $rename_bts

var gun : B2_Weapon

func update_menu() -> void:
	if not is_node_ready():
		return

func _on_visibility_changed() -> void:
	if not is_node_ready():
		return
	
	if gun_info_panel:
		if gun_info_panel.selected_gun:
			gun = gun_info_panel.selected_gun
	
	if gun:
		gun_name_value.text = Text.pr( gun.weapon_name )
		gun_texture.texture = gun.get_weapon_hud_sprite()
		pts_value.text = str( int( gun.get_points() ) )
		wgt_value.text = str( int( gun.get_wgt() ) )
		
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
			
		new_name.text = gun.get_short_name()
