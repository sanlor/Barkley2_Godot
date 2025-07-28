extends VBoxContainer

@onready var quest_request: LineEdit = $quest_request
@onready var result_lbl: Label = $result_lbl

func _on_quest_request_text_submitted(new_text: String) -> void:
	result_lbl.text = "Result: " + str( B2_Playerdata.Quest(new_text, null, "NO DATA") )
