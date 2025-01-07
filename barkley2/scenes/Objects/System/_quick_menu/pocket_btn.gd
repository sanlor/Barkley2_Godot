extends Panel

## TODO Actually make this work

@onready var pocket_descript_lbl: Label = $pocket_descript_lbl

func _ready() -> void:
	_on_mouse_exited()

func _on_mouse_entered() -> void:
	pocket_descript_lbl.text = Text.pr("Empty")
	modulate = Color.YELLOW

func _on_mouse_exited() -> void:
	pocket_descript_lbl.text = Text.pr("X")
	modulate = Color.GRAY
