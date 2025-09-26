extends PanelContainer

@onready var gun_parent_top: 		PanelContainer = $"../gun_top"
@onready var gun_parent_bottom: 	PanelContainer = $"../gun_bottom"

@onready var gun_title_lbl: 	Label = $gun_container/gun_title_lbl
@onready var gun_texture: 		TextureRect = $gun_container/gun_texture

var top_gun : 		B2_Weapon
var bottom_gun : 	B2_Weapon
var my_gun : 		B2_Weapon

func _ready() -> void:
	gun_parent_top.gun_updated.connect(_load_top_gun)
	gun_parent_bottom.gun_updated.connect(_load_bottom_gun)

func _load_top_gun( gun : B2_Weapon ) -> void:
	if gun: top_gun = gun
	_make_offspring()
	
func _load_bottom_gun( gun : B2_Weapon ) -> void:
	if gun: bottom_gun = gun
	_make_offspring()

func _make_offspring() -> void:
	if top_gun and bottom_gun:
		my_gun = B2_Gun.generate_gun_from_parents(top_gun, bottom_gun)
		_update_data()

func _update_data() -> void:
	if my_gun:
		gun_title_lbl.text = my_gun.get_full_name()
		gun_texture.texture = my_gun.get_weapon_hud_sprite()
	else:
		gun_title_lbl.text = "No gun :("
		gun_texture.texture = PlaceholderTexture2D.new()
		gun_texture.texture.size = Vector2(49.0, 24.0)

func _on_rebreed_btn_pressed() -> void:
	_make_offspring()
