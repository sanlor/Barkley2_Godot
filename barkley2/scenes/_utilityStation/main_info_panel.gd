extends Control

## Static nodes - mostly here to apply Text.pr(), used in the highly important al-bhed translation.
@onready var name_title: Label = $status/name/name_value
@onready var vitals_title: Label = $status/vitals/vitals_title
@onready var hp_title: Label = $status/hp/hp_title
@onready var level_title: Label = $status/level/level_title
@onready var g_title: Label = $glamp/g/g_title
@onready var l_title: Label = $glamp/l/l_title
@onready var a_title: Label = $glamp/a/a_title
@onready var m_title: Label = $glamp/m/m_title
@onready var p_title: Label = $glamp/p/p_title
@onready var g_sub: Label = $glamp/g/g_sub
@onready var l_sub: Label = $glamp/l/l_sub
@onready var a_sub: Label = $glamp/a/a_sub
@onready var m_sub: Label = $glamp/m/m_sub
@onready var p_sub: Label = $glamp/p/p_sub
@onready var tab_glamp: Label = $glamp/tab_name/tab_label
@onready var tab_datum: Label = $datum/tab_name/tab_label
@onready var gumption_title: Label = $datum/gumption/gumption_title
@onready var gumshoe_title: Label = $datum/gumshoe/gumshoe_title
@onready var beard_title: Label = $datum/beard/beard_title
@onready var freewill_title: Label = $datum/free_will/freewill_title
@onready var mood_title: Label = $datum/mood/mood_title
@onready var poise_title: Label = $datum/poise/poise_title
@onready var voltage_title: Label = $datum/energy/voltage_title
@onready var amp_title: Label = $datum/energy/amp_title
@onready var tab_trans: Label = $trans/tab_name/tab_label
@onready var tab_res: Label = $resistances/tab_name/tab_label

@onready var res_blip: TextureRect = $resistances/res_graph/res_blip
@onready var res_blip_2: TextureRect = $resistances/res_graph/res_blip2
@onready var res_blip_3: TextureRect = $resistances/res_graph/res_blip3
@onready var res_blip_4: TextureRect = $resistances/res_graph/res_blip4
@onready var res_blip_5: TextureRect = $resistances/res_graph/res_blip5

@onready var res_cosmic: TextureRect = $resistances/res_list/res_cosmic
@onready var res_mental: TextureRect = $resistances/res_list/res_mental
@onready var res_cyber: TextureRect = $resistances/res_list/res_cyber
@onready var res_bio: TextureRect = $resistances/res_list/res_bio
@onready var res_zauber: TextureRect = $resistances/res_list/res_zauber

@onready var tab_equip: Label = $equipment/tab_name/tab_label

## All nodes all the time.
@onready var name_value: Label = $status/name/name_value
@onready var hp_value: Label = $status/hp/hp_value
@onready var level_value: Label = $status/level/level_value
@onready var g_value: Label = $glamp/g/g_value
@onready var l_value: Label = $glamp/l/l_value
@onready var a_value: Label = $glamp/a/a_value
@onready var m_value: Label = $glamp/m/m_value
@onready var p_value: Label = $glamp/p/p_value
@onready var gumption_value: Label = $datum/gumption/gumption_value
@onready var gumshoe_value: Label = $datum/gumshoe/gumshoe_value
@onready var beard_value: Label = $datum/beard/beard_value
@onready var freewill_value: Label = $datum/free_will/freewill_value
@onready var mood_value: Label = $datum/mood/mood_value
@onready var voltage_value: Label = $datum/energy/voltage_value
@onready var amp_value: Label = $datum/energy/amp_value
@onready var defense_value: Label = $resistances/defense/defense_value

@onready var res_cosmic_value: Label = $resistances/res_list/res_cosmic_value
@onready var res_mental_value: Label = $resistances/res_list/res_mental_value
@onready var res_cyber_value: Label = $resistances/res_list/res_cyber_value
@onready var res_bio_value: Label = $resistances/res_list/res_bio_value
@onready var res_zauber_value: Label = $resistances/res_list/res_zauber_value

@onready var gun_texture: TextureRect = $equipment/gun/gun_texture
@onready var gun_weight: Label = $equipment/gun/gun_weight
@onready var gun_name: Label = $equipment/gun/gun_name

@onready var jerkin_value: Label = $equipment/jerkin/jerkin_value
@onready var helm_value: Label = $equipment/helm/helm_value

@onready var hud_weight_number: TextureRect = $weight/weight/hud_weight/hud_weight_number

@export var bullshit_noise : FastNoiseLite ## Noise used for the voltage and amp changes. unneeded, but fun.

func _ready() -> void:
	_set_title_name()
	_set_menu_values()
	
func update_menu() -> void:
	if not is_node_ready():
		return
	_set_menu_values()

func _pr( node : Label ) -> void:
	node.text = Text.pr(node.text)

## This is very important. not habing the correct al-bhed translation is game breaking.
func _set_title_name() -> void:
	_pr(name_title)
	_pr(vitals_title)
	_pr(hp_title)
	_pr(level_title)
	_pr(g_title)
	_pr(l_title)
	_pr(a_title)
	_pr(m_title)
	_pr(p_title)
	_pr(g_sub)
	_pr(l_sub)
	_pr(a_sub)
	_pr(m_sub)
	_pr(p_sub)
	_pr(tab_glamp)
	_pr(tab_datum)
	_pr(gumption_title)
	_pr(gumshoe_title)
	_pr(beard_title)
	_pr(freewill_title)
	_pr(mood_title)
	_pr(poise_title)
	_pr(voltage_title)
	_pr(amp_title)
	_pr(tab_trans)
	_pr(tab_res)

	res_blip.modulate = B2_Gamedata.c_cosmic
	res_blip_2.modulate = B2_Gamedata.c_mental
	res_blip_3.modulate = B2_Gamedata.c_cyber
	res_blip_4.modulate = B2_Gamedata.c_bio
	res_blip_5.modulate = B2_Gamedata.c_zauber

	res_cosmic.modulate = B2_Gamedata.c_cosmic
	res_mental.modulate = B2_Gamedata.c_mental
	res_cyber.modulate = B2_Gamedata.c_cyber
	res_bio.modulate = B2_Gamedata.c_bio
	res_zauber.modulate = B2_Gamedata.c_zauber

	_pr(tab_equip)
	
func _set_menu_values() -> void:
	name_value.text				= Text.pr( B2_Playerdata.Quest("playerNameFull", null, "Undefined") )
	hp_value.text				= str( int(B2_Playerdata.player_stats.get_effective_stat("curr_health")) )
	level_value.text			= str( int(B2_Playerdata.player_stats.get_effective_stat("lvl")) )
	g_value.text				= str( B2_Playerdata.Stat( B2_HoopzStats.STAT_BASE_GUTS ) ).pad_decimals(0)
	l_value.text				= str( B2_Playerdata.Stat( B2_HoopzStats.STAT_BASE_LUCK ) ).pad_decimals(0)
	a_value.text				= str( B2_Playerdata.Stat( B2_HoopzStats.STAT_BASE_AGILE ) ).pad_decimals(0)
	m_value.text				= str( B2_Playerdata.Stat( B2_HoopzStats.STAT_BASE_MIGHT ) ).pad_decimals(0)
	p_value.text				= str( B2_Playerdata.Stat( B2_HoopzStats.STAT_BASE_PIETY ) ).pad_decimals(0)
	gumption_value.text			= Text.pr( "73%" )
	gumshoe_value.text			= str( B2_Playerdata.Quest("GumshoeLevel", null, 1) )
	beard_value.text			= Text.pr( ["Baby Face", "Itchy", "Follicled"].pick_random() )
	freewill_value.text			= Text.pr( "ON" )
	mood_value.text				= Text.pr( "CRESTFALLEN" )
	defense_value.text			= str( B2_Playerdata.player_stats.get_effective_stat( B2_HoopzStats.STAT_BASE_RESISTANCE_NORMAL ) ).pad_zeros(2)

	res_cosmic_value.text		= str( B2_Playerdata.player_stats.get_effective_stat( B2_HoopzStats.STAT_BASE_RESISTANCE_COSMIC ) ).pad_zeros(2)
	res_mental_value.text		= str( B2_Playerdata.player_stats.get_effective_stat( B2_HoopzStats.STAT_BASE_RESISTANCE_MENTAL ) ).pad_zeros(2)
	res_cyber_value.text		= str( B2_Playerdata.player_stats.get_effective_stat( B2_HoopzStats.STAT_BASE_RESISTANCE_CYBER ) ).pad_zeros(2)
	res_bio_value.text			= str( B2_Playerdata.player_stats.get_effective_stat( B2_HoopzStats.STAT_BASE_RESISTANCE_BIO ) ).pad_zeros(2)
	res_zauber_value.text		= str( B2_Playerdata.player_stats.get_effective_stat( B2_HoopzStats.STAT_BASE_RESISTANCE_ZAUBER ) ).pad_zeros(2)

	gun_texture.texture			= B2_Gun.get_current_gun().get_weapon_hud_sprite()
	gun_weight.text				= str( int(B2_Gun.get_current_gun().wgt) ) + "~"
	gun_name.text				= B2_Gun.get_current_gun().get_short_name()

	jerkin_value.text			= B2_Jerkin.get_current_jerkin()
	helm_value.text				= Text.pr( "Bonnet" )
	
	volt_amp()
	#hud_weight_number.position

func volt_amp() -> void:
	voltage_value.text			= str( snappedf(14.0 + bullshit_noise.get_noise_1d(420) * 0.50, 0.1) ) + "V"
	amp_value.text				= str( snappedf(10.5 + bullshit_noise.get_noise_1d(069) * 0.25, 0.1) ) + "A"
	
func _process( delta: float ) -> void:
	if bullshit_noise:
		bullshit_noise.offset.x += delta * 0.2
		volt_amp()

func _on_visibility_changed() -> void:
	update_menu()
