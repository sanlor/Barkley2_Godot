extends Node2D

const spm_folder_path 		:= "/home/sanlo/Documents/GitHub/Barkley2_Original/barkley_2/Barkley2.gmx/datafiles/_resources/"
const result_file			:= "res://barkley2/resources/B2_Enemies/spawn_point_location.json"

func _ready() -> void:
	var json_file 		:= FileAccess.open( result_file, FileAccess.WRITE )
	var result_dict 	:= Dictionary()
	
	var all_files 		:= DirAccess.get_files_at(spm_folder_path)
	for file : String in all_files:
		var _file : String = FileAccess.get_file_as_string( spm_folder_path + file )
		var json = JSON.parse_string( _file )
		if json != null:
			result_dict[file.replace( ".spm", "" )] = json #JSON.stringify( json, "\t", false )
		else:
			print(file, ": ", json)
		pass
	json_file.store_string( JSON.stringify( result_dict, "\t", false ) )
	json_file.close()
