extends PanelContainer

@onready var weight_lbl: Label = $MarginContainer/VBoxContainer/HBoxContainer/weight_lbl
@onready var eletron_lbl: Label = $MarginContainer/VBoxContainer/HBoxContainer/eletron_lbl
@onready var name_lbl: Label = $MarginContainer/VBoxContainer/name_lbl

var mat := B2_Gun.MATERIAL.NONE

func set_material_name( _name : String ) -> void:
	name_lbl.text = _name

func set_material_weight( _wgt : int ) -> void:
	weight_lbl.text = str(_wgt)
	
func set_material_eletron( _num : int ) -> void:
	eletron_lbl.text = str(_num)

func clear() -> void:
	weight_lbl.queue_free()
	eletron_lbl.queue_free()
	name_lbl.queue_free()
