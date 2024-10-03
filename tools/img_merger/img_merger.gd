extends Node2D

## Simple tool to parse GMLs sprites and merge all images used in these sprites.

@export var verbose_logs := false
@export var extra_verbose_logs := false

@export_global_dir var sprite_dir 		:= "E:\\tmp\\Barkley2_Original\\barkley_2\\Barkley2.gmx\\sprites"
var count := 0

@export var merged_path 				:= "user://merged/"
var default_merged_path					:= "user://merged/"

func parse_gmx(filename : String) -> Dictionary:
	if not FileAccess.file_exists( filename ):
		print("There is no sprite called '%s'" % filename)
		return Dictionary()
		
	else:
		var parser := XMLParser.new()
		var error = parser.open(  filename )
		if error != OK:
			print_rich( "[color=red]%s - Couldnt parse the file %s.[/color]" % [error,filename] )
			return Dictionary()
			
		var write_text_to := ""
		var write_to_array := false
		var sprite_data := {}
		var frame_array := []
		
		sprite_data["name"] = filename.trim_suffix(".sprite.gmx")
		
		while parser.read() != ERR_FILE_EOF:
			if parser.get_node_type() == XMLParser.NODE_ELEMENT:
				var node_name = parser.get_node_name()
				
				# the size of the sprite reported by the sprite
				if node_name == "width" or node_name == "height":
					sprite_data[node_name] = null
					write_text_to = node_name
				
				# Frame is the sprite frames
				elif node_name == "frame":
					write_to_array = true
					
			if parser.get_node_type() == XMLParser.NODE_TEXT:
				if not write_text_to.is_empty():
					sprite_data[write_text_to]  = parser.get_node_data()
					write_text_to = ""
				# <frame index="0">images\s_cts_singingStand_0.png</frame>
				if write_to_array:
					frame_array.append( parser.get_node_data() )
					write_to_array = false
						
		sprite_data["frames"] = frame_array
		if extra_verbose_logs:
			print("Parse Successful for %s. " % filename)
		return sprite_data

func _ready():
	if merged_path.is_empty():
		merged_path = default_merged_path
		
	if not DirAccess.dir_exists_absolute( sprite_dir ):
		push_error("Folder %s does not exist. Check it again." % sprite_dir )
		get_tree().quit()
		
	if not DirAccess.dir_exists_absolute(merged_path):
		DirAccess.make_dir_recursive_absolute(merged_path)
		
	if not DirAccess.dir_exists_absolute( merged_path ):
		push_error("Folder %s does not exist. Check it again." % merged_path )
		get_tree().quit()
		
	var n_files := DirAccess.get_files_at( sprite_dir ).size()
	
	for file in DirAccess.get_files_at( sprite_dir ):
		if file.contains(".sprite.gmx"):
			# Parse the sprite data
			var sprite_data := parse_gmx( sprite_dir + "\\" + file )
			if sprite_data.is_empty():
				push_error( "Error parsing the sprite data from %s." % sprite_dir + "\\" + file )
				continue
			if int(sprite_data["width"]) == 0 or int(sprite_data["height"]) == 0:
				push_warning("Is the sprite empty? skipping it...")
				if verbose_logs:
					print(sprite_data)
				continue
			var size : int = sprite_data["frames"].size()
			
			## Blank image, with the correct size
			var merged_image := Image.create( int(sprite_data["width"]) * size, int(sprite_data["height"]), false, Image.FORMAT_RGBA8 )
			
			for sprite_index : int in range( sprite_data["frames"].size() ):
				
				# Load fragmented image.
				var sprite_path : String = sprite_dir + "\\" + sprite_data["frames"][sprite_index]
				var selected_sprite := Image.load_from_file( sprite_path )
				
				# Silly check about the sprites file name.
				var spr_name : String = sprite_data["frames"][sprite_index]
				spr_name = spr_name.trim_prefix("images\\").trim_suffix("_%s.png" % str(sprite_index))
				if spr_name != file.trim_suffix(".sprite.gmx"):
					push_warning("Weird, the image file name is different from the sprite name. Its probably not important, right?", [ file.trim_suffix(".sprite.gmx"), sprite_data["frames"][sprite_index] ])
				
				# loop every pixel on the image and copy it to the "merged_image", at the appropriate offset.
				## NOTE I didnt know that Image.blit_rect() existed. 
				for x in selected_sprite.get_width():
					var offset := selected_sprite.get_width() * sprite_index
					for y in selected_sprite.get_height():
						
						var sel_pixel : Color = selected_sprite.get_pixel( x, y )
						merged_image.set_pixel( x + offset, y, sel_pixel )
						
			merged_image.save_png(merged_path + file.trim_suffix(".sprite.gmx") + ".png")
			count += 1
			if verbose_logs:
				print( file.trim_suffix(".sprite.gmx") + ".png", " - ", count, " of ",  n_files )
			
	OS.shell_open( ProjectSettings.globalize_path( merged_path ) )
	print_rich("[color=green]Done! %s image files saved.[/color]" % DirAccess.get_files_at( merged_path ).size())
	get_tree().quit()
