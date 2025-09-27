extends B2_UtilityPanel

## Reusable scene. Used in at least, 3 screens.
## Display Bando and Bag gun status.
# NOTE | Check this before changing this script -> https://www.youtube.com/watch?v=LB2rgtvcM4s

signal changed_window_state
signal gun_was_selected( gun : B2_Weapon )

const PANEL_GUN_SEL = preload("res://barkley2/scenes/_utilityStation/panel_gun_sel.tscn")
@export var spin_gun := false
@export var spin_speed := 1.0

@onready var data: 				Control = $data
@onready var no_data: 			Control = $no_data
@onready var title_value: 		Label = $no_data/title/title_value
@onready var flavor_value: 		Label = $no_data/flavor_text/flavor_value

## Gun Button list
@onready var gunbag_guns: 			HBoxContainer 	= $data/gunbag_sel/guns
@onready var bando_guns: 			HBoxContainer 	= $data/bando_sel/guns

@onready var bando_sel: 			Panel = $data/bando_sel
@onready var gunbag_sel: 			Panel = $data/gunbag_sel

## GunMap
@onready var gun_map_text: 			TextureRect = $data/gun_map/gun_map_text
@onready var gun_marker_bottom: 	TextureRect = $data/gun_map/gun_map_text/gun_marker_bottom
@onready var gun_marker_top: 		TextureRect = $data/gun_map/gun_map_text/gun_marker_top
@onready var gun_marker_occupied: 	TextureRect = $data/gun_map/gun_map_text/gun_marker_occupied

## Gun Data
@onready var gun_bullet_text: 		TextureRect = $data/gun_data/gun_bullet/gun_bullet_text
@onready var dmg_value: 			Label = $data/gun_data/gun_dmg/dmg_value
@onready var rte_value: 			Label = $data/gun_data/gun_rte/rte_value
@onready var spc_value: 			Label = $data/gun_data/gun_spc/spc_value
@onready var cap_value: 			Label = $data/gun_data/gun_cap/cap_value

@onready var gun_name_value: 		Label = $data/more_gun_data/gun_texture/gun_name_value
@onready var gun_texture: 			TextureRect = $data/more_gun_data/gun_texture/gun_texture
@onready var pts_value: 			Label = $data/more_gun_data/gun_texture/pts_value
@onready var wgt_value: 			Label = $data/more_gun_data/gun_texture/wgt_value

## Affixes
@onready var affix_name_1: 			Label = $data/more_gun_data/affix1/affix_name_1
@onready var affix_description_1: 	Label = $data/more_gun_data/affix1/affix_description_1
@onready var affix_name_2: 			Label = $data/more_gun_data/affix2/affix_name_2
@onready var affix_description_2: 	Label = $data/more_gun_data/affix2/affix_description_2
@onready var affix_name_3: 			Label = $data/more_gun_data/affix3/affix_name_3
@onready var affix_description_3: 	Label = $data/more_gun_data/affix3/affix_description_3

## Lineage
@onready var gun_lineage: Control = $data/gun_lineage

@onready var daddy_cont: 		HBoxContainer = $data/gun_lineage/gun_name_lineage_1/daddy_cont
@onready var lin_gun_texture: 	TextureRect = $data/gun_lineage/gun_text_lineage_1/gun_texture
@onready var lin_wgt_value: 	Label = $data/gun_lineage/gun_text_lineage_1/wgt_value
@onready var prefix_1_label: 	Label = $data/gun_lineage/gun_name_lineage_1/daddy_cont/prefix_1_label
@onready var prefix_2_label: 	Label = $data/gun_lineage/gun_name_lineage_1/daddy_cont/prefix_2_label
@onready var name_label: 		Label = $data/gun_lineage/gun_name_lineage_1/daddy_cont/name_label
@onready var suffix_label: 		Label = $data/gun_lineage/gun_name_lineage_1/daddy_cont/suffix_label

@onready var mommy_cont: 		HBoxContainer = $data/gun_lineage/gun_name_lineage_2/mommy_cont
@onready var lin_gun_texture_2: TextureRect = $data/gun_lineage/gun_text_lineage_2/gun_texture
@onready var lin_wgt_value_2: 	Label = $data/gun_lineage/gun_text_lineage_2/wgt_value
@onready var prefix_1_label_2: 	Label = $data/gun_lineage/gun_name_lineage_2/mommy_cont/prefix_1_label
@onready var prefix_2_label_2: 	Label = $data/gun_lineage/gun_name_lineage_2/mommy_cont/prefix_2_label
@onready var name_label_2: 		Label = $data/gun_lineage/gun_name_lineage_2/mommy_cont/name_label
@onready var suffix_label_2: 	Label = $data/gun_lineage/gun_name_lineage_2/mommy_cont/suffix_label

## Smelt
@onready var smelt_data: 		Control = $data/smelt
@onready var smelt_gauge: 		TextureRect = $data/smelt/smelt_panel/smelt_gauge
@onready var smelt_title: 		TextureRect = $data/smelt/smelt_panel/smelt_title
@onready var smelt_value: 		Label = $data/smelt/smelt_panel/smelt_value
@onready var smelt_cost_value: 	Label = $data/smelt/smelt_panel/smelt_cost_value

@export var default_button			: Control
@export var show_bandolier_guns 	:= true
@export var show_gunbag_guns 		:= true
@export var show_lineage			:= true
@export var show_smelt				:= false

var selected_gun : B2_Weapon :
	set(s):
		selected_gun = s
		gun_was_selected.emit( s )

func update_menu() -> void:
	if not is_node_ready():
		return

func _on_visibility_changed() -> void:
	if not is_node_ready():
		return
		
	selected_gun = null
		
	for i in bando_guns.get_children():
		i.queue_free()
	for i in gunbag_guns.get_children():
		i.queue_free()
	
	gun_lineage.visible 	= show_lineage
	smelt_data.visible 		= show_smelt
	bando_sel.visible 		= show_bandolier_guns
	
	if show_bandolier_guns:
		var i := 0
		for gun in B2_Gun.get_bandolier():
			var btn := PANEL_GUN_SEL.instantiate()
			btn.gun_selected.connect( gun_panel_selected )
			btn.gun_info_panel = self
			btn.my_gun = gun
			bando_guns.add_child( btn, true )
			if i == 0:
				if show_bandolier_guns:
					update_data( gun )
					btn.grab_focus()
					btn.selected = true
			btn.setup( gun )
			i += 1
			
	gunbag_sel.visible = show_gunbag_guns
	if show_gunbag_guns:
		var i := 0
		for gun in B2_Gun.get_gunbag():
			var btn := PANEL_GUN_SEL.instantiate()
			btn.gun_selected.connect( gun_panel_selected )
			btn.gun_info_panel = self
			btn.my_gun = gun
			btn.show_name = false
			gunbag_guns.add_child( btn, true )
			if i == 0:
				if ( not show_bandolier_guns and show_gunbag_guns ) or (B2_Gun.get_bandolier().is_empty() and show_gunbag_guns):
					update_data( gun )
					btn.grab_focus()
					btn.selected = true
			btn.setup( gun )
			i += 1
			
	if not selected_gun:
		data.hide()
		no_data.show()
		if show_bandolier_guns and show_gunbag_guns:
			title_value.text = Text.pr( "GUNS" ).to_upper()
			flavor_value.text = Text.pr( "No guns at all!" )
		elif show_bandolier_guns:
			title_value.text = Text.pr( "Bandolier" ).to_upper()
			flavor_value.text = Text.pr( "No bandolier guns." )
		else:
			title_value.text = Text.pr( "Bag" ).to_upper()
			flavor_value.text = Text.pr( "No gunsbag guns." )
	else:
		data.show()
		no_data.hide()
		
func gun_panel_selected( my_gun : B2_Weapon ) -> void:
	selected_gun = my_gun
	if default_button:
		B2_Sound.play( "utility_button_disabled" )
		default_button.grab_focus()

func update_data( gun : B2_Weapon ) -> void:
	if not is_node_ready():
		return
		
	selected_gun = gun
	
	#var map_size := Vector2(60,60) ## NOTE disabled this on 27/09/25 is this still needed?
	gun_map_text.texture 			= B2_Gunmap.get_gun_map(  )
	gun_marker_bottom.position 		= B2_Gunmap.get_gun_map_position( 0, gun.weapon_name )
	gun_marker_top.position 		= B2_Gunmap.get_gun_map_position( 1, gun.weapon_name )
	gun_marker_occupied.position 	= B2_Gunmap.get_gun_map_position( 2, gun.weapon_name )
	
	gun_bullet_text.texture.region.position.x = 15 * B2_Gun.TYPE_ICON_LIST.get( gun.weapon_type, 0 )
	dmg_value.text 			= str( int(gun.get_att()) )
	rte_value.text 			= str( int(gun.get_spd()) )
	spc_value.text 			= str( gun.get_afx_count() )
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
	
	update_smelt_gauge()

func preview_smelt( amount : int ) -> void:
	B2_Sound.play( "hoopz_click" )
	smelt_cost_value.text = "+ %s" % str( amount ).pad_zeros(4)

func apply_smelt_point( amount : int ) -> void:
	B2_Sound.play( "utility_button_analogclick" )
	B2_Config.set_user_save_data("ustation.smelt", B2_Config.get_user_save_data("ustation.smelt" ) + amount )
	smelt_cost_value.text = "+ %s" % str( 0 ).pad_zeros(4)
	update_smelt_gauge()
	preview_smelt( 0 )

func update_smelt_gauge() -> void:
	##  Smelt Gauge
	var smelt : float 							= B2_Config.get_user_save_data("ustation.smelt", 0.0)
	smelt_value.text 							= str( int( smelt ) )
	smelt_gauge.texture.region.position.x 		= 176.0 * roundf( (smelt / 1000.0) * 45 )
	if not selected_gun:
		smelt_cost_value.text = ""
	else:
		smelt_cost_value.text = "+ %s" % str( selected_gun.pts ).pad_zeros(4)
	
var t := 0.0
func _process(delta: float) -> void:
	t += 3.0 * delta
	var c := Color.WHITE * ( 1.0 + sin( t ) )
	if spin_gun: gun_texture.scale.x = sin( t * spin_speed )
	gun_marker_bottom.modulate 		= c
	gun_marker_top.modulate 		= c
	gun_marker_occupied.modulate 	= c
