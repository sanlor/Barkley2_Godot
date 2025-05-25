extends CanvasLayer

signal exit_called
signal buy_called
signal buy_executed
signal info_called

const SHOP_ITEM = preload("res://barkley2/scenes/Objects/System/_shop/shop_item.tscn")

const FACES := {
	"sGarfunkleFace" 	: preload("uid://r374a86u6v26"),
	"sRedfieldFace" 	: preload("uid://d30fw6npat6u2"),
	"sMilagrosFace" 	: preload("uid://b7k47w8wxn0o7"),
	"sMortimerFace" 	: preload("uid://bt4nv8srxpfjx"),
	"sEgidiusFace" 		: preload("uid://begj8tu68n81b"),
}
const SHOP_TYPE := {
	"jerkin" : TYPE.JERKIN,
	"recipe" : TYPE.RECIPE,
	"vidcon" : TYPE.VIDCON,
	"gun" : TYPE.GUN,
}
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var shop_name_label: 			Label 			= $shop_name/shop_name_label
@onready var money_label: 				Label 			= $breakout/money_label
@onready var shopowner_face_text: 		TextureRect 	= $shopowner_face/shopowner_face_text

@onready var buy_btn: 					Button 			= $slide_border/VBoxContainer/buy_btn
@onready var info_btn: 					Button 			= $slide_border/VBoxContainer/info_btn

@onready var shop_vbox: 				VBoxContainer 	= $shop_panel/MarginContainer/ScrollContainer/shop_vbox

@onready var slide_border: 				B2_Border 		= $slide_border

enum TYPE{GUN, JERKIN, RECIPE, VIDCON}
@export var my_shop_name	:= ""
@export var my_shop_type 	:= TYPE.JERKIN

var my_shop_data : Dictionary

var slide_boder_focus : Button

func _ready() -> void:
	animation_player.play("show_menu")
	
	B2_Playerdata.Quest("money", 200)
	push_error("DEBUG MONEY SET")
	
	my_shop_data = B2_Shop.get_shop_data( my_shop_name )
	
	if my_shop_data:
		my_shop_type 					= SHOP_TYPE[ my_shop_data["define"][0] ]
		shopowner_face_text.texture 	= FACES[ my_shop_data["define"][1] ]
		shop_name_label.text 			= Text.pr( my_shop_name )
		
		if not my_shop_data["option"].has( "Buy" ): buy_btn.hide()
		if not my_shop_data["option"].has( "Info" ): info_btn.hide()
		
		for i in shop_vbox.get_children():
			i.queue_free()
		
		for i : String in my_shop_data["stocks"]:
			var item 					= SHOP_ITEM.instantiate()
			item.my_item 				= i
			item.my_item_cost 			= my_shop_data["stocks"][i]
			item.name 					= i + "_btn"
			item.my_item_type 			= my_shop_type
			item.focus_entered.connect( _update_focus.bind(item) )
			shop_vbox.add_child( item, true )
			
	money_label.text = str( B2_Playerdata.Quest("money") )
	
func _physics_process(_delta: float) -> void:
	if slide_boder_focus:
		slide_border.global_position.y = lerpf( slide_border.global_position.y, slide_boder_focus.global_position.y - 2, 0.15 )

func _update_focus( btn : Button ) -> void:
	slide_boder_focus = btn
	_update_money( btn )
	
func _update_money( btn : Button ) -> void:
	if btn.my_item_cost <= B2_Playerdata.Quest("money"):
		if btn.has_focus():
			money_label.modulate = Color.ORANGE_RED
			money_label.text = str( B2_Playerdata.Quest("money") - btn.my_item_cost )
	else:
		money_label.modulate = Color.WHITE
		money_label.text = str( B2_Playerdata.Quest("money") )

func _on_exit_btn_button_pressed() -> void:
	exit_called.emit()
	B2_Screen.hide_shop_screen()
	
func hide_menu() -> void:
	animation_player.play("hide_menu")
	await animation_player.animation_finished
