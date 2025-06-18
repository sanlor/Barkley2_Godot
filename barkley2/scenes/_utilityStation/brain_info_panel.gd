extends Control

func update_menu() -> void:
	if not is_node_ready():
		return

func _on_visibility_changed() -> void:
	update_menu()
