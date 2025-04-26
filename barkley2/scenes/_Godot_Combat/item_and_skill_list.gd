extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var top_panel: NinePatchRect = $top_panel

@onready var item_list: VBoxContainer = $top_panel/items/item_list

## Description
@onready var description: PanelContainer 	= $top_panel/description
@onready var description_text: Label 		= $top_panel/description/margin/description_text

var has_item 	:= false
var has_skill 	:= false
var desc_tween 	: Tween

func _ready() -> void:
	description.hide()
	description.modulate = Color.TRANSPARENT

func disable_all_buttons( disabled : bool ) -> void:
	for b in item_list.get_children():
		if b is Button:
			b.disabled = disabled

func populate_skill_list():
	pass
	
func populate_item_list():
	for c in item_list.get_children():
		c.queue_free()

	var my_items : Array = B2_Config.get_user_save_data( "player.items.has", [] )
	var slot := 0
	has_item = false
	var first_item : Button
	
	description_text.text = Text.pr( "Description not loaded (BUG)") ## Avoid loading previous item description.
	
	for item  in my_items:
		if item is String:
			if item != "":
				var btn := Button.new()
				btn.text = item
				btn.name = Text.pr( str(item) ) + "_" + str(slot)
				
				var candy_data : Dictionary = B2_Candy.get_candy( item )
				btn.tooltip_text = Text.pr( candy_data["utility"] + "\n\n" + '"' + candy_data["flavor"] + '"' )
				
				btn.focus_entered.connect( description_text.set_text.bind( btn.tooltip_text ) )
				btn.pressed.connect( get_parent().use_item.bind( slot ) )
				
				btn.custom_minimum_size.y = 12.0
				item_list.add_child( btn, true )
				if not first_item:
					first_item = btn
				has_item = true
				
		slot += 1
		
	if not has_item:
		var label := Label.new()
		label.text = Text.pr( "No items :(" )
		label.name = "no_item_label"
		item_list.add_child( label, true )
		description_text.text = Text.pr( "No items :(" )
	else:
		if is_instance_valid(first_item):
			first_item.grab_focus()
		else:
			# ?????????
			breakpoint

func show_skill_menu() -> void:
	populate_skill_list()
	animation_player.play("show")
	B2_Sound.play("sn_mouse_analoghover01")
	await animation_player.animation_finished
	if has_skill:
		show_desc()
	
func show_item_menu() -> void:
	show()
	description.hide()
	populate_item_list()
	animation_player.play("show")
	B2_Sound.play("sn_mouse_analoghover01")
	await animation_player.animation_finished
	if has_item:
		show_desc()
	
func hide_menu() -> void:
	if has_item or has_skill:
		hide_desc()
		
	disable_all_buttons( true )
	animation_player.play("hide")
	B2_Sound.play("sn_mouse_analoghover01")
	await animation_player.animation_finished
	hide()
	
	
func show_desc() -> void:
	description.show()
	if desc_tween:
		desc_tween.kill()
	desc_tween = create_tween()
	desc_tween.tween_property(description, "modulate", Color.WHITE, 0.15)
	
func hide_desc() -> void:
	if desc_tween:
		desc_tween.kill()
	desc_tween = create_tween()
	desc_tween.tween_property( description, "modulate", Color.TRANSPARENT, 0.15 )
	desc_tween.tween_callback( description.hide )
