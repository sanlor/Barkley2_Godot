extends HBoxContainer

signal file_loaded

@onready var load_bg: FileDialog = $load_bg

@onready var button: Button = $Button
@onready var label: Label = $Label

var bg_folder_path 		:= "res://barkley2/assets/b2_original/backgrounds/"

var required_file := ""
var selected_file_path := ""

var index := 0 # id related to bg name.


func _on_load_bg_file_selected(path: String) -> void:
	selected_file_path = path
	
	path.replace("\\", "/")
	var split_path : Array = path.split( "/", false )
	var file : String = split_path.back()
	if file.trim_suffix(".png") != required_file:
		label.text = file + " loaded. ( incorrect name, expected %s )" % required_file
		label.modulate = Color.RED
	else:
		label.text = file
		label.modulate = Color.GREEN
	
	file_loaded.emit( index, selected_file_path ) 

func set_required_file( file : String ):
	required_file = file
	button.text = "Load BG"
	
	label.text = required_file + " missing."
	label.modulate = Color.YELLOW
	#load_bg.filters[0] = required_file

func is_file_loaded():
	return not selected_file_path.is_empty()

func _on_button_pressed() -> void:
	#pressed.emit()
	load_bg.access = FileDialog.ACCESS_RESOURCES
	load_bg.current_dir = bg_folder_path
	load_bg.show()
