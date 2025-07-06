extends B2_UtilityPanel

enum STATE{NOTHING,EQUIP_HELM,EQUIP_JERKIN}
var curr_STATE := STATE.NOTHING
enum EQUIP{HELM,JERKIN}

const EQUIP_JERKIN_SELECTION 	= preload("res://barkley2/scenes/_utilityStation/equip_jerkin_selection.tscn")
const EQUIP_NO_EQUIP 			= preload("res://barkley2/scenes/_utilityStation/equip_no_equip.tscn")

@onready var pocket_stat_value: 	Label = $hoopz_stat/pockets/vbox/stat_value
@onready var weight_stat_value: 	Label = $hoopz_stat/weight/vbox/stat_value
@onready var guts_stat_value: 		Label = $hoopz_stat/guts/vbox/stat_value
@onready var luck_stat_value: 		Label = $hoopz_stat/luck/vbox/stat_value
@onready var acro_stat_value: 		Label = $hoopz_stat/acro/vbox/stat_value
@onready var might_stat_value: 		Label = $hoopz_stat/might/vbox/stat_value
@onready var piety_stat_value: 		Label = $hoopz_stat/piety/vbox/stat_value

@onready var defense_value: 		Label = $resistances/defense/defense_value
@onready var bio_res_value: 		Label = $resistances/bio_panel/vbox/res_value
@onready var cyber_res_value: 		Label = $resistances/cyber_panel/vbox/res_value
@onready var mental_res_value: 		Label = $resistances/mental_panel/vbox/res_value
@onready var kosmic_res_value: 		Label = $resistances/kosmic_panel/vbox/res_value
@onready var zauber_res_value: 		Label = $resistances/zauber_panel/vbox/res_value

@onready var equip_btn: 			Button = $"../right_panel/right_panel_vbox/equip_btn"
@onready var equip_helmet_btn: 		Button = $"../right_panel/right_panel_vbox/equip_menu/equip_helmet_btn"
@onready var equip_jerkin_btn: 		Button = $"../right_panel/right_panel_vbox/equip_menu/equip_jerkin_btn"
@onready var equip_equip_btn: 		Button = $"../right_panel/right_panel_vbox/equip_menu/equip_equip_btn"

@onready var helm: 					Control = $helm
@onready var jerkin: 				Control = $jerkin

@onready var equip_selection: 		ScrollContainer = $equip_selection
@onready var equip_selection_vbox: 	VBoxContainer = $equip_selection/equip_selection_vbox

var selected_type					:= EQUIP.HELM
var selected_helm					:= ""
var selected_jerkin					:= ""

func _on_visibility_changed() -> void:
	if is_node_ready() and visible:
		_update_stats()
		
		_change_state( STATE.NOTHING )

func _select_equip( equip_name : String, equip_type : EQUIP ) -> void:
	match equip_type:
		EQUIP.HELM:
			selected_helm = equip_name
			selected_type = equip_type
		EQUIP.JERKIN:
			selected_jerkin = equip_name
			selected_type = equip_type
			_compare_jerkin_stats( equip_name )
		_:
			breakpoint
	#print(equip_name)

func _compare_jerkin_stats( jerkin_name : String ) -> void:
	pocket_stat_value.text 		= str( B2_Jerkin.get_jerkin_stats(jerkin_name)["Pkt"] )
	_compare_color(pocket_stat_value, B2_Jerkin.get_jerkin_stats()["Pkt"], B2_Jerkin.get_jerkin_stats(jerkin_name)["Pkt"] )
		
	defense_value.text		= str( B2_Playerdata.player_stats.get_base_stat( B2_HoopzStats.STAT_BASE_RESISTANCE_NORMAL ) + B2_Jerkin.get_jerkin_stats(jerkin_name)["Normal"] ).pad_zeros(2)
	_compare_color(defense_value, B2_Playerdata.player_stats.get_effective_stat( B2_HoopzStats.STAT_BASE_RESISTANCE_NORMAL ), int(defense_value.text) )
	
	kosmic_res_value.text	= str( B2_Playerdata.player_stats.get_base_stat( B2_HoopzStats.STAT_BASE_RESISTANCE_COSMIC ) + B2_Jerkin.get_jerkin_stats(jerkin_name)["Kosmic"] ).pad_zeros(2)
	_compare_color(kosmic_res_value, B2_Playerdata.player_stats.get_effective_stat( B2_HoopzStats.STAT_BASE_RESISTANCE_COSMIC ), int(kosmic_res_value.text) )
	
	mental_res_value.text	= str( B2_Playerdata.player_stats.get_base_stat( B2_HoopzStats.STAT_BASE_RESISTANCE_MENTAL ) + B2_Jerkin.get_jerkin_stats(jerkin_name)["Mental"] ).pad_zeros(2)
	_compare_color(mental_res_value, B2_Playerdata.player_stats.get_effective_stat( B2_HoopzStats.STAT_BASE_RESISTANCE_MENTAL ), int(mental_res_value.text) )
	
	cyber_res_value.text	= str( B2_Playerdata.player_stats.get_base_stat( B2_HoopzStats.STAT_BASE_RESISTANCE_CYBER ) + B2_Jerkin.get_jerkin_stats(jerkin_name)["Cyber"] ).pad_zeros(2)
	_compare_color(cyber_res_value, B2_Playerdata.player_stats.get_effective_stat( B2_HoopzStats.STAT_BASE_RESISTANCE_CYBER ), int(cyber_res_value.text) )
	
	bio_res_value.text		= str( B2_Playerdata.player_stats.get_base_stat( B2_HoopzStats.STAT_BASE_RESISTANCE_BIO ) + B2_Jerkin.get_jerkin_stats(jerkin_name)["Bio"] ).pad_zeros(2)
	_compare_color(bio_res_value, B2_Playerdata.player_stats.get_effective_stat( B2_HoopzStats.STAT_BASE_RESISTANCE_BIO ), int(bio_res_value.text) )
	
	zauber_res_value.text	= str( B2_Playerdata.player_stats.get_base_stat( B2_HoopzStats.STAT_BASE_RESISTANCE_ZAUBER ) + B2_Jerkin.get_jerkin_stats(jerkin_name)["Zauber"] ).pad_zeros(2)
	_compare_color(zauber_res_value, B2_Playerdata.player_stats.get_effective_stat( B2_HoopzStats.STAT_BASE_RESISTANCE_ZAUBER ), int(zauber_res_value.text) )
	
	weight_stat_value.text		= str( B2_Playerdata.player_stats.get_base_stat( B2_HoopzStats.STAT_BASE_WEIGHT ) + B2_Jerkin.get_jerkin_stats(jerkin_name)["Wgt"] )
	_compare_color(weight_stat_value, int(weight_stat_value.text), B2_Playerdata.player_stats.get_effective_stat( B2_HoopzStats.STAT_BASE_WEIGHT ) )
	weight_stat_value.text += "~"

func _compare_color( node : Label, original_value : int, new_value : int ) -> void:
	if original_value < new_value:		node.modulate = Color.GREEN
	elif original_value > new_value:	node.modulate = Color.RED
	else:								node.modulate = Color.GRAY

func _update_stats() -> void:
	pocket_stat_value.text 		= str( B2_Jerkin.get_jerkin_stats()["Pkt"] )
	pocket_stat_value.modulate = Color.WHITE
	
	kosmic_res_value.text		= str( B2_Playerdata.player_stats.get_effective_stat( B2_HoopzStats.STAT_BASE_RESISTANCE_COSMIC ) ).pad_zeros(2)
	mental_res_value.text		= str( B2_Playerdata.player_stats.get_effective_stat( B2_HoopzStats.STAT_BASE_RESISTANCE_MENTAL ) ).pad_zeros(2)
	cyber_res_value.text		= str( B2_Playerdata.player_stats.get_effective_stat( B2_HoopzStats.STAT_BASE_RESISTANCE_CYBER ) ).pad_zeros(2)
	bio_res_value.text			= str( B2_Playerdata.player_stats.get_effective_stat( B2_HoopzStats.STAT_BASE_RESISTANCE_BIO ) ).pad_zeros(2)
	zauber_res_value.text		= str( B2_Playerdata.player_stats.get_effective_stat( B2_HoopzStats.STAT_BASE_RESISTANCE_ZAUBER ) ).pad_zeros(2)
	defense_value.text			= str( B2_Playerdata.player_stats.get_effective_stat( B2_HoopzStats.STAT_BASE_RESISTANCE_NORMAL ) ).pad_zeros(2)
	kosmic_res_value.modulate 	= Color.WHITE
	mental_res_value.modulate 	= Color.WHITE
	cyber_res_value.modulate 	= Color.WHITE
	bio_res_value.modulate 		= Color.WHITE
	zauber_res_value.modulate 	= Color.WHITE
	defense_value.modulate 		= Color.WHITE
	
	weight_stat_value.text		= str( B2_Playerdata.player_stats.get_effective_stat( B2_HoopzStats.STAT_BASE_WEIGHT ) ) + "~"
	weight_stat_value.modulate	= Color.WHITE
	
	guts_stat_value.text		= str( B2_Playerdata.player_stats.get_effective_stat( B2_HoopzStats.STAT_BASE_GUTS ) )
	luck_stat_value.text		= str( B2_Playerdata.player_stats.get_effective_stat( B2_HoopzStats.STAT_BASE_LUCK ) )
	acro_stat_value.text		= str( B2_Playerdata.player_stats.get_effective_stat( B2_HoopzStats.STAT_BASE_AGILE ) )
	might_stat_value.text		= str( B2_Playerdata.player_stats.get_effective_stat( B2_HoopzStats.STAT_BASE_MIGHT ) )
	piety_stat_value.text		= str( B2_Playerdata.player_stats.get_effective_stat( B2_HoopzStats.STAT_BASE_PIETY ) )
		
func _change_state( state : STATE ) -> void:
	selected_jerkin 			= ""
	selected_helm 				= ""
	equip_btn.disabled 			= false
	equip_jerkin_btn.disabled 	= false
	equip_helmet_btn.disabled 	= false
	equip_selection.hide()
	helm.hide()
	jerkin.hide()
	equip_helmet_btn.hide()
	equip_jerkin_btn.hide()
	equip_equip_btn.hide()
	match state:
		STATE.NOTHING:
			equip_btn.disabled = true
			helm.show()
			jerkin.show()
			_update_stats()
			equip_helmet_btn.show()
			equip_jerkin_btn.show()
			equip_helmet_btn.grab_focus()
		STATE.EQUIP_JERKIN:
			_populate_equip_menu( EQUIP.JERKIN )
			equip_jerkin_btn.show()
			equip_jerkin_btn.disabled = true
			equip_selection.show()
			equip_equip_btn.show()
		STATE.EQUIP_HELM:
			_populate_equip_menu( EQUIP.HELM )
			equip_helmet_btn.show()
			equip_helmet_btn.disabled = true
			equip_selection.show()
			equip_equip_btn.show()
	curr_STATE = state

func _populate_equip_menu( equip : EQUIP ) -> void:
	for i in equip_selection_vbox.get_children():
		i.queue_free()
		
	var nothing_to_display := true
	match equip:
		EQUIP.JERKIN:
			for i in B2_Jerkin.list_jerkin():
				## Skip equiped jerkin
				if B2_Jerkin.get_current_jerkin() == i:
					continue
					
				var e := EQUIP_JERKIN_SELECTION.instantiate()
				e.my_equip_name = i
				e.equip_type = e.TYPE.JERKIN
				e.selected_equipment.connect( _select_equip.bind(i, EQUIP.JERKIN) )
				equip_selection_vbox.add_child( e )
				nothing_to_display = false
		EQUIP.HELM:
			pass
	
	if nothing_to_display:
		equip_selection_vbox.add_child( EQUIP_NO_EQUIP.instantiate() )
		equip_equip_btn.disabled = true
	else:
		## Select first item
		await get_tree().process_frame
		equip_selection_vbox.get_children().front().select()
		equip_equip_btn.disabled = false

func _on_equip_helmet_btn_pressed() -> void:
	_change_state( STATE.EQUIP_HELM )
	B2_Sound.play( "utility_button_click" )

func _on_equip_jerkin_btn_pressed() -> void:
	_change_state( STATE.EQUIP_JERKIN )
	B2_Sound.play( "utility_button_click" )

func _on_equip_equip_btn_pressed() -> void:
	match selected_type:
		EQUIP.HELM:
			if selected_helm:		pass; _change_state( STATE.NOTHING ); B2_Sound.play( "utility_button_click" )
			else: push_warning("cant equip selected Helm: %s." % selected_helm)
		EQUIP.JERKIN:
			if selected_jerkin:		B2_Jerkin.equip_jerkin( selected_jerkin ); _change_state( STATE.NOTHING ); B2_Sound.play( "utility_button_click" )
			else: push_warning("cant equip selected Jerkin: %s." % selected_jerkin)
		_:
			breakpoint

func _on_equip_btn_pressed() -> void:
	_change_state( STATE.NOTHING )
	B2_Sound.play( "utility_button_click" )
