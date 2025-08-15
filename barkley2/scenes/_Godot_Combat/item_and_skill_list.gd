extends Control

#@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var top_panel: NinePatchRect = $top_panel

@onready var item_list: VBoxContainer = $top_panel/items/item_list

## Description
@onready var description: PanelContainer 	= $top_panel/description
@onready var description_text: Label 		= $top_panel/description/margin/description_text

var has_item 	:= false
var has_skill 	:= false
var desc_tween 	: Tween
var menu_tween	: Tween # Tweener used to show / hide the menu.

func _ready() -> void:
	description.hide()
	description.modulate = Color.TRANSPARENT

func disable_all_buttons( disabled : bool ) -> void:
	for b in item_list.get_children():
		if b is Button:
			b.disabled = disabled

func populate_skill_list():
	for c in item_list.get_children():
		c.queue_free()
	
	has_skill = false
	var first_skill : Button
	
	description_text.text = Text.pr( "Description not loaded (BUG)" ) ## Avoid loading previous item description.
	
	var wpn : B2_Weapon = B2_Gun.get_current_gun()
	
	if wpn:
		var wpn_xp := wpn.weapon_xp
		for skill_name : B2_Gun.SKILL in wpn.skill_list:
			var skill := B2_Gun.get_skill( skill_name )
			
			## Check if current Gun XP is enought to unlock this skill
			if wpn_xp >= wpn.skill_list[ skill_name ]:
				var btn := Button.new()
				btn.text = Text.pr( skill.skill_name )
				var t := ""
				t = Text.pr( skill.skill_description )
				t += Text.pr( "\nCost: %s A.P." % str( skill.skill_action_cost ) )
				t += Text.pr( "\nAmmo required: %s" % str( skill.ammo_per_shot ) )
				
				btn.mouse_entered.connect( btn.call_deferred.bind("grab_focus") )
				btn.focus_entered.connect( description_text.set_text.bind( t ) )
				btn.pressed.connect( get_parent().select_skill.bind( skill ) ) ## select_skill is on the combat module.
				
				btn.custom_minimum_size.y = 14.0
				item_list.add_child( btn, true )
				
				@warning_ignore("unassigned_variable")
				if not first_skill:
					first_skill = btn
				has_skill = true
			
		if not has_skill:
			var label := Label.new()
			label.text = Text.pr( "No skills :(" )
			label.name = "no_skill_label"
			item_list.add_child( label, true )
			description_text.text = Text.pr( "No skills :(" )
		else:
			if is_instance_valid(first_skill):
				first_skill.call_deferred.bind("grab_focus")
			else:
				# ?????????
				breakpoint
			
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
				btn.text = Text.pr( item )
				btn.name = Text.pr( str(item) ) + "_" + str(slot)
				
				var candy_data : Dictionary = B2_Candy.get_candy( item )
				btn.tooltip_text = Text.pr( candy_data["utility"] + "\n\n" + '"' + candy_data["flavor"] + '"' )
				
				btn.mouse_entered.connect( btn.call_deferred.bind("grab_focus") )
				btn.focus_entered.connect( description_text.set_text.bind( btn.tooltip_text ) )
				btn.pressed.connect( get_parent().use_item.bind( slot ) ) ## use_item is on the combat module.
				
				btn.custom_minimum_size.y = 12.0
				item_list.add_child( btn, true )
				
				@warning_ignore("unassigned_variable")
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
			first_item.call_deferred.bind("grab_focus")
		else:
			# ?????????
			breakpoint

func focus_on_first_item() -> void:
	item_list.get_children().front().grab_focus()

func show_skill_menu() -> void:
	show()
	top_panel.show()
	description.hide()
	populate_skill_list()
	if menu_tween: menu_tween.kill()
	menu_tween = create_tween()
	menu_tween.set_ignore_time_scale( true )
	menu_tween.tween_property(top_panel, "position:y", -57.0, 0.25) # animation_player.play("show")
	B2_Sound.play("sn_mouse_analoghover01")
	await menu_tween.finished # await animation_player.animation_finished
	focus_on_first_item()
	if has_skill:
		show_desc()
	
func show_item_menu() -> void:
	show()
	top_panel.show()
	description.hide()
	populate_item_list()
	if menu_tween: menu_tween.kill()
	menu_tween = create_tween()
	menu_tween.set_ignore_time_scale( true )
	menu_tween.tween_property(top_panel, "position:y", -57.0, 0.25) # animation_player.play("show")
	B2_Sound.play("sn_mouse_analoghover01")
	await menu_tween.finished # await animation_player.animation_finished
	focus_on_first_item()
	if has_item:
		show_desc()
	
func hide_menu() -> void:
	if has_item or has_skill:
		hide_desc()
	if visible:
		top_panel.show()
		disable_all_buttons( true )
		if menu_tween: menu_tween.kill()
		menu_tween = create_tween()
		menu_tween.set_ignore_time_scale( true )
		menu_tween.tween_property(top_panel, "position:y", 0, 0.25) # animation_player.play("hide")
		B2_Sound.play("sn_mouse_analoghover01")
		await menu_tween.finished # await animation_player.animation_finished
		hide()
		top_panel.hide()
	
	
func show_desc() -> void:
	description.show()
	if desc_tween: desc_tween.kill()
	desc_tween = create_tween()
	desc_tween.tween_property(description, "modulate", Color.WHITE, 0.15)
	
func hide_desc() -> void:
	if desc_tween: desc_tween.kill()
	desc_tween = create_tween()
	desc_tween.tween_property( description, "modulate", Color.TRANSPARENT, 0.15 )
	desc_tween.tween_callback( description.hide )
