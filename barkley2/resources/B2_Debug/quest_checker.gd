extends VBoxContainer

@onready var quest_request: LineEdit = $quest_request
@onready var quest_value_lbl: Label = $HBoxContainer/quest_value_lbl
@onready var quest_value: LineEdit = $HBoxContainer/quest_value
@onready var quest_result_type_lbl: Label = $quest_result_type_lbl

func _on_quest_request_text_submitted(new_text: String) -> void:
	quest_value.text = str( B2_Playerdata.Quest(new_text) )
	quest_result_type_lbl.text = type_string( typeof( B2_Playerdata.Quest(new_text) ) )

func _on_quest_request_text_changed(new_text: String) -> void:
	quest_value.text = str( B2_Playerdata.Quest(new_text) )
	quest_result_type_lbl.text = type_string( typeof( B2_Playerdata.Quest(new_text,null, 0) ) )

func _on_quest_value_set_btn_pressed() -> void:
	if quest_value.text.is_empty():
		return
	
	if quest_value.text.is_valid_float():
		B2_Playerdata.Quest( str(quest_request.text), float(quest_value.text) )
	elif quest_value.text.is_valid_int():
		B2_Playerdata.Quest( str(quest_request.text), int(quest_value.text) )
	else:
		B2_Playerdata.Quest( str(quest_request.text), str(quest_value.text).strip_edges() )

func _on_quest_result_type_lbl_visibility_changed() -> void:
	if visible:
		#B2_Input.player_has_control = not visible # Disable control if the debug map is open.
		print_rich("[color=red][b]quest_checker[/b] window OPEN! Player control disabled.[/color]")

func _on_quest_checker_close_requested() -> void:
	#B2_Input.player_has_control = true
	pass
