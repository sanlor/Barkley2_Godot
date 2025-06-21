extends "res://barkley2/scenes/_utilityStation/gun_info_panel.gd"
#extends Control

const CONFIRMATION_BOX = preload("res://barkley2/scenes/_utilityStation/confirmation_box.tscn")

## Current
func _on_gun_smelt_current_btn_pressed() -> void:
	if B2_Gun.get_bandolier().is_empty() and B2_Gun.get_gunbag().is_empty():
		return
		
	if not selected_gun:
		return
		
	var confirm := CONFIRMATION_BOX.instantiate()
	get_tree().current_scene.add_child(confirm, true)
	confirm.setup_text( Text.pr( "Are you sure you want to smelt your current gun '%s' ?" % selected_gun.get_short_name() ) )
	confirm.show_panel()
	var choice : bool = await confirm.confirmation
	if choice:
		apply_smelt_point( 50 )
		B2_Gun.remove_gun_from_bandolier( selected_gun )
		_on_visibility_changed()
		changed_window_state.emit()

func _on_gun_smelt_current_btn_focus_entered() -> void:
	if B2_Gun.get_bandolier().size() > 0:			preview_smelt( 50 )
	else:											preview_smelt( 0 )

func _on_gun_smelt_current_btn_mouse_entered() -> void:
	if B2_Gun.get_bandolier().size() > 0:			preview_smelt( 50 )
	else:											preview_smelt( 0 )

## Empty
func _on_gun_smelt_empty_btn_pressed() -> void:
	if B2_Gun.get_bandolier().is_empty() and B2_Gun.get_gunbag().is_empty():
		return
		
	var confirm := CONFIRMATION_BOX.instantiate()
	add_child(confirm, true)
	confirm.setup_text( Text.pr( "Are you sure you want to smelt every gun out of ammo?" ) )
	confirm.show_panel()
	var choice : bool = await confirm.confirmation
	if choice:
		var empty_guns := []
		for gun in B2_Gun.get_gunbag():
			if gun.curr_ammo <= 0:
				empty_guns.append(gun)
		apply_smelt_point( empty_guns.size() * 50 )
		
		for gun in empty_guns:
			B2_Gun.remove_gun_from_gunbag( gun )
			
		_on_visibility_changed()
		changed_window_state.emit()

func _on_gun_smelt_empty_btn_focus_entered() -> void:
	var empty_guns := []
	for gun in B2_Gun.get_gunbag():
		if gun.curr_ammo <= 0:
			empty_guns.append(gun)
	preview_smelt( empty_guns.size() * 50 )

func _on_gun_smelt_empty_btn_mouse_entered() -> void:
	var empty_guns := []
	for gun in B2_Gun.get_gunbag():
		if gun.curr_ammo <= 0:
			empty_guns.append(gun)
	preview_smelt( empty_guns.size() * 50 )

## Unfaves
func _on_gun_smelt_unfaves_btn_pressed() -> void:
	if B2_Gun.get_bandolier().is_empty() and B2_Gun.get_gunbag().is_empty():
		return
		
	var confirm := CONFIRMATION_BOX.instantiate()
	get_tree().current_scene.add_child(confirm, true)
	confirm.setup_text( Text.pr( "Are you sure you want to smelt every unfavorite guns?" ) )
	confirm.show_panel()
	var choice : bool = await confirm.confirmation
	if choice:
		var unfave_guns := []
		for gun in B2_Gun.get_gunbag():
			if not gun.favorite:
				unfave_guns.append(gun)
		apply_smelt_point( unfave_guns.size() * 50 )
		
		for gun in unfave_guns:
			B2_Gun.remove_gun_from_gunbag( gun )
			
		_on_visibility_changed()
		changed_window_state.emit()

func _on_gun_smelt_unfaves_btn_mouse_entered() -> void:
	var unfave_guns := []
	for gun in B2_Gun.get_gunbag():
		if not gun.favorite:
			unfave_guns.append(gun)
	preview_smelt( unfave_guns.size() * 50 )

func _on_gun_smelt_unfaves_btn_focus_entered() -> void:
	var unfave_guns := []
	for gun in B2_Gun.get_gunbag():
		if not gun.favorite:
			unfave_guns.append(gun)
	preview_smelt( unfave_guns.size() * 50 )

## Inbag
func _on_gun_smelt_inbag_btn_pressed() -> void:
	if B2_Gun.get_bandolier().is_empty() and B2_Gun.get_gunbag().is_empty():
		return
		
	var confirm := CONFIRMATION_BOX.instantiate()
	get_tree().current_scene.add_child(confirm, true)
	confirm.setup_text( Text.pr( "Are you sure you want to smelt all Gun'sbag guns?") )
	confirm.show_panel()
	var choice : bool = await confirm.confirmation
	if choice:
		apply_smelt_point( B2_Gun.get_gunbag().size() * 50 )
		B2_Gun.reset_gunbag()
		_on_visibility_changed()
		changed_window_state.emit()

func _on_gun_smelt_inbag_btn_focus_entered() -> void:
	preview_smelt( B2_Gun.get_gunbag().size() * 50 )

func _on_gun_smelt_inbag_btn_mouse_entered() -> void:
	preview_smelt( B2_Gun.get_gunbag().size() * 50 )
