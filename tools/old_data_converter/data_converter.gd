@tool
extends Node2D

const CONVERTED_DATA := "res://tools/old_data_converter/converted_data/"


@export var file_name 											:= ""
@export_multiline("Old Data") var old_data_text 				:= ""
@export_tool_button("Let it rip!") var aaa 						: Callable = _ripper

func _ripper() -> void:
	if file_name.is_empty():
		print("File name is empty. Quitting...")
		return
	if old_data_text.is_empty():
		print("old_data_text is empty. Quitting...")
		return
	
	var cutscene_script 	:= B2_Script_Legacy.new()
	var my_script			:= ""
	
	var labels 				:= {}
	var label_index			:= 0
	
	var split_text := old_data_text.split("\n", false)
	var last_comment := ""
	
		
	## Index IF events
	for text : String in split_text:
		text = text.strip_edges() ## Cleanup
		
		if text.begins_with("//"):
			last_comment = text
			continue
			
		var condition_if 			:= false
		
		## IF Handler
		if text.contains("if "):
			my_script += "IF "
			condition_if = true
			label_index += 1
			labels[label_index] = []
			
		if text.contains("scr_quest_get_state"):
			var regex := RegEx.new()
			regex.compile('scr_quest_get_state\\("([^"]+)"\\)\\s*(==|!=|<=|>=|<|>)\\s*(\\d+)')
			
			var result := regex.search(text)
			var questname 	:= result.get_string(1)
			var comparator 	:= result.get_string(2)
			var value		:= result.get_string(3)
			
			my_script += "%s %s %s | %s " % [questname, comparator, value, "COND_%s" % label_index ]
			
			if last_comment:
				my_script += last_comment
				last_comment = ""
		
		## Dialog Handler
		if text.contains("scr_event_build_dialogue"):
			var _my_script = "DIALOG"
			var regex := RegEx.new()
			regex.compile("\"([^\"]*)\"")
			var result := regex.search_all( text )
			for _match in result:
				_my_script += " | " + _match.get_string(1)
			labels[label_index].append(_my_script)
		
		if text.contains(";"):
			my_script += "\n"
		
	for _labels in labels.keys():
		my_script += "\n"
		my_script += "COND_%s\n" % _labels
		for _label_content in labels[_labels]:
			my_script += _label_content + "\n"
		my_script += "EXIT |\n"
		
	print( my_script )
	cutscene_script.original_script = my_script
	ResourceSaver.save( cutscene_script, CONVERTED_DATA + file_name + ".tres" )
