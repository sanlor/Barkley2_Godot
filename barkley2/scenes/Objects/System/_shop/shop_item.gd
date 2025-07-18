extends Button

const S_JERKIN 					:= preload("uid://cvyp0k17ke0yg")
const S_CANDY 					:= preload("uid://ckdra5vpxt43g")
const S_MENU_UTILITY_VIDCON 	:= preload("uid://bgr2n0hlmp87k")

@export var folded_size := 24
@export var unfolded_size := 70

@onready var focus_color: 		ColorRect 		= $focus_color

@onready var item_summary: HBoxContainer = $MarginContainer/VBoxContainer/item_summary
@onready var item_icon: 		TextureRect 	= $MarginContainer/VBoxContainer/item_summary/item_icon
@onready var item_name: 		Label 			= $MarginContainer/VBoxContainer/item_summary/item_name
@onready var item_cost: 		Label 			= $MarginContainer/VBoxContainer/item_summary/item_cost

@onready var item_stats: 		HBoxContainer 	= $MarginContainer/VBoxContainer/item_stats
@onready var evs_value: 		Label 			= $MarginContainer/VBoxContainer/item_stats/evs/evs_value
@onready var weight_value: 		Label 			= $MarginContainer/VBoxContainer/item_stats/weight/weight_value
@onready var pockets_value: 	Label 			= $MarginContainer/VBoxContainer/item_stats/pockets/pockets_value

@onready var resistence_graph: 	Control 		= $MarginContainer/VBoxContainer/item_stats/resistence/resistence_graph

@onready var item_description: 	Label 			= $MarginContainer/VBoxContainer/item_description

## Gun stuff
@onready var gun_summary: 		HBoxContainer 	= $MarginContainer/VBoxContainer/gun_summary
@onready var gun_stats: 		HBoxContainer 	= $MarginContainer/VBoxContainer/gun_stats

@onready var gun_icon: 			TextureRect 	= $MarginContainer/VBoxContainer/gun_summary/gun_icon
@onready var gun_name: 			Label 			= $MarginContainer/VBoxContainer/gun_summary/gun_name
@onready var gun_cost: 			Label 			= $MarginContainer/VBoxContainer/gun_summary/gun_cost

@onready var dmg_value: 		Label 			= $MarginContainer/VBoxContainer/gun_stats/dmg/dmg_value
@onready var rte_value: 		Label 			= $MarginContainer/VBoxContainer/gun_stats/rte/rte_value
@onready var cap_value: 		Label 			= $MarginContainer/VBoxContainer/gun_stats/cap/cap_value
@onready var afx_value: 		Label 			= $MarginContainer/VBoxContainer/gun_stats/afx/afx_value
@onready var wgt_value: 		Label 			= $MarginContainer/VBoxContainer/gun_stats/wgt/wgt_value

enum TYPE{GUN, JERKIN, RECIPE, VIDCON}

## Focus reference stuff
var buy_btn: 					Button
var info_btn: 					Button
var exit_btn: 					B2_Border_Button

@export var my_item 			:= ""
@export var my_item_type 		:= TYPE.JERKIN
@export var my_item_cost		:= 10
var my_item_data 				: Dictionary
var my_vidcon 					:= 0
var my_gun						: B2_Weapon

var item_tween : Tween

func _ready() -> void:
	custom_minimum_size.y = folded_size
	
	## Default fonts
	item_name.label_settings.font 			= preload("res://barkley2/resources/fonts/fn1.tres")
	item_description.label_settings.font	= preload("res://barkley2/resources/fonts/fn2c.tres")
	
	if my_item_type == TYPE.JERKIN:
		my_item_data = B2_Jerkin.get_jerkin_stats( my_item )
		item_icon.texture.atlas 				= S_JERKIN
		item_icon.texture.region.size 			= Vector2(24,24)
		item_icon.texture.region.position.x 	= int( my_item_data["Sub"] ) * 24
		item_name.text							= Text.pr( my_item )
		item_cost.text							= "£" + str(my_item_cost)
		
		item_summary.show()
		item_stats.show()
		item_description.show()
		gun_summary.hide()
		gun_stats.hide()
		
		evs_value.text			= str( my_item_data["Fsh"] )
		pockets_value.text		= str( my_item_data["Pkt"] )
		weight_value.text 		= str( my_item_data["Wgt"] )
		
		resistence_graph.generic_res 		+= -my_item_data["Normal"]
		resistence_graph.bio_res			+= -my_item_data["Bio"]
		resistence_graph.cyber_res			+= -my_item_data["Cyber"]
		resistence_graph.mental_res			+= -my_item_data["Mental"]
		resistence_graph.cosmic_res			+= -my_item_data["Kosmic"]
		resistence_graph.zauber_res			+= -my_item_data["Zauber"]
		
		item_description.text 	= Text.pr( my_item_data["Description"] )
		
		folded_size 	= 24
		unfolded_size 	= 70
		
	elif my_item_type == TYPE.RECIPE:
		my_item_data = B2_Candy.get_candy( my_item )
		item_icon.texture.atlas 				= S_CANDY
		item_icon.texture.region.size 			= Vector2(16,16)
		item_icon.texture.region.position.x 	= int( my_item_data["sub"] ) * 16
		item_name.text							= Text.pr( my_item + " Recipe" )
		item_cost.text							= "£" + str(my_item_cost)
		
		item_summary.show()
		item_stats.hide()
		item_description.show()
		gun_summary.hide()
		gun_stats.hide()
		
		item_description.text 	= Text.pr( my_item_data["utility"] )
		
		folded_size 	= 20
		unfolded_size 	= 44
	
	elif my_item_type == TYPE.GUN:
		var gun_id := my_item.right(1).to_int() ## The the last char (should be a number)
		assert( B2_Shop.gun_inventory.size() > gun_id )
		my_gun = B2_Shop.gun_inventory[gun_id]
		assert( my_gun )
		my_item_cost 		= B2_Shop.gun_prices[gun_id]
		
		gun_icon.texture 	= my_gun.get_weapon_hud_sprite()
		gun_name.text 		= Text.pr( my_gun.weapon_name )
		gun_cost.text 		= "£" + str(my_item_cost)
		
		dmg_value.text 		= str( int( my_gun.get_att() ) )
		rte_value.text		= str( int( my_gun.get_spd() ) ) ## THIS IS WRONG
		cap_value.text		= str( my_gun.max_ammo )
		afx_value.text		= str( my_gun.afx_count() )
		wgt_value.text		= str( my_gun.wgt ) + "ç"
		
		folded_size 	= 24
		unfolded_size 	= 52
		
		item_summary.hide()
		item_stats.hide()
		item_description.hide()
		gun_summary.show()
		gun_stats.show()
	
	## WARNING This is different from the original. I wasnt able to reach this shop on the Janky demo, so I dont know how it looks.
	elif my_item_type == TYPE.VIDCON:
		my_vidcon = int( str( my_item ).replace("VIDCON_","") )
		item_icon.texture.atlas 				= S_MENU_UTILITY_VIDCON
		item_icon.texture.region.size 			= Vector2(15,23)
		item_icon.texture.region.position.x 	= 1 * 15
		item_name.text							= Text.pr( B2_Vidcon.get_vidcon_name( my_vidcon ) )
		item_name.label_settings.font 			= preload("res://barkley2/resources/fonts/fn_12ocs.tres")
		item_cost.text							= "£" + str(my_item_cost)
		
		item_summary.show()
		item_stats.hide()
		item_description.show()
		gun_summary.hide()
		gun_stats.hide()
		
		item_description.text 	= Text.pr( B2_Vidcon.get_vidcon_description( my_vidcon ) )
		item_description.label_settings.font	= preload("res://barkley2/resources/fonts/fn5o.tres")
		
		folded_size 	= 23
		unfolded_size 	= 90
		
	else:
		breakpoint
	
	if B2_Playerdata.Quest("money") < my_item_cost:
		item_cost.modulate = Color.ORANGE_RED
	else:
		item_cost.modulate = Color.LIGHT_GRAY
		
	if button_group:
		button_group.pressed.connect( 
			func(btn): 
				if btn != self: 
					_shrink_button() )
		
	_shrink_button()
	
func get_gun() -> B2_Weapon:
	if my_item_type == TYPE.GUN:
		return my_gun
	push_error("Tried to squeeze a gun prom an item. what is wrong with you?")
	breakpoint
	return B2_Weapon.new()
	
func get_jerkin() -> String:
	return my_item
	
func get_vidcon() -> int:
	return my_vidcon
	
func get_item_name() -> String:
	if my_item_type == TYPE.GUN:		return my_gun.weapon_name
	if my_item_type == TYPE.VIDCON:		return B2_Vidcon.get_vidcon_name( my_vidcon )
	else:								return my_item
	
func get_item_cost() -> int:
	return my_item_cost
	
func _physics_process(_delta: float) -> void:
	focus_color.color.a = 0.05 * randf_range( 0.80, 1.20 )
	
func _on_pressed() -> void:
	_expand_button()

func _on_focus_entered() -> void:
	if buy_btn:		buy_btn.focus_neighbor_left = get_path()
	if info_btn:	info_btn.focus_neighbor_left = get_path()
	button_pressed = true
	_expand_button()

func _on_focus_exited() -> void:
	await get_tree().process_frame
	if buy_btn:			if buy_btn.has_focus(): 	return
	if info_btn:		if info_btn.has_focus(): 	return
	if exit_btn:		if exit_btn.has_focus(): 	return
	_shrink_button()

func _shrink_button() -> void:
	if item_tween:
		item_tween.kill()
	item_tween = create_tween()
	item_tween.tween_property( self, "custom_minimum_size:y", folded_size, 0.1 )
	item_tween.tween_property( focus_color, "modulate:a", 0.0, 0.1 )
	
	evs_value.modulate 			= Color.LIGHT_GRAY
	weight_value.modulate 		= Color.LIGHT_GRAY
	pockets_value.modulate 		= Color.LIGHT_GRAY
	item_name.modulate 			= Color.LIGHT_GRAY
	
	if B2_Playerdata.Quest("money") < my_item_cost:
		item_cost.modulate = Color.ORANGE_RED
	else:
		item_cost.modulate = Color.LIGHT_GRAY

func _expand_button() -> void:
	B2_Sound.play("mouse_hover01")
	if item_tween:
		item_tween.kill()
	item_tween = create_tween()
	item_tween.tween_property( self, "custom_minimum_size:y", unfolded_size, 0.1 )
	item_tween.tween_property( focus_color, "modulate:a", 1.0, 0.1 )
	evs_value.modulate 			= Color.YELLOW
	weight_value.modulate 		= Color.YELLOW
	pockets_value.modulate 		= Color.YELLOW
	item_name.modulate 			= Color.YELLOW
	
	if B2_Playerdata.Quest("money") < my_item_cost:
		item_cost.modulate = Color.RED
	else:
		item_cost.modulate = Color.YELLOW
