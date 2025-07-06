extends Panel
class_name B2_UtilityPanel_GunSelection

signal gun_selected( my_gun : B2_Weapon )

@export var gun_info_panel : B2_UtilityPanel
@onready var gun_text: TextureRect = $MarginContainer/HBoxContainer/gun_text
@onready var gun_value: Label = $MarginContainer/HBoxContainer/gun_value

@export var show_name := true
var my_gun : B2_Weapon
var selected := false

func _ready() -> void:
	focus_entered.connect( _on_focus_entered )
	focus_exited.connect( _on_focus_exited )
	custom_minimum_size = Vector2( 12.0, 16.0 )
	if show_name:
		custom_minimum_size = Vector2( 32.0, 16.0 )
		
func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouse: ## Avoid change of focus on mouse click
		return
		
	if event is InputEventKey or InputEventJoypadButton:
		if Input.is_action_just_pressed("Action") and has_focus():
			if my_gun:
				gun_selected.emit( my_gun ) ## Used in menus, when not using a mouse.
		
func setup( _my_gun : B2_Weapon ) -> void:
	if not is_node_ready():
		await ready
		
	my_gun = _my_gun
	
	if my_gun.favorite:		gun_text.modulate = Color.RED
	else:					gun_text.modulate = Color.WHITE
	
	gun_value.visible = show_name # Gunbag guns have hidden names
	update()
	if has_focus() or selected:
		_on_focus_entered()
	else:
		_on_focus_exited()
	
func update() -> void:
	gun_text.texture.region.position.x = 8.0 + 8.0 * my_gun.weapon_type
	gun_value.text = Text.pr( my_gun.get_short_name() )
	
func _on_focus_entered() -> void:
	if gun_info_panel and my_gun:
		gun_info_panel.update_data( my_gun )
	else:
		push_error("No weapon data.")
	self_modulate = Color.WHITE * 2.0
	selected = true
	B2_Sound.play("hoopz_swapguns")
	
func _on_focus_exited() -> void:
	self_modulate = Color.WHITE * 0.25
	selected = false
