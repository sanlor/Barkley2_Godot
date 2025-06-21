extends HBoxContainer

var selected := false

func _on_focus_entered() -> void:
	for c in get_children():
		if c is Panel:
			c.self_modulate = Color.WHITE * 2.0
	selected = true
	
func _on_focus_exited() -> void:
	for c in get_children():
		if c is Panel:
			c.self_modulate = Color.WHITE * 1.0
	selected = false
