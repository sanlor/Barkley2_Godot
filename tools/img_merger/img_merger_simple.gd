extends Node2D

## Simple tool to parse GMLs sprites and merge all images used in these sprites.

@export var verbose_logs := true
@export var extra_verbose_logs := false

@export_global_dir var sprite_dir 		:= "/home/sanlo/Documents/GitHub/Barkley2_Godot/barkley2/assets/b2_mod/art/roaring/unclean/"
var count := 0

@export var merged_path 				:= "user://merged/"
var default_merged_path					:= "user://merged/"

func count_files( partial_file_name : String ) -> int:
	var c := 0
	
	var regex := RegEx.new()
	regex.compile("^%s.\\d+\\.png$" % partial_file_name)

	for file in DirAccess.get_files_at( sprite_dir ):
		if regex.search(file) and not file.ends_with(".import"):
			c += 1
	return c

func get_files( partial_file_name : String ) -> PackedStringArray:
	var c := PackedStringArray()
	
	var regex := RegEx.new()
	regex.compile("^%s.\\d+\\.png$" % partial_file_name)
	
	for file in DirAccess.get_files_at( sprite_dir ):
		if regex.search(file) and not file.ends_with(".import"):
			c.append( file )
	return c

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
		if file.ends_with(".png"):
			var animation_name := "???"
			
			if file.ends_with("_0.png"):
				## OK, this is the first sprite of the animation.
				animation_name = file.trim_suffix("_0.png")
				
				## Number of frames
				var frames : int = count_files( animation_name ) 
				
				## Image to get the reference for each frame
				var img_reference := Image.load_from_file( sprite_dir + "/" + file )
				var img_reference_size := img_reference.get_size()
				
				## Blank image, with the correct size
				var merged_image := Image.create( img_reference.get_width() * frames, img_reference.get_height(), false, Image.FORMAT_RGBA8 )
				
				## All files related to the frames
				var all_frames := get_files( animation_name )
				
				## Loop on each image file
				for current_frame : String in all_frames:
					## Frame index
					var index := int( current_frame.trim_suffix(".png").rsplit("_", true,1)[1] )
					
					## Load fragmented image.
					var selected_sprite := Image.load_from_file( sprite_dir + "/" + current_frame )
					
					if selected_sprite.get_size() != img_reference_size:
						print( "%s %s" % [selected_sprite.get_used_rect(), img_reference_size])
						breakpoint
					
					# loop every pixel on the image and copy it to the "merged_image", at the appropriate offset.
					## NOTE I didnt know that Image.blit_rect() existed. 
					for x in selected_sprite.get_width():
						var offset := selected_sprite.get_width() * index
						for y in selected_sprite.get_height():
							var sel_pixel : Color = selected_sprite.get_pixel( x, y )
							merged_image.set_pixel( x + offset, y, sel_pixel )
						
				merged_image.save_png( merged_path + animation_name + ".png" )
				count += 1
				if verbose_logs:
					print( animation_name + ".png", " - ", count, " of ",  n_files )
			
	OS.shell_open( ProjectSettings.globalize_path( merged_path ) )
	print_rich("[color=green]Done! %s image files saved.[/color]" % DirAccess.get_files_at( merged_path ).size())
	get_tree().quit()
