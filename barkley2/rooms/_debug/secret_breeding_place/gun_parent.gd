extends PanelContainer

@onready var gun_title_lbl: Label = $gun_container/gun_title_lbl
@onready var gun_texture: TextureRect = $gun_container/gun_texture

@export var my_child : PanelContainer
@export var is_top := false
var my_gun : 		B2_Weapon

func _ready() -> void:
	my_child.gun_updated.connect( _update_data )
	
func _update_data( _my_gun : B2_Weapon ) -> void:
	
	
	if _my_gun:
		if is_top: 	my_gun = B2_Gun.dict_to_gun( _my_gun.lineage_top )
		else:		my_gun = B2_Gun.dict_to_gun( _my_gun.lineage_bot )
		
		gun_title_lbl.text = my_gun.get_full_name()
		gun_texture.texture = my_gun.get_weapon_hud_sprite()
	else:
		gun_title_lbl.text = "No gun :("
		gun_texture.texture = PlaceholderTexture2D.new()
		gun_texture.texture.size = Vector2(49.0, 24.0)
