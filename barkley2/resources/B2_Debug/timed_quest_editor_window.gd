extends AcceptDialog

const TIMED_QUEST_NODE : PackedScene = preload("uid://bbhdyt72nukya")

func _on_canceled() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN) 
	hide()

func _on_confirmed() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN) 
	hide()
