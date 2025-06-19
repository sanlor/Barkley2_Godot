extends Panel

@export var gun_info_bando_panel : B2_UtilityPanel
@onready var bando_gun_text: TextureRect = $bando_gun_text
@onready var bando_gun_value: Label = $bando_gun_value


var my_gun : B2_Weapon

func _ready() -> void:
	focus_entered.connect( _on_focus_entered )
	focus_exited.connect( _on_focus_exited )
	
func setup( _my_gun : B2_Weapon ) -> void:
	my_gun = _my_gun
	bando_gun_text.texture.region.position.x = 8.0 + 8.0 * my_gun.weapon_type
	bando_gun_value.text = Text.pr( my_gun.get_short_name() )
	if has_focus():
		_on_focus_entered()
	else:
		_on_focus_exited()
	
func _on_focus_entered() -> void:
	if gun_info_bando_panel and my_gun:
		gun_info_bando_panel.update_data( my_gun )
	else:
		push_error("No weapon data.")
	self_modulate = Color.WHITE * 2.0
	
func _on_focus_exited() -> void:
	self_modulate = Color.WHITE * 0.25
