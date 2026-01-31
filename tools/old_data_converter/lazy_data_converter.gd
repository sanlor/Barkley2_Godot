@tool
extends Node2D

@export var file_name 											:= ""
@export_multiline("Old Data") var old_data_text 				:= ""
@export_tool_button("Let it rip!") var aaa 						: Callable = _ripper

func _ready() -> void:
	_ripper()

func _ripper() -> void:
	if file_name.is_empty():
		print("File name is empty. Quitting...")
		return
	if old_data_text.is_empty():
		print("old_data_text is empty. Quitting...")
		return
		
	#old_data_text = old_data_text.replace("P_NAME", '"P_NAME"')
	#old_data_text = old_data_text.replace("NULL", '"NULL"')
		
	var split_text := old_data_text.split("\n", false)
		
	var my_script := ""
		
	## Index IF events
	for text : String in split_text:
		
		## Dialog Handler
		if text.contains("scr_event_build_dialogue"):
			text = text.strip_edges() ## Cleanup
			
			my_script += "DIALOG"
			var regex := RegEx.new()
			regex.compile('\\(\\s*([^,]+)\\s*,\\s*([^,]+)\\s*,\\s*(.+)\\s*\\)')
			var result 		:= regex.search( text )
			
			var speaker 	:= result.get_string(1).replace('"', '')
			var sprite 		:= result.get_string(2).replace('"', '')
			var dialog_text	:= result.get_string(3).replace('"', '')
			
			if sprite == "NULL":
				my_script += " | %s | %s\n" % [speaker, dialog_text]
			else:
				my_script += " | %s = %s | %s\n" % [speaker, sprite, dialog_text]
		elif text.contains("scr_event_build_quest_state"):
			text = text.strip_edges() ## Cleanup
			
			var regex := RegEx.new()
			regex.compile('\\(\\s*("[^"]*"|[^,]+)\\s*,\\s*([^,]+)\\s*\\)')
			var result 		:= regex.search( text )
			
			var quest 	:= result.get_string(1).replace('"', '')
			var value 	:= result.get_string(2).replace('"', '')
			
			my_script += "QUEST | %s = %s\n" % [quest, value]
		else:
			my_script += text + "\n"
			
	print( my_script )
