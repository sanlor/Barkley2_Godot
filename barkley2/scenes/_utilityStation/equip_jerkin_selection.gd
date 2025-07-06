extends Control

signal selected_equipment

enum TYPE{JERKIN,HELM}
@export var equip_type := TYPE.HELM

@onready var jerkin_texture: 	TextureRect = $jerkin_texture/jerkin_texture
@onready var jerkin_weight: 	Label = $jerkin_texture/jerkin_weight
@onready var jerkin_name: 		Label = $jerkin_data/vbox/jerkin_name
@onready var jerkin_grid: 		GridContainer = $jerkin_data/vbox/jerkin_grid

@onready var jerkin_texture_panel: 	Panel = $jerkin_texture
@onready var jerkin_data_panel: 	Panel = $jerkin_data


var my_equip_name := ""

func _ready() -> void:
	for i in jerkin_grid.get_children():
		if i is HBoxContainer:
			i.equip_type = equip_type
			i.my_equip_name = my_equip_name
		
	jerkin_texture.texture.region.position.x = 24.0 * float( B2_Jerkin.get_jerkin_stats(my_equip_name)["Sub"] )
	jerkin_weight.text = str( B2_Jerkin.get_jerkin_stats(my_equip_name)["Wgt"] ) + "~"
	if my_equip_name.is_empty():
		jerkin_name.text = str( B2_Jerkin.get_current_jerkin() )
	else:
		jerkin_name.text = str( my_equip_name )

func select() -> void:
	_on_focus_entered()
	print( str(self) + ": Selected." )
	grab_focus()

func _on_focus_entered() -> void:
	jerkin_texture_panel.self_modulate = Color.WHITE * 2.0
	jerkin_data_panel.self_modulate = Color.WHITE * 2.0
	selected_equipment.emit()

func _on_focus_exited() -> void:
	jerkin_texture_panel.self_modulate = Color.WHITE * 1.0
	jerkin_data_panel.self_modulate = Color.WHITE * 1.0
