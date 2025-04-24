@tool
extends B2_Border

@onready var pocket_list: HBoxContainer = $bg/pocket_list

func _post_ready() -> void:
	pass
	
func flicker( alpha : float ) -> void:
	for c in pocket_list.get_children():
		if is_instance_valid(c):
			c.modulate.a = alpha
