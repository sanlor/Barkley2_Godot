extends B2_UtilityPanel

@onready var bandwidth_title_panel: Panel = $bandwidth/bandwidth_title_panel
@onready var bandwidth_lvl_1_panel: Panel = $bandwidth/bandwidth_lvl1_panel
@onready var bandwidth_lvl_2_panel: Panel = $bandwidth/bandwidth_lvl2_panel
@onready var bandwidth_lvl_3_panel: Panel = $bandwidth/bandwidth_lvl3_panel

@onready var level_panel: 			Panel = $level_panel
@onready var mai_leberu_lbl: 		Label = $level_panel/mai_leberu_lbl

@onready var weight_stat_value: Label = $hoopz_stat/weight/vbox/stat_value
@onready var guts_stat_value: Label = $hoopz_stat/guts/vbox/stat_value
@onready var luck_stat_value: Label = $hoopz_stat/luck/vbox/stat_value
@onready var acro_stat_value: Label = $hoopz_stat/acro/vbox/stat_value
@onready var might_stat_value: Label = $hoopz_stat/might/vbox/stat_value
@onready var piety_stat_value: Label = $hoopz_stat/piety/vbox/stat_value

@onready var brain_level_up_guts: HBoxContainer = $levelup_display/brain_level_up_guts
@onready var brain_level_up_luck: HBoxContainer = $levelup_display/brain_level_up_luck
@onready var brain_level_up_acro: HBoxContainer = $levelup_display/brain_level_up_acro
@onready var brain_level_up_might: HBoxContainer = $levelup_display/brain_level_up_might
@onready var brain_level_up_piety: HBoxContainer = $levelup_display/brain_level_up_piety

@onready var brain_levelup_guts_btn: 	Button = $"../right_panel/right_panel_vbox/brain_menu/brain_levelup_menu/brain_levelup_guts_btn"
@onready var brain_levelup_luck_btn: 	Button = $"../right_panel/right_panel_vbox/brain_menu/brain_levelup_menu/brain_levelup_luck_btn"
@onready var brain_levelup_acro_btn: 	Button = $"../right_panel/right_panel_vbox/brain_menu/brain_levelup_menu/brain_levelup_acro_btn"
@onready var brain_levelup_might_btn: 	Button = $"../right_panel/right_panel_vbox/brain_menu/brain_levelup_menu/brain_levelup_might_btn"
@onready var brain_levelup_piety_btn: 	Button = $"../right_panel/right_panel_vbox/brain_menu/brain_levelup_menu/brain_levelup_piety_btn"
@onready var brain_levelup_confirm_btn: Button = $"../right_panel/right_panel_vbox/brain_menu/brain_levelup_menu/brain_levelup_confirm_btn"


var bandwidth 	:= 3
var points_g	:= 0
var points_l	:= 0
var points_a	:= 0
var points_m	:= 0
var points_p	:= 0

func _display_bandwidth() -> void:
	bandwidth_title_panel.self_modulate = Color.WHITE
	bandwidth_lvl_1_panel.self_modulate = Color.WHITE
	bandwidth_lvl_2_panel.self_modulate = Color.WHITE
	bandwidth_lvl_3_panel.self_modulate = Color.WHITE
	match bandwidth:
		0:
			brain_levelup_confirm_btn.disabled 	= false
			brain_levelup_guts_btn.disabled 	= true
			brain_levelup_luck_btn.disabled 	= true
			brain_levelup_acro_btn.disabled 	= true
			brain_levelup_might_btn.disabled 	= true
			brain_levelup_piety_btn.disabled 	= true
			level_panel.self_modulate 			= Color.WHITE * 3.0
			mai_leberu_lbl.text					= Text.pr("LEVEL ") + str( B2_Playerdata.player_stats.get_effective_stat( B2_HoopzStats.STAT_BASE_LEVEL ) + 1)
		1:
			bandwidth_title_panel.self_modulate = Color.WHITE * 3.0
			bandwidth_lvl_1_panel.self_modulate = Color.WHITE * 3.0
		2:
			bandwidth_title_panel.self_modulate = Color.WHITE * 3.0
			bandwidth_lvl_2_panel.self_modulate = Color.WHITE * 3.0
		3:
			bandwidth_title_panel.self_modulate = Color.WHITE * 3.0
			bandwidth_lvl_3_panel.self_modulate = Color.WHITE * 3.0

func _reset() -> void:
	bandwidth = 3
	brain_levelup_confirm_btn.disabled 	= true
	brain_levelup_guts_btn.disabled 	= false
	brain_levelup_luck_btn.disabled 	= false
	brain_levelup_acro_btn.disabled 	= false
	brain_levelup_might_btn.disabled 	= false
	brain_levelup_piety_btn.disabled 	= false
	guts_stat_value.text		= str( B2_Playerdata.player_stats.get_effective_stat( B2_HoopzStats.STAT_BASE_GUTS ) )
	luck_stat_value.text		= str( B2_Playerdata.player_stats.get_effective_stat( B2_HoopzStats.STAT_BASE_LUCK ) )
	acro_stat_value.text		= str( B2_Playerdata.player_stats.get_effective_stat( B2_HoopzStats.STAT_BASE_AGILE ) )
	might_stat_value.text		= str( B2_Playerdata.player_stats.get_effective_stat( B2_HoopzStats.STAT_BASE_MIGHT ) )
	piety_stat_value.text		= str( B2_Playerdata.player_stats.get_effective_stat( B2_HoopzStats.STAT_BASE_PIETY ) )
	weight_stat_value.text		= str( B2_Playerdata.player_stats.get_effective_stat( B2_HoopzStats.STAT_BASE_WEIGHT ) ) + "~"
	mai_leberu_lbl.text			= Text.pr("LEVEL ") + str( B2_Playerdata.player_stats.get_effective_stat( B2_HoopzStats.STAT_BASE_LEVEL ) )
	
	guts_stat_value.self_modulate 		= Color.WHITE
	luck_stat_value.self_modulate 		= Color.WHITE
	acro_stat_value.self_modulate 		= Color.WHITE
	might_stat_value.self_modulate 		= Color.WHITE
	piety_stat_value.self_modulate 		= Color.WHITE
	weight_stat_value.self_modulate 	= Color.WHITE
	level_panel.self_modulate 			= Color.WHITE
	
	brain_level_up_guts.set_points(0)
	brain_level_up_luck.set_points(0)
	brain_level_up_acro.set_points(0)
	brain_level_up_might.set_points(0)
	brain_level_up_piety.set_points(0)
	
	points_g = 0
	points_l = 0
	points_a = 0
	points_m = 0
	points_p = 0

func _on_visibility_changed() -> void:
	if not is_node_ready(): return
	_reset()
	_display_bandwidth()

func _on_brain_levelup_confirm_btn_pressed() -> void:
	## Increase level and base starts
	B2_Playerdata.player_stats.increase_base_stat( B2_HoopzStats.STAT_BASE_LEVEL, 	1.0 )
	B2_Playerdata.player_stats.increase_base_stat( B2_HoopzStats.STAT_BASE_GUTS, 	points_g )
	B2_Playerdata.player_stats.increase_base_stat( B2_HoopzStats.STAT_BASE_LUCK, 	points_l )
	B2_Playerdata.player_stats.increase_base_stat( B2_HoopzStats.STAT_BASE_AGILE, 	points_a )
	B2_Playerdata.player_stats.increase_base_stat( B2_HoopzStats.STAT_BASE_MIGHT, 	points_m )
	B2_Playerdata.player_stats.increase_base_stat( B2_HoopzStats.STAT_BASE_PIETY, 	points_p )
	B2_Sound.play( "sn_sonic2_cash" )
	_reset()

## Button stuff
func _on_brain_levelup_guts_btn_pressed() -> void:
	points_g += bandwidth
	brain_level_up_guts.set_points(bandwidth)
	guts_stat_value.self_modulate 		= Color.GREEN
	guts_stat_value.text				= str( B2_Playerdata.player_stats.get_effective_stat( B2_HoopzStats.STAT_BASE_GUTS ) + bandwidth )
	bandwidth -= 1
	_display_bandwidth()
	brain_levelup_guts_btn.disabled = true
	B2_Sound.play( "utility_button_analogclick" )
	
func _on_brain_levelup_luck_btn_pressed() -> void:
	points_l += bandwidth
	brain_level_up_luck.set_points(bandwidth)
	luck_stat_value.self_modulate 		= Color.GREEN
	luck_stat_value.text				= str( B2_Playerdata.player_stats.get_effective_stat( B2_HoopzStats.STAT_BASE_LUCK ) + bandwidth )
	bandwidth -= 1
	_display_bandwidth()
	brain_levelup_luck_btn.disabled = true
	B2_Sound.play( "utility_button_analogclick" )

func _on_brain_levelup_acro_btn_pressed() -> void:
	points_a += bandwidth
	brain_level_up_acro.set_points(bandwidth)
	acro_stat_value.self_modulate 		= Color.GREEN
	acro_stat_value.text				= str( B2_Playerdata.player_stats.get_effective_stat( B2_HoopzStats.STAT_BASE_AGILE ) + bandwidth )
	bandwidth -= 1
	_display_bandwidth()
	brain_levelup_acro_btn.disabled = true
	B2_Sound.play( "utility_button_analogclick" )
	
func _on_brain_levelup_might_btn_pressed() -> void:
	points_m += bandwidth
	brain_level_up_might.set_points(bandwidth)
	might_stat_value.self_modulate 		= Color.GREEN
	might_stat_value.text				= str( B2_Playerdata.player_stats.get_effective_stat( B2_HoopzStats.STAT_BASE_MIGHT ) + bandwidth )
	bandwidth -= 1
	_display_bandwidth()
	brain_levelup_might_btn.disabled = true
	B2_Sound.play( "utility_button_analogclick" )

func _on_brain_levelup_piety_btn_pressed() -> void:
	points_p += bandwidth
	brain_level_up_piety.set_points(bandwidth)
	piety_stat_value.self_modulate 		= Color.GREEN
	piety_stat_value.text				= str( B2_Playerdata.player_stats.get_effective_stat( B2_HoopzStats.STAT_BASE_PIETY ) + bandwidth )
	bandwidth -= 1
	_display_bandwidth()
	brain_levelup_piety_btn.disabled = true
	B2_Sound.play( "utility_button_analogclick" )
