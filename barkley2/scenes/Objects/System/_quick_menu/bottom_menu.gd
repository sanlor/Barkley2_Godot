@tool
extends B2_Border

@onready var h_box_container: HBoxContainer = $bg/HBoxContainer

func _post_ready() -> void:
	pass
	
func flicker( alpha : float ) -> void:
	for c in h_box_container.get_children():
		c.modulate.a = alpha
