extends AcceptDialog

@onready var text_edit: TextEdit = $VBoxContainer/TextEdit

var cutscene_script	: B2_Script_Legacy

func _ready() -> void:
	if not cutscene_script:
		cutscene_script = get_parent().cutscene_script
	visibility_changed.connect( _update_text )
	
func _update_text() -> void:
	text_edit.text = cutscene_script.original_script

func _on_save_btn_pressed() -> void:
	cutscene_script.original_script = text_edit.text

func _on_reload_btn_pressed() -> void:
	_update_text()
	
