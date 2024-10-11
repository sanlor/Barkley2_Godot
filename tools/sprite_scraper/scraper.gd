extends Node

@export var obj_folder_path 	:= "Y:/tmp/barkley_2/Barkley2.gmx/sprites"
@export var data_path 			:= "res://tools/sprite_scraper/"

# Simple tool to get sprite data from GMS and write to a text file.

func _ready() -> void:
	print("Starting...")
	
	var gms_sprite_data := {}
	
	var files := DirAccess.get_files_at(obj_folder_path)
	
	if files.is_empty():
		push_error("No files fount at %s." % obj_folder_path)
		return
		
	for file : String in files:
		var spr_data := parse_gmx( file )
		gms_sprite_data[ file.trim_suffix(".sprite.gmx") ] = spr_data
		
	var data_file = FileAccess.open(data_path + "dict.txt", FileAccess.WRITE)
	data_file.store_string( var_to_str(gms_sprite_data) )
	print("Done.")
	get_tree().quit()


func parse_gmx(filename : String) -> Dictionary:
	var parser := XMLParser.new()
	var error = parser.open( obj_folder_path + "/" + filename  )
	if error != OK:
		print( error, " - Couldnt parse the file ", obj_folder_path + "/" + filename )
		return Dictionary()
		
	var write_text_to := ""
	var sprite_data := {}
	
	while parser.read() != ERR_FILE_EOF:
		if parser.get_node_type() == XMLParser.NODE_ELEMENT:
			var node_name = parser.get_node_name()
			
			# X offset and  Y offset
			if node_name == "xorig" or node_name == "yorigin":
				sprite_data[node_name] = null
				write_text_to = node_name
				
			# not sure what this is, but may be important
			if node_name == "HTile" or node_name == "VTile":
				sprite_data[node_name] = null
				write_text_to = node_name
				
			# the size of the sprite reported by the sprite
			if node_name == "width" or node_name == "height":
				sprite_data[node_name] = null
				write_text_to = node_name
			
			# Colision data # NOTE WTF is this info inside the sprite?
			if node_name == "bbox_left" or node_name == "bbox_right" or \
				node_name == "bbox_top" or node_name == "bbox_bottom" or \
				node_name == "bboxmode" or node_name == "colkind":
					
				sprite_data[node_name] = null
				write_text_to = node_name
				
		if parser.get_node_type() == XMLParser.NODE_TEXT:
			if not write_text_to.is_empty():
				sprite_data[write_text_to]  = parser.get_node_data() as float
				write_text_to = ""
					
	#print("Parse Successful for %s. " % filename)
	return sprite_data
