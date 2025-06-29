extends Control

@onready var jerkin_texture: 	TextureRect 	= $jerkin_texture/jerkin_texture
@onready var jerkin_weight: 	Label 			= $jerkin_texture/jerkin_weight
@onready var jerkin_name: 		Label 			= $jerkin_data/vbox/jerkin_name


func _on_visibility_changed() -> void:
	if is_node_ready():
		if visible:
			jerkin_texture.texture.region.position.x = 24.0 * float( B2_Jerkin.get_jerkin_stats()["Sub"] )
			jerkin_weight.text = str( B2_Jerkin.get_jerkin_stats()["Wgt"] ) + "~"
			jerkin_name.text = str( B2_Jerkin.get_current_jerkin() )
