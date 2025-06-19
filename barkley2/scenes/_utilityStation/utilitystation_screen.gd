extends CanvasLayer

## Handles the UI for the Utility Station.
# Check ustation, Utility and o_utilitystation

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

@onready var gun_btn: 		Button = $frame/right_panel/right_panel_vbox/gun_btn
@onready var gun_menu: 		VBoxContainer = $frame/right_panel/right_panel_vbox/gun_menu
@onready var gun_bando_btn: 	Button = $frame/right_panel/right_panel_vbox/gun_menu/gun_bando_btn
@onready var gun_bag_btn: 		Button = $frame/right_panel/right_panel_vbox/gun_menu/gun_bag_btn
@onready var gun_smelt_btn: 	Button = $frame/right_panel/right_panel_vbox/gun_menu/gun_smelt_btn
@onready var gun_reload_btn: 	Button = $frame/right_panel/right_panel_vbox/gun_menu/gun_reload_btn
@onready var gun_breed_btn: 	Button = $frame/right_panel/right_panel_vbox/gun_menu/gun_breed_btn

@onready var candy_btn: Button = $frame/right_panel/right_panel_vbox/candy_btn
@onready var candy_menu: VBoxContainer = $frame/right_panel/right_panel_vbox/candy_menu

@onready var brain_btn: Button = $frame/right_panel/right_panel_vbox/brain_btn
@onready var brain_menu: VBoxContainer = $frame/right_panel/right_panel_vbox/brain_menu

@onready var equip_btn: Button = $frame/right_panel/right_panel_vbox/equip_btn
@onready var equip_menu: VBoxContainer = $frame/right_panel/right_panel_vbox/equip_menu

@onready var inventory_btn: Button = $frame/right_panel/right_panel_vbox/inventory_btn
@onready var inventory_menu: VBoxContainer = $frame/right_panel/right_panel_vbox/inventory_menu

@onready var dwarf_btn: Button = $frame/right_panel/right_panel_vbox/dwarf_btn
@onready var unplug_btn: Button = $frame/right_panel/right_panel_vbox/unplug_btn

@onready var right_panel: ScrollContainer = $frame/right_panel

## Left Info panel
@onready var main_info_panel: Control = $frame/main_info_panel
@onready var gun_info_panel: Control = $frame/gun_info_panel
@onready var brain_info_panel: Control = $frame/brain_info_panel

## Menu control
enum {MAIN,GUN,CANDY,BRAIN,EQUIP,INV,DWARF,UNPLUG}
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
	B2_Gun.add_gun_to_bandolier()
	
	style_box_utility.bg_color 		= Color(grid_color, intensity * 0.125)
	style_box_utility.border_color 	= Color(grid_color, intensity * 0.500)
	set_color.emit( grid_color )
	_change_menu_state( menu_state )
	main_info_panel.update_menu()
	
	main_btn.text = Text.pr( B2_Playerdata.Quest("playerNameFull", null, "Undefined") )

## WARNING This sucks. need to create a theme that handles this.
func _modulate_some_buttons_i_guess() -> void:
	right_panel.modulate = Color( grid_color, 0.75 )
	
## There has to be a better way to handle this.
func _change_menu_state( state ) -> bool:
	match state:
		MAIN:
			## NOTE Info panels
			main_info_panel.show_panel()
			brain_info_panel.hide_panel()
			gun_info_panel.hide_panel()
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
			## NOTE Menus
			gun_menu.hide()
			candy_menu.hide()
			brain_menu.hide()
			equip_menu.hide()
			inventory_menu.hide()
			
			main_btn.grab_focus()
		GUN:
			## NOTE Info panels
			main_info_panel.hide_panel()
			brain_info_panel.hide_panel()
			gun_info_panel.show_panel()
			## NOTE Buttons
			main_btn.disabled = false
			main_btn.show()
			gun_btn.show() # <------------
			candy_btn.hide()
			brain_btn.hide()
			equip_btn.hide()
			inventory_btn.hide()
			dwarf_btn.hide()
			unplug_btn.hide()
			## NOTE Menus
			gun_menu.show() # <------------
			candy_menu.hide()
			brain_menu.hide() 
			equip_menu.hide()
			inventory_menu.hide()
			
			gun_btn.grab_focus()
		BRAIN:
			## NOTE Info panels
			main_info_panel.hide_panel()
			brain_info_panel.show_panel()
			gun_info_panel.hide_panel()
			## NOTE Buttons
			main_btn.disabled = false
			main_btn.show()
			gun_btn.hide()
			candy_btn.hide()
			brain_btn.show() # <------------
			equip_btn.hide()
			inventory_btn.hide()
			dwarf_btn.hide()
			unplug_btn.hide()
			## NOTE Menus
			gun_menu.hide() 
			candy_menu.hide()
			brain_menu.show() # <------------
			equip_menu.hide()
			inventory_menu.hide()
			
			brain_btn.grab_focus()
		_:
			push_error("Invalid menu state: ", state)
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
	pass # Replace with function body.


func _on_brain_btn_pressed() -> void:
	if _change_menu_state( BRAIN ):
		B2_Sound.play( "utility_button_click" )


func _on_equip_btn_pressed() -> void:
	pass # Replace with function body.


func _on_inventory_btn_pressed() -> void:
	pass # Replace with function body.


func _on_dwarf_btn_pressed() -> void:
	pass # Replace with function body.


func _on_unplug_btn_pressed() -> void:
	pass # Replace with function body.
