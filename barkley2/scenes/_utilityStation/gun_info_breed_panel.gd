extends B2_UtilityPanel

@onready var some_gay_shit: Control = $breed_data/some_gay_shit

@onready var gun_breed_gun_1_btn: 		Button = $"../right_panel/right_panel_vbox/gun_menu/gun_breed_menu/gun_breed_gun1_btn"
@onready var gun_breed_gun_2_btn: 		Button = $"../right_panel/right_panel_vbox/gun_menu/gun_breed_menu/gun_breed_gun2_btn"
@onready var gun_breed_commence_btn: 	Button = $"../right_panel/right_panel_vbox/gun_menu/gun_breed_menu/gun_breed_commence_btn"
@onready var gun_breed_select_btn: 		Button = $"../right_panel/right_panel_vbox/gun_menu/gun_breed_menu/gun_breed_select_btn"

@onready var no_gun_1_selected_lbl: 	Label = $breed_data/top_gun/top_gun_panel/no_gun_selected_lbl
@onready var no_gun_2_selected_lbl: 	Label = $breed_data/bottom_gun/bottom_gun_panel/no_gun_selected_lbl

@onready var gun_info_panel: 			B2_UtilityPanel = $gun_info_panel
@onready var breed_data: 				B2_UtilityPanel = $breed_data

@onready var top_gene: 					Control = $breed_data/top_gene
@onready var bottom_gene: 				Control = $breed_data/bottom_gene

@onready var brain_breed_gun_data_1: Control = $breed_data/top_gun/top_gun_panel/brain_breed_gun_data
@onready var brain_breed_gun_data_2: Control = $breed_data/bottom_gun/bottom_gun_panel/brain_breed_gun_data

@onready var compatibility_graph: 		Control = $breed_data/compatibility/bottom_gun_panel/compatibility_graph

enum SEL{NADA,GUN1,GUN2}
var curr_SEL := SEL.NADA
var selected_gun_1 : B2_Weapon
var selected_gun_2 : B2_Weapon

func _ready() -> void:
	gun_info_panel.hide_panel()

func _reset() -> void:
	selected_gun_1 = null
	selected_gun_2 = null

func _on_visibility_changed() -> void:
	if is_node_ready():
		_reset()
		_update_screen()
		breed_data.show_panel()

func _update_screen() -> void:
	gun_breed_select_btn.hide()
	
	if selected_gun_1:
		no_gun_1_selected_lbl.hide()
		brain_breed_gun_data_1.show()
		gun_breed_gun_1_btn.text = selected_gun_1.get_short_name()
		top_gene.generate_gene( selected_gun_1.get_full_name() )
		some_gay_shit.update_top_influence( selected_gun_1.get_full_name() )
		brain_breed_gun_data_1.setup( selected_gun_1 )
	else:
		no_gun_1_selected_lbl.show()
		brain_breed_gun_data_1.hide()
		gun_breed_gun_1_btn.text = "Empty"
		top_gene.hide_gene()
		
	if selected_gun_2:
		no_gun_2_selected_lbl.hide()
		brain_breed_gun_data_2.show()
		gun_breed_gun_2_btn.text = selected_gun_2.get_short_name()
		bottom_gene.generate_gene( selected_gun_2.get_full_name() )
		some_gay_shit.update_bottom_influence( selected_gun_2.get_full_name() )
		brain_breed_gun_data_2.setup( selected_gun_2 )
	else:
		no_gun_2_selected_lbl.show()
		brain_breed_gun_data_2.hide()
		gun_breed_gun_2_btn.text = "Empty"
		bottom_gene.hide_gene()
	
	gun_breed_gun_1_btn.disabled = not B2_Gun.has_any_guns()
	gun_breed_gun_2_btn.disabled = not B2_Gun.has_any_guns()
	
	if selected_gun_1 and selected_gun_2:
		compatibility_graph.show()
		compatibility_graph.populate_graph( hash(selected_gun_1.get_full_name()) * hash(selected_gun_2.get_full_name()), 0.5 ) ## TODO
	else:
		compatibility_graph.hide()
	
	## Enable button if both guns are selected.
	gun_breed_commence_btn.disabled = not (selected_gun_1 and selected_gun_2)
	
func _on_gun_breed_gun_1_btn_pressed() -> void:
	gun_info_panel.show_panel()
	breed_data.hide_panel()
	gun_breed_select_btn.show()
	curr_SEL = SEL.GUN1
	B2_Sound.play( "utility_button_click" )

func _on_gun_breed_gun_2_btn_pressed() -> void:
	gun_info_panel.show_panel()
	breed_data.hide_panel()
	gun_breed_select_btn.show()
	curr_SEL = SEL.GUN2
	B2_Sound.play( "utility_button_click" )

func _on_gun_breed_commence_btn_pressed() -> void:
	pass # Replace with function body.

func _on_gun_breed_select_btn_pressed() -> void:
	match curr_SEL:
		SEL.GUN1:
			if gun_info_panel.selected_gun:
				selected_gun_1 = gun_info_panel.selected_gun
				if selected_gun_1 == selected_gun_2: ## Avoid selecting duplicated guns
					selected_gun_2 = null
		SEL.GUN2:
			if gun_info_panel.selected_gun:
				selected_gun_2 = gun_info_panel.selected_gun
				if selected_gun_1 == selected_gun_2: ## Avoid selecting duplicated guns
					selected_gun_1 = null
	
	gun_info_panel.hide_panel()
	breed_data.show_panel()
	_update_screen()
	B2_Sound.play( "utility_button_analogclick" )
