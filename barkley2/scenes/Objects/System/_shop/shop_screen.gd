extends CanvasLayer
## Shop Menu. Buy a bunch of type of items.
# Check Shop and oShop

signal exit_called
signal buy_called
signal buy_executed
signal info_called

const B2_CONFIRM 	= preload("res://barkley2/scenes/confirm/b2_confirm.tscn")
const SHOP_ITEM 	= preload("res://barkley2/scenes/Objects/System/_shop/shop_item.tscn")

const FACES := {
	"sGarfunkleFace" 	: preload("uid://r374a86u6v26"),
	"sRedfieldFace" 	: preload("uid://d30fw6npat6u2"),
	"sMilagrosFace" 	: preload("uid://b7k47w8wxn0o7"),
	"sMortimerFace" 	: preload("uid://bt4nv8srxpfjx"),
	"sEgidiusFace" 		: preload("uid://begj8tu68n81b"),
}
const SHOP_TYPE := {
	"jerkin" 	: TYPE.JERKIN,
	"recipe" 	: TYPE.RECIPE,
	"vidcon" 	: TYPE.VIDCON,
	"gun" 		: TYPE.GUN,
}
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var shop_name_label: 			Label 			= $shop_name/shop_name_label
@onready var money_label: 				Label 			= $breakout/money_label
@onready var shopowner_face_text: 		TextureRect 	= $shopowner_face/shopowner_face_text

@onready var buy_btn: 					Button 				= $slide_border/VBoxContainer/buy_btn
@onready var info_btn: 					Button 				= $slide_border/VBoxContainer/info_btn
@onready var exit_btn: 					B2_Border_Button 	= $exit_btn

@onready var shop_vbox: 				VBoxContainer 	= $shop_panel/MarginContainer/ScrollContainer/shop_vbox

@onready var slide_border: 				B2_Border 		= $slide_border

@onready var info_panel: 				Control = $info_panel
@onready var compare_panel: 			Control = $compare_panel
@onready var gunbag_panel: 				Control = $gunbag_panel

enum TYPE{GUN, JERKIN, RECIPE, VIDCON}
@export var my_shop_name	:= ""
@export var my_shop_type 	:= TYPE.JERKIN

var my_shop_data : Dictionary

var slide_boder_focus : Button

func _ready() -> void:
	info_panel.hide()
	compare_panel.hide()
	B2_Screen.set_cursor_type( B2_Screen.TYPE.HAND )
	B2_Input.ffwd( false )
	animation_player.play("show_menu")
	
	if not B2_Shop.bought_items.has(my_shop_name):
		B2_Shop.bought_items[my_shop_name] = []
	
	my_shop_data = B2_Shop.get_shop_data( my_shop_name )
	
	if my_shop_data:
		my_shop_type 					= SHOP_TYPE[ my_shop_data["define"][0] ]
		shopowner_face_text.texture 	= FACES[ my_shop_data["define"][1] ]
		shop_name_label.text 			= Text.pr( my_shop_name )
		
		## Hide unused buttons
		if not my_shop_data["option"].has( "Buy" ): 	buy_btn.hide()
		if not my_shop_data["option"].has( "Info" ): 	info_btn.hide()
		if buy_btn.visible:
			slide_border.border_size.y = 42.0
			$slide_border/VBoxContainer.set_deferred("size", Vector2( 60.0, 42.0) )
		if info_btn.visible:
			slide_border.border_size.y = 64.0
			$slide_border/VBoxContainer.set_deferred("size", Vector2( 60.0, 64.0) )
		
		## Cleanup old buttons
		for i in shop_vbox.get_children():
			i.queue_free()
		
		if not my_shop_type == TYPE.GUN:
			gunbag_panel.hide()
		
		## Add new buttons
		var btn_group := ButtonGroup.new()
		for i : String in my_shop_data["stocks"]:
			## Check if player already has this item.
			if my_shop_type == TYPE.JERKIN:
				if B2_Jerkin.has_jerkin( i ):
					continue
			elif my_shop_type == TYPE.RECIPE:
				if B2_Candy.has_recipe( i ):
					continue
			elif my_shop_type == TYPE.VIDCON:
				#breakpoint ## VIDCONS NOT IMPLEMENTED
				if B2_Vidcon.has_vidcon( int( str(i).replace("VIDCON_","") ) ):
					continue
			elif my_shop_type == TYPE.GUN:
				if B2_Shop.bought_items.has(my_shop_name):
					if B2_Shop.bought_items[my_shop_name].has( i ):
						continue
						
			var item 					= SHOP_ITEM.instantiate()
			item.my_item 				= i
			item.my_item_cost 			= my_shop_data["stocks"][i]
			item.name 					= i + "_btn"
			item.my_item_type 			= my_shop_type
			item.focus_entered.connect( _update_focus.bind(item) )
			item.toggle_mode			= true
			item.button_group 			= btn_group
			item.focus_neighbor_right	= buy_btn.get_path()
			
			item.buy_btn				= buy_btn
			item.info_btn				= info_btn
			item.exit_btn				= exit_btn
			
			shop_vbox.add_child( item, true )
			
		## Set menu navigation bullshit (use menu using a gamepad and keyboard)
		await animation_player.animation_finished
		if shop_vbox.get_children():
			shop_vbox.get_children().front().grab_focus()
			shop_vbox.get_children().back().focus_neighbor_bottom	= exit_btn.get_path()
			exit_btn.focus_neighbor_top 	= shop_vbox.get_children().back().get_path()
			buy_btn.focus_neighbor_left 	= shop_vbox.get_children().front().get_path()
			info_btn.focus_neighbor_left 	= shop_vbox.get_children().front().get_path()
		else:
			exit_btn.focus_neighbor_top = buy_btn.get_path()
		exit_btn.focus_neighbor_right	= buy_btn.get_path()
		
	money_label.text = str( B2_Playerdata.Quest("money") )
	
func _physics_process(_delta: float) -> void:
	if slide_boder_focus:
		slide_border.global_position.y = lerpf( slide_border.global_position.y, slide_boder_focus.global_position.y - 2, 0.15 )

func _update_focus( btn : Button ) -> void:
	slide_boder_focus = btn
	_update_money( btn )
	
func _update_money( btn : Button ) -> void:
	if btn.my_item_cost <= B2_Playerdata.Quest("money"):
		## Player have enough money to buy this
		if btn.has_focus():
			money_label.modulate = Color.ORANGE_RED
			money_label.text = str( B2_Playerdata.Quest("money") - btn.my_item_cost )
			buy_btn.disabled = false
	else:
		## Player doesnt have enough money to buy
		money_label.modulate = Color.WHITE
		money_label.text = str( B2_Playerdata.Quest("money") )
		buy_btn.disabled = true

func _on_exit_btn_button_pressed() -> void:
	B2_Sound.play("cursor_back")
	exit_called.emit()
	B2_Screen.hide_shop_screen()
	
func hide_menu() -> void:
	B2_Screen.set_cursor_type( B2_Screen.TYPE.POINT )
	animation_player.play("hide_menu")
	await animation_player.animation_finished

func _on_buy_btn_pressed() -> void:
	if not slide_boder_focus:
		push_warning("No focus??? Weird.")
		
		## Try to get a new focus
		if shop_vbox.get_children().is_empty():
			## This should never happen.
			return
		else:
			## Select the top option
			slide_boder_focus = shop_vbox.get_children().front()
			slide_boder_focus.grab_focus()
			slide_boder_focus.button_pressed = true
			
	B2_Sound.play("cursor_select01")
	info_btn.release_focus()
	slide_boder_focus.release_focus()
	
	var confirm = B2_CONFIRM.instantiate()
	confirm.givTxt = Text.pr( "Buy %s for %s?" % [slide_boder_focus.get_item_name(), str(slide_boder_focus.get_item_cost())] )
	confirm.option1_pressed.connect( buy_item.bind(slide_boder_focus)	) # Yes
	confirm.option2_pressed.connect( cancel_buy 						) # No
	add_child( confirm )

func buy_item( _btn ) -> void:
	## Randomish sfx.
	B2_Sound.play("hoopz_pickupMoney")
			
	B2_Database.money_change( -_btn.my_item_cost )
	slide_boder_focus = null
	
	if my_shop_type == TYPE.GUN:
		var gun : B2_Weapon = _btn.get_gun()
		B2_Shop.bought_items[my_shop_name].append( _btn.my_item )
		B2_Gun.append_gun_to_gunbag( gun )
		gunbag_panel.update()
		_btn.queue_free()
		
	elif my_shop_type == TYPE.JERKIN:
		B2_Jerkin.gain_jerkin( _btn.get_jerkin() )
		_btn.queue_free()
		
	elif my_shop_type == TYPE.RECIPE:
		B2_Candy.add_candy_recipe( _btn.get_item_name() )
		_btn.queue_free()
		
	elif my_shop_type == TYPE.VIDCON:
		#breakpoint ## Vidcons not setup yet
		B2_Vidcon.give_vidcon( _btn.get_vidcon() )
		_btn.queue_free()
	else:
		## WTF???
		breakpoint
	
	## Where should we focus now?
	if shop_vbox.get_children().is_empty():
		# close shop, bought them all.
		_on_exit_btn_button_pressed()
	else:
		slide_boder_focus = shop_vbox.get_children().front()
		slide_boder_focus.grab_focus()
		slide_boder_focus.button_pressed = true

func cancel_buy() -> void:
	info_btn.grab_focus()

func _on_info_btn_pressed() -> void:
	B2_Sound.play("cursor_select01")
	if slide_boder_focus:
		if my_shop_type == TYPE.GUN:
			info_btn.release_focus()
			slide_boder_focus.release_focus()
			var my_gun : B2_Weapon = slide_boder_focus.get_gun()
			info_panel.grab_focus()
			info_panel.show_panel( my_gun )
			await info_panel.menu_closed
			slide_boder_focus.grab_focus()
		elif my_shop_type == TYPE.JERKIN:
			info_btn.release_focus()
			slide_boder_focus.release_focus()
			var sel_jerkin : String = slide_boder_focus.get_jerkin()
			compare_panel.grab_focus()
			compare_panel.show_panel( sel_jerkin )
			await compare_panel.menu_closed
			slide_boder_focus.grab_focus()
		else:
			## WTF!!!!
			breakpoint
