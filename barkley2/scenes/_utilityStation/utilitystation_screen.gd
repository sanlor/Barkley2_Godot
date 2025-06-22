extends CanvasLayer

## Handles the UI for the Utility Station.
# Check ustation, Utility and o_utilitystation
## NOTE I think this is the largest scene I ever created.

signal set_color( color : Color )
signal set_bg_intensity( intensity : float ) ## Set glow intensity for the Background lines
signal set_fg_intensity( intensity : float ) ## Set glow intensity for the Foreground lines
signal flickered( alpha : float )

# Utility Menu Settings
const SETTINGUTILITYSMELT 			:= 50 			# How much smelt you get per gun - balance 30->50 on 031719 - bhroom
const SETTINGUTILITYTEXTALPHA 		:= 0.8 			# Alpha of all text
const SETTINGUTILITYSPRITEALPHA 	:= 0.8 			# Alpha of all sprites
const SETTINGUTILITYALPHABACK 		:= 0.05 		# Alpha of grid BG
const SETTINGUTILITYALPHAGLOW 		:= 0.075 		# Alpha of glowing (text, grid)
const SETTINGUTILITYALPHABORDER 	:= 0.15 		# Alpha of foreground grids, lines, etc
#const settingUtilityHue 			:= 80 			# Menu hue - Set in player identity by gumball
const SETTINGUTILITYMONO 			:= 0.15 		# How colorful the menu is, 0 being more B&W 1 being full color
const UTILITYALPHA 					:= 0

var style_box_utility = preload("res://barkley2/themes/style_box_utility.tres")

## Buttons
@onready var main_btn: Button = $frame/right_panel/right_panel_vbox/main_btn

@onready var gun_btn: 		Button 									= $frame/right_panel/right_panel_vbox/gun_btn
@onready var gun_menu: 		VBoxContainer 							= $frame/right_panel/right_panel_vbox/gun_menu
@onready var gun_bando_btn: 			Button 						= $frame/right_panel/right_panel_vbox/gun_menu/gun_bando_btn
@onready var gun_bando_menu: 					VBoxContainer 		= $frame/right_panel/right_panel_vbox/gun_menu/gun_bando_menu
@onready var gun_bando_rename_btn: 				Button 				= $frame/right_panel/right_panel_vbox/gun_menu/gun_bando_menu/gun_bando_rename_btn

@onready var gun_bag_btn: 		Button 				= $frame/right_panel/right_panel_vbox/gun_menu/gun_bag_btn
@onready var gun_bag_menu: 		VBoxContainer 		= $frame/right_panel/right_panel_vbox/gun_menu/gun_bag_menu
@onready var gun_bag_fave_btn: 			Button 		= $frame/right_panel/right_panel_vbox/gun_menu/gun_bag_menu/gun_bag_fave_btn
@onready var gun_bag_promote_btn: 		Button 		= $frame/right_panel/right_panel_vbox/gun_menu/gun_bag_menu/gun_bag_promote_btn

@onready var gun_smelt_btn: 	Button 				= $frame/right_panel/right_panel_vbox/gun_menu/gun_smelt_btn
@onready var gun_smelt_menu: 	VBoxContainer 		= $frame/right_panel/right_panel_vbox/gun_menu/gun_smelt_menu
@onready var gun_smelt_current_btn: 	Button 		= $frame/right_panel/right_panel_vbox/gun_menu/gun_smelt_menu/gun_smelt_current_btn
@onready var gun_smelt_empty_btn: 		Button 		= $frame/right_panel/right_panel_vbox/gun_menu/gun_smelt_menu/gun_smelt_empty_btn
@onready var gun_smelt_unfaves_btn: 	Button 		= $frame/right_panel/right_panel_vbox/gun_menu/gun_smelt_menu/gun_smelt_unfaves_btn
@onready var gun_smelt_inbag_btn: 		Button 		= $frame/right_panel/right_panel_vbox/gun_menu/gun_smelt_menu/gun_smelt_inbag_btn

@onready var gun_reload_btn: 	Button = $frame/right_panel/right_panel_vbox/gun_menu/gun_reload_btn
@onready var gun_reload_menu: 	VBoxContainer = $frame/right_panel/right_panel_vbox/gun_menu/gun_reload_menu

@onready var gun_breed_btn: 	Button = $frame/right_panel/right_panel_vbox/gun_menu/gun_breed_btn

@onready var candy_btn: 		Button = $frame/right_panel/right_panel_vbox/candy_btn
@onready var candy_menu: 		VBoxContainer = $frame/right_panel/right_panel_vbox/candy_menu
@onready var candy_make_btn: 	Button = $frame/right_panel/right_panel_vbox/candy_menu/make_btn

@onready var brain_btn: 					Button = $frame/right_panel/right_panel_vbox/brain_btn
@onready var brain_menu: 					VBoxContainer = $frame/right_panel/right_panel_vbox/brain_menu
@onready var brain_vidcon_btn: 				Button = $frame/right_panel/right_panel_vbox/brain_menu/vidcon_btn
@onready var brain_vidcon_unbox_btn: 		Button = $frame/right_panel/right_panel_vbox/brain_menu/unbox_btn


@onready var equip_btn: 		Button = $frame/right_panel/right_panel_vbox/equip_btn
@onready var equip_menu: 		VBoxContainer = $frame/right_panel/right_panel_vbox/equip_menu

@onready var inventory_btn: 	Button = $frame/right_panel/right_panel_vbox/inventory_btn
@onready var inventory_menu: 	VBoxContainer = $frame/right_panel/right_panel_vbox/inventory_menu

@onready var dwarf_btn: 		Button = $frame/right_panel/right_panel_vbox/dwarf_btn
@onready var unplug_btn: 		Button = $frame/right_panel/right_panel_vbox/unplug_btn

@onready var right_panel: ScrollContainer = $frame/right_panel

## Left Info panel
@onready var main_info_panel: 				B2_UtilityPanel = $frame/main_info_panel
@onready var gun_info_panel: 				B2_UtilityPanel = $frame/gun_info_panel
@onready var gun_info_bando_panel: 			B2_UtilityPanel = $frame/gun_info_bando_panel
@onready var gun_info_bando_rename_panel: 	B2_UtilityPanel = $frame/gun_info_bando_rename_panel
@onready var gun_info_bag_panel: 			B2_UtilityPanel = $frame/gun_info_bag_panel
@onready var gun_info_bag_rename_panel: 	B2_UtilityPanel = $frame/gun_info_bag_rename_panel
@onready var gun_info_smelt_panel: 			B2_UtilityPanel = $frame/gun_info_smelt_panel
@onready var candy_panel: 					B2_UtilityPanel = $frame/candy_panel
@onready var brain_info_panel: 				B2_UtilityPanel = $frame/brain_info_panel
@onready var brain_vidcon_panel: 			B2_UtilityPanel = $frame/brain_vidcon_panel
@onready var inventory_panel: 				B2_UtilityPanel = $frame/inventory_panel

## Menu control
enum {
	MAIN,
		GUN,
			GUN_BANDO,
				GUN_BANDO_RENAME,
			GUN_BAG,
				GUN_BAG_PROMOTE,
			GUN_SMELT,
			GUN_RELOAD,
			GUN_BREED, ## Oh boy...
		CANDY,
		BRAIN,
			VIDCONS,
		EQUIP,
		INV,
		DWARF, ## Oh boy x10
		UNPLUG
	}
var menu_state := MAIN

# Smelt data
var smeltGain 		:= SETTINGUTILITYSMELT; ## Link to Settings
var smeltEmpty 		:= "Are you sure you want to smelt all empty Gun'sbag guns?"
var smeltUnfaves 	:= "Are you sure you want to smelt all unfavorited Gun'sbag guns?"
var smeltAll 		:= "Are you sure you want to smelt all Gun'sbag guns?"
var renameError 	:= "Gun name already exists in bando."
var renameShort 	:= "Gun names must be 4 characters long."
var bandoFull 		:= "Bando is full. Smelt a bando gun to make space for promotion."

# Color of blip icons for the Bando
var gunCol := [
	Color.from_rgba8(241, 217, 95),
	Color.from_rgba8(253, 89, 100),
	Color.from_rgba8(122, 83, 10),
	Color.from_rgba8(181, 230, 29),
	Color.from_rgba8(255, 128, 64),
]
var utilityHue : int = B2_Playerdata.Quest("playerGumballColor") 	## Utility line 2509
var grid_color := Color.from_rgba8(utilityHue, 128, 255)			## Utility line 34

# Blackness of outer frame, to make the border stand out less
var borderBlackness 	= 0.2;
var textButtonBreed 	= "Commence"; 		# Breed - Commence
var textButtonEmpty 	= "Empty"; 			# Breed - Empty slot
var textBreedEmpty 		= "Select a gun.";
var textItemless 		= "No items.";

# Quotes
var quoTxt := [
	"A baby gun arrives.",
	"A new gun enters the fray.",
	"A mysterious gun emerges from the woods.",
	"A darling gun saunters forth.",
	]


var bg_tween : Tween
var fg_tween : Tween

var intensity := 1.0

func _init() -> void:
	B2_Screen.utility_screen 	= self
	B2_Screen.is_utility_open 	= true
	push_error("DEBUG")
	
func _ready() -> void:
	B2_Playerdata.preload_skip_tutorial_save_data()
	B2_Gun.add_gun_to_bandolier()
	B2_Gun.add_gun_to_bandolier()
	B2_Gun.get_bandolier()[0].use_ammo( 5 )
	B2_Gun.get_bandolier()[1].use_ammo( 10 )
	#B2_Gun.add_gun_to_bandolier()
	B2_Gun.add_gun_to_gunbag()
	B2_Gun.add_gun_to_gunbag()
	B2_Gun.add_gun_to_gunbag()
	B2_Gun.add_gun_to_gunbag()
	B2_Gun.add_gun_to_gunbag()
	B2_Gun.add_gun_to_gunbag()
	B2_Vidcon.give_vidcon( 0 )
	B2_Vidcon.give_vidcon( 1 )
	B2_Vidcon.give_vidcon( 2 )
	B2_Vidcon.give_vidcon( 3 )
	B2_Vidcon.unbox_vidcon( 0 )
	B2_Vidcon.unbox_vidcon( 1 )
	
	var items := B2_Database.items.keys()
	items.shuffle()
	for item in items:
		B2_Item.gain_item( item, randi_range(1,99) )
		if B2_Item.get_items().size() > 20:
			break
	
	style_box_utility.bg_color 		= Color(grid_color, intensity * 0.125)
	style_box_utility.border_color 	= Color(grid_color, intensity * 0.500)
	set_color.emit( grid_color )
	_change_menu_state( menu_state )
	main_info_panel.update_menu()
	
	main_btn.text = Text.pr( B2_Playerdata.Quest("playerNameFull", null, "Undefined") )

## WARNING This sucks. need to create a theme that handles this.
func _modulate_some_buttons_i_guess() -> void:
	right_panel.modulate = Color( grid_color, 0.75 )
	
func _hide_all() -> void:
	## NOTE Info panels
	main_info_panel.hide_panel()
	brain_info_panel.hide_panel()
	brain_vidcon_panel.hide_panel()
	gun_info_panel.hide_panel()
	gun_info_bando_panel.hide_panel()
	gun_info_bando_rename_panel.hide_panel()
	gun_info_bag_panel.hide_panel()
	gun_info_bag_rename_panel.hide_panel()
	gun_info_smelt_panel.hide_panel()
	candy_panel.hide_panel()
	inventory_panel.hide_panel()
	
	## NOTE Buttons
	main_btn.hide(); 						main_btn.disabled = false
	gun_btn.hide(); 						gun_btn.disabled = false
	gun_bando_btn.hide(); 					gun_bando_btn.disabled = false
	gun_bando_rename_btn.hide(); 			gun_bando_rename_btn.disabled = false
	
	gun_bag_btn.hide(); 					gun_bag_btn.disabled = false
	gun_bag_fave_btn.hide(); 				gun_bag_fave_btn.disabled = false
	gun_bag_promote_btn.hide(); 			gun_bag_promote_btn.disabled = false
	
	gun_smelt_btn.hide(); 					gun_smelt_btn.disabled = false
	gun_smelt_current_btn.hide(); 			gun_smelt_current_btn.disabled = false
	gun_smelt_empty_btn.hide(); 			gun_smelt_empty_btn.disabled = false
	gun_smelt_unfaves_btn.hide(); 			gun_smelt_unfaves_btn.disabled = false
	gun_smelt_inbag_btn.hide(); 			gun_smelt_inbag_btn.disabled = false
	
	gun_reload_btn.hide(); 					gun_reload_btn.disabled = false
	gun_breed_btn.hide(); 					gun_breed_btn.disabled = false
	candy_btn.hide(); 						candy_btn.disabled = false
	brain_btn.hide(); 						brain_btn.disabled = false
	equip_btn.hide(); 						equip_btn.disabled = false
	inventory_btn.hide(); 					inventory_btn.disabled = false
	dwarf_btn.hide(); 						dwarf_btn.disabled = false
	unplug_btn.hide(); 						unplug_btn.disabled = false
	candy_make_btn.hide(); 					candy_make_btn.disabled = false
	brain_vidcon_unbox_btn.hide();			brain_vidcon_unbox_btn.disabled = false
	## NOTE Menus
	gun_menu.hide()
	gun_bando_menu.hide()
	gun_bag_menu.hide()
	gun_smelt_menu.hide()
	gun_reload_menu.hide()
	candy_menu.hide()
	brain_menu.hide()
	equip_menu.hide()
	inventory_menu.hide()
	
func _control_btn_state() -> void:
	## Cant rename bando gun if there are no guns
	gun_bando_rename_btn.disabled = 	B2_Gun.get_bandolier().is_empty()
	
	## Cannot promote guns if bando is full.
	gun_bag_promote_btn.disabled = 		B2_Gun.get_bandolier().size() >= B2_Gun.BANDOLIER_SIZE
	
	## Cant smelt gunbag guns without guns.
	gun_smelt_current_btn.disabled = 	B2_Gun.get_bandolier().is_empty() and B2_Gun.get_gunbag().is_empty()
	gun_smelt_empty_btn.disabled = 		B2_Gun.get_gunbag().is_empty()
	gun_smelt_unfaves_btn.disabled = 	B2_Gun.get_gunbag().is_empty()
	gun_smelt_inbag_btn.disabled = 		B2_Gun.get_gunbag().is_empty()
	
## There has to be a better way to handle this.
func _change_menu_state( state ) -> bool:
	_hide_all()
	_control_btn_state()
	match state:
		MAIN:
			## NOTE Info panels
			main_info_panel.show_panel()
			## NOTE Buttons
			main_btn.disabled = true
			main_btn.show() # <------------
			gun_btn.show()
			candy_btn.show()
			brain_btn.show()
			equip_btn.show()
			inventory_btn.show()
			dwarf_btn.show()
			unplug_btn.show()
			
			main_btn.grab_focus()
		GUN:
			## NOTE Info panels
			gun_info_panel.show_panel()
			## NOTE Buttons
			main_btn.show()
			gun_btn.disabled = true
			gun_btn.show() # <------------
			gun_bando_btn.show()
			gun_bag_btn.show()
			gun_smelt_btn.show()
			gun_reload_btn.show()
			gun_breed_btn.show()
			## NOTE Menus
			gun_menu.show() # <------------
			inventory_menu.hide()
			
			gun_btn.grab_focus()
		GUN_BANDO:
			## NOTE Info panels
			gun_info_bando_panel.show_panel()
			## NOTE Buttons
			main_btn.show()
			gun_btn.show()
			gun_bando_btn.disabled = true
			gun_bando_btn.show()
			gun_bando_rename_btn.show()
			## NOTE Menus
			gun_menu.show()
			gun_bando_menu.show()
		
			gun_bando_rename_btn.grab_focus()
		GUN_BANDO_RENAME:
			## NOTE Info panels
			gun_info_bando_rename_panel.show_panel()
			## NOTE Buttons
			main_btn.show()
			gun_btn.show()
			gun_bando_rename_btn.disabled = true
			gun_bando_rename_btn.show()
			## NOTE Menus
			gun_menu.show()
			gun_bando_menu.show()
			
			gun_bando_rename_btn.grab_focus()
		GUN_BAG:
			## NOTE Info panels
			gun_info_bag_panel.show_panel()
			## NOTE Buttons
			main_btn.show()
			gun_btn.show()
			gun_bag_btn.disabled = true
			gun_bag_btn.show()
			gun_bag_fave_btn.show()
			gun_bag_promote_btn.show()
			## NOTE Menus
			gun_menu.show()
			gun_bag_menu.show()
			
			gun_bag_btn.grab_focus()
		GUN_BAG_PROMOTE:
			## NOTE Info panels
			gun_info_bag_rename_panel.show_panel()
			## NOTE Buttons
			
			main_btn.show()
			gun_btn.show()
			gun_bag_btn.show()
			#gun_bag_fave_btn.show()
			gun_bag_promote_btn.disabled = true
			gun_bag_promote_btn.show()
			## NOTE Menus
			gun_menu.show()
			gun_bag_menu.show()
		GUN_SMELT:
			## NOTE Info panels
			gun_info_smelt_panel.show_panel()
			## NOTE Buttons
			main_btn.show()
			gun_btn.show()
			gun_smelt_btn.disabled = true
			gun_smelt_btn.show()
			gun_smelt_current_btn.show()
			gun_smelt_empty_btn.show()
			gun_smelt_unfaves_btn.show()
			gun_smelt_inbag_btn.show()
			## NOTE Menus
			gun_menu.show()
			gun_smelt_menu.show()
			
			gun_smelt_current_btn.grab_focus()
		GUN_RELOAD:
			## NOTE Info panels
			gun_info_panel.show_panel()
			## NOTE Buttons
			main_btn.show()
			gun_btn.show()
			gun_reload_btn.disabled = true
			gun_reload_btn.show()
			## NOTE Menus
			gun_menu.show()
			gun_reload_menu.show()
			
			gun_reload_btn.grab_focus()
		CANDY:
			## NOTE Info panels
			candy_panel.show_panel()
			## NOTE Buttons
			main_btn.show()
			candy_btn.disabled = true
			candy_btn.show()
			candy_make_btn.show()
			## NOTE Menus
			candy_menu.show()
			
			candy_make_btn.grab_focus()
		BRAIN:
			## NOTE Info panels
			brain_info_panel.show_panel()
			## NOTE Buttons
			main_btn.show()
			brain_btn.disabled = true
			brain_btn.show() # <------------
			brain_vidcon_btn.show()
			## NOTE Menus
			brain_menu.show() # <------------
			
			brain_btn.grab_focus()
		VIDCONS:
			## NOTE Info panels
			brain_vidcon_panel.show_panel()
			
			## NOTE Buttons
			main_btn.show()
			brain_btn.show()
			brain_vidcon_btn.disabled = true
			brain_vidcon_btn.show()
			brain_vidcon_unbox_btn.disabled = true
			brain_vidcon_unbox_btn.show()
			## NOTE Menus
			brain_menu.show()
			
			brain_vidcon_unbox_btn.grab_focus()
		INV:
			## NOTE Info panels
			inventory_panel.show_panel()
			## NOTE Buttons
			main_btn.show()
			inventory_btn.disabled = true
			inventory_btn.show()
			## NOTE Menus
			
			inventory_btn.grab_focus()
		_:
			push_error("Invalid menu state: ", state)
			_change_menu_state( MAIN )
			return false
			
	if menu_state == state:
		return false
	else:
		## State is valid. apply it.
		menu_state = state
		return true


func _process( _delta: float ) -> void:
	## Avoid flickering in the editor
	if not Engine.is_editor_hint():
		var f := randf_range(0.06,0.12)
		flickered.emit( f )
		style_box_utility.bg_color 		= Color(grid_color, f * intensity * 0.125) 

func _on_main_btn_pressed() -> void:
	if _change_menu_state( MAIN ):
		B2_Sound.play( "utility_button_click" )

func _on_gun_btn_pressed() -> void:
	if _change_menu_state( GUN ):
		B2_Sound.play( "utility_button_click" )

func _on_candy_btn_pressed() -> void:
	if _change_menu_state( CANDY ):
		B2_Sound.play( "utility_button_click" )

func _on_brain_btn_pressed() -> void:
	if _change_menu_state( BRAIN ):
		B2_Sound.play( "utility_button_click" )

func _on_equip_btn_pressed() -> void:
	pass # Replace with function body.

func _on_inventory_btn_pressed() -> void:
	if _change_menu_state( INV ):
		B2_Sound.play( "utility_button_click" )

func _on_dwarf_btn_pressed() -> void:
	pass # Replace with function body.

func _on_unplug_btn_pressed() -> void:
	pass # Replace with function body.

func _on_gun_bando_btn_pressed() -> void:
	if _change_menu_state( GUN_BANDO ):
		B2_Sound.play( "utility_button_click" )

func _on_gun_bag_btn_pressed() -> void:
	if _change_menu_state( GUN_BAG ):
		B2_Sound.play( "utility_button_click" )

func _on_gun_bando_rename_btn_pressed() -> void:
	if _change_menu_state( GUN_BANDO_RENAME ):
		B2_Sound.play( "utility_button_click" )

func _on_gun_bag_promote_btn_pressed() -> void:
	if _change_menu_state( GUN_BAG_PROMOTE ):
		B2_Sound.play( "utility_button_click" )

func _on_gun_smelt_btn_pressed() -> void:
	if _change_menu_state( GUN_SMELT ):
		B2_Sound.play( "utility_button_click" )

func _on_make_btn_pressed() -> void:
	pass

func _on_gun_info_bando_rename_panel_renamed_gun( _gun : B2_Weapon ) -> void:
	_change_menu_state( GUN_BANDO )

func _on_gun_info_bag_rename_panel_renamed_gun(  gun : B2_Weapon ) -> void:
	_change_menu_state( GUN_BAG )
	B2_Gun.remove_gun_from_gunbag( gun )
	B2_Gun.append_gun_to_bandolier( gun )

func _on_gun_reload_btn_pressed() -> void:
	if _change_menu_state( GUN_RELOAD ):
		B2_Sound.play( "utility_button_click" )

func _on_vidcon_btn_pressed() -> void:
	if _change_menu_state( VIDCONS ):
		B2_Sound.play( "utility_button_click" )
