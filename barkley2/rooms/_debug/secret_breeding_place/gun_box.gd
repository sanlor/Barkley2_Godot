extends PanelContainer

signal gun_updated( gun : B2_Weapon )

@onready var gun_title_lbl: Label = $gun_container/gun_title_lbl
@onready var gun_texture: TextureRect = $gun_container/gun_texture

var my_gun : B2_Weapon

func _ready() -> void:
	_update_data()

func _update_data() -> void:
	if my_gun:
		gun_title_lbl.text = my_gun.get_full_name()
		gun_texture.texture = my_gun.get_weapon_hud_sprite()
	else:
		gun_title_lbl.text = "No gun :("
		gun_texture.texture = PlaceholderTexture2D.new()
		gun_texture.texture.size = Vector2(49.0, 24.0)

func _on_gen_btn_pressed() -> void:
	my_gun = B2_Gun.generate_generic_gun()
	gun_updated.emit( my_gun )
	_update_data()
