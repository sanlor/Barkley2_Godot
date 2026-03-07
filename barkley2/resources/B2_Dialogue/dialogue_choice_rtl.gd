extends RichTextLabel

var button_parent : Button

func _on_ready() -> void:
	if get_parent() is Button:
		button_parent = get_parent()
