extends PanelContainer

@onready var gml_project_file: HBoxContainer 		= $MarginContainer/VBoxContainer/gml_project_file
@onready var sprite_object_folder: HBoxContainer 	= $MarginContainer/VBoxContainer/sprite_object_folder


@onready var obj_label: Label 				= $MarginContainer/VBoxContainer/sprite_object_folder/obj_Label
@onready var img_label: Label 				= $MarginContainer/VBoxContainer/sprite_image_folder/img_Label
@onready var out_label: Label 				= $MarginContainer/VBoxContainer/sprite_image_folder2/out_Label
@onready var project_label: Label 			= $MarginContainer/VBoxContainer/gml_project_file/project_Label

@onready var details_label: RichTextLabel 			= $MarginContainer/VBoxContainer/details/MarginContainer/ScrollContainer/details_Label

@onready var obj_button: Button 			= $MarginContainer/VBoxContainer/sprite_object_folder/obj_Button
@onready var img_button: Button 			= $MarginContainer/VBoxContainer/sprite_image_folder/img_Button
@onready var project_button: Button 		= $MarginContainer/VBoxContainer/gml_project_file/project_Button
@onready var out_button: Button 			= $MarginContainer/VBoxContainer/sprite_image_folder2/out_Button

@onready var check_hierarchy: CheckButton 	= $MarginContainer/VBoxContainer/check_hierarchy

@onready var lets_a_go_button: Button 		= $MarginContainer/VBoxContainer/lets_a_go_Button

@onready var file_dialog: FileDialog 		= $FileDialog

@onready var skip_label: Label = $MarginContainer/VBoxContainer/skip_sprite/skip_Label
@onready var limit_label: Label = $MarginContainer/VBoxContainer/limit_sprite/limit_Label

@onready var skip_text: LineEdit 	= $MarginContainer/VBoxContainer/skip_sprite/skip_text
@onready var limit_text: LineEdit 	= $MarginContainer/VBoxContainer/limit_sprite/limit_text


var obj_folder_path 	:= "Y:/tmp/barkley_2/Barkley2.gmx/sprites"
var img_folder_path 	:= "res://barkley2/assets/b2_original/images/merged/"
var out_folder_path		:= "res://barkley2/resources/sprites/"
var proj_file_path 		:= ""

enum MODE{OBJ,IMG,OUT,PROJECT}
var curr_MODE := MODE.OBJ

enum NOTIF{INFO,NOTICE,WARN,ERROR}

var project_file_extention := "*.gmx"

var has_errors := true

var _skip		:= 0
var _limit 		:= 0

func _ready() -> void:
	get_tree().root.content_scale_mode = Window.CONTENT_SCALE_MODE_DISABLED
	DisplayServer.window_set_size(Vector2i(800, 800))
	
	load_config()
	_on_check_hierarchy_pressed()
	_on_skip_text_text_submitted( str(_skip) )
	_on_limit_text_text_submitted( str(_limit) )
	
func save_config():
	var config := ConfigFile.new()
	config.set_value("paths", "obj_folder_path", obj_folder_path)
	config.set_value("paths", "img_folder_path", img_folder_path)
	config.set_value("paths", "out_folder_path", out_folder_path)
	config.set_value("paths", "proj_file_path", proj_file_path)
	config.set_value("config", "check_hierarchy", check_hierarchy.button_pressed)
	config.set_value("config", "limit", _limit)
	config.set_value("config", "skip", _skip)
	
	config.save("user://config.cfg")

func load_config():
	var config := ConfigFile.new()
	if not FileAccess.file_exists("user://config.cfg"):
		return
		
	config.load("user://config.cfg")
	
	obj_folder_path 					= config.get_value("paths", "obj_folder_path")
	img_folder_path 					= config.get_value("paths", "img_folder_path")
	out_folder_path 					= config.get_value("paths", "out_folder_path")
	proj_file_path 						= config.get_value("paths", "proj_file_path")
	check_hierarchy.button_pressed 		= config.get_value("config", "check_hierarchy")
	_limit 								= config.get_value("config", "limit")
	_skip 								= config.get_value("config", "skip")
	
	_on_check_hierarchy_pressed()
	obj_label.text 		= obj_folder_path
	img_label.text 		= img_folder_path
	out_label.text 		= out_folder_path
	project_label.text 	= proj_file_path

func file_window_folder():
	file_dialog.file_mode = FileDialog.FILE_MODE_OPEN_DIR
	file_dialog.filters = PackedStringArray()
	
	match curr_MODE:
		MODE.OBJ:
			file_dialog.current_dir = obj_folder_path
			file_dialog.access = FileDialog.ACCESS_FILESYSTEM
		MODE.IMG:
			file_dialog.access = FileDialog.ACCESS_RESOURCES
			file_dialog.current_dir = img_folder_path
		MODE.OUT:
			file_dialog.access = FileDialog.ACCESS_RESOURCES
			file_dialog.current_dir = out_folder_path
			
			
func file_window_file():
	file_dialog.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	file_dialog.add_filter(project_file_extention, "GMX file")
	file_dialog.current_path = proj_file_path

func _on_obj_button_pressed() -> void:
	curr_MODE = MODE.OBJ
	file_window_folder()
	file_dialog.popup()
	
func _on_img_button_pressed() -> void:
	curr_MODE = MODE.IMG
	file_window_folder()
	file_dialog.popup()
	
func _on_out_button_pressed() -> void:
	curr_MODE = MODE.OUT
	file_window_folder()
	file_dialog.popup()
	
func _on_check_hierarchy_pressed() -> void:
	gml_project_file.visible 		= check_hierarchy.button_pressed
	sprite_object_folder.visible 	= not check_hierarchy.button_pressed
	save_config()

func _on_project_button_pressed() -> void:
	file_window_file()
	curr_MODE = MODE.PROJECT
	file_dialog.popup()

func _on_lets_a_go_button_pressed() -> void:
	clear_info()
	if has_errors:
		add_info("Something is wrong with the selected folders/files. Check the log.", NOTIF.ERROR)
	else:
		start_convertion()

func _on_file_dialog_dir_selected(dir: String) -> void:
	match curr_MODE:
		MODE.OBJ:
			obj_folder_path = dir
			obj_label.text = obj_folder_path
		MODE.IMG:
			img_folder_path = dir
			img_label.text = img_folder_path
			
	save_config()
		
func _on_file_dialog_file_selected(path: String) -> void:
	match curr_MODE:
		MODE.PROJECT:
			proj_file_path = path
			project_label.text = proj_file_path
			save_config()
		_:
			breakpoint

func _on_skip_text_text_submitted(new_text: String) -> void:
	_skip = int(new_text)
	skip_text.text = str(_skip)
	skip_label.text = "Skip first %s sprites" % str(_skip)
	save_config()

func _on_limit_text_text_submitted(new_text: String) -> void:
	_limit = int(new_text)
	limit_text.text = str(_limit)
	limit_label.text = "Limit to %s sprites (0 means no limit)" % str(_limit)
	save_config()

## Notification stuff
func clear_info():
	details_label.clear()
	
func add_info(text : String, level := NOTIF.INFO):
	match level:
		NOTIF.INFO: 	details_label.push_color( Color.WHITE )
		NOTIF.NOTICE: 	details_label.push_color( Color.GRAY )
		NOTIF.WARN: 	details_label.push_color( Color.YELLOW )
		NOTIF.ERROR: 	details_label.push_color( Color.RED )
	details_label.append_text( text + "\n" )

## File Processing
func count_files(files : PackedStringArray, suffix_filter : PackedStringArray) -> int:
	var n := 0
	
	for i : String in files:
		for s : String in suffix_filter:
			if i.ends_with(s):
				n += 1
	return n
	
func _on_check_files_pressed() -> void:
	clear_info()
	var _has_errors = false
		
	if DirAccess.dir_exists_absolute(img_folder_path) and not img_folder_path == "":
		var files = DirAccess.get_files_at(img_folder_path)
		var n_files := count_files(files, [".png",".jpg",".bmp"])
		add_info( "Image folder exist. Cool. Found %s valid files of a total of %s." % [n_files, files.size()] )
	else:
		add_info("Image folder does not exist.", NOTIF.ERROR)
		_has_errors = true
		
	if DirAccess.dir_exists_absolute(out_folder_path) and not out_folder_path == "":
		if DirAccess.get_directories_at(out_folder_path).size() > 0:
			add_info("Output folder is not empty. Things may be overwritten. Are you sure about this?", NOTIF.WARN)
		else:
			add_info("Output folder is empty. Great!")
	else:
		add_info("Output folder does not exist.", NOTIF.ERROR)
		#_has_errors = true
			
	if check_hierarchy.button_pressed:
		if FileAccess.file_exists(proj_file_path) and not proj_file_path == "":
			add_info("Project file exist. not sure if its valid, but it sure exists.")
		else:
			add_info("Project file doesnt exist. Check the file path again", NOTIF.ERROR)
			_has_errors = true
	else:
		if DirAccess.dir_exists_absolute(obj_folder_path) and not obj_folder_path == "":
			var files = DirAccess.get_files_at(obj_folder_path)
			var n_files := count_files(files, [".gmx"])
			add_info("Object folder exist. Cool. Found %s valid files of a total of %s." % [n_files, files.size()] )
		else:
			add_info("Object folder does not exist.", NOTIF.ERROR)
			_has_errors = true
			
	if not _has_errors:
		has_errors = false
	else:
		has_errors = true
		
func start_convertion():
	var time := Time.get_ticks_msec()
	add_info("Started parsing files at %s." % Time.get_time_string_from_system(), NOTIF.NOTICE)
	
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	
	var sprite_data_array := []
	
	var skip 	:= 0
	var limit 	:= 0
	
	if check_hierarchy.button_pressed:
		add_info("Function not implemented.")
		return
	else:
		var files = DirAccess.get_files_at(obj_folder_path)
		
		for file : String in files:
			var parser := XMLParser.new()
			var error = parser.open( obj_folder_path + "\\" + file  )
			if error != OK:
				push_error( error, " - Couldnt parse the file ", obj_folder_path + "\\" + file )
				return
				
			var write_text_to := ""
			var write_to_array := false
			var sprite_data := {}
			var frame_array := []
			
			sprite_data["name"] = file.trim_suffix(".gmx")
			
			while parser.read() != ERR_FILE_EOF:
				if parser.get_node_type() == XMLParser.NODE_ELEMENT:
					var node_name = parser.get_node_name()
					
					# X offset and  Y offset
					if node_name == "xorig" or node_name == "yorigin":
						sprite_data[node_name] = null
						write_text_to = node_name

					# Frame is the sprite frames
					elif node_name == "frame":
						#sprite_data[ parser.get_named_attribute_value("index") ] = null
						#write_text_to = parser.get_named_attribute_value("index")
						write_to_array = true
						
					#elif node_name == "frames":
						#sprite_data[node_name] = null
						#write_text_to = node_name
						
				if parser.get_node_type() == XMLParser.NODE_TEXT:
					if not write_text_to.is_empty():
						#print(parser.get_node_data())
						sprite_data[write_text_to]  = parser.get_node_data()
						write_text_to = ""
					if write_to_array:
						frame_array.append( parser.get_node_data() )
						write_to_array = false
							
						
			sprite_data["frames"] = frame_array
			
			if skip > _skip or _skip == 0:
				sprite_data_array.append(sprite_data)
				
				if limit >= _limit and _limit != 0:
					# set limit reached.
					break
				else:
					limit += 1
			else:
				skip += 1
			
		add_info("Finished parsing the files at %s." % Time.get_time_string_from_system(), NOTIF.NOTICE)
		add_info("It took %s msecs." % str(Time.get_ticks_msec() - time), NOTIF.NOTICE)
		
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	
	add_info("Started creating nodes at %s." % Time.get_time_string_from_system(), NOTIF.NOTICE)
	
	if check_hierarchy.button_pressed:
		add_info("Function not implemented.")
		return
	else:
		for sprite in sprite_data_array:
			# get important data
			var anim_sprite 		:= AnimatedSprite2D.new()
			var spr_frames 			:= SpriteFrames.new()
			
			anim_sprite.centered 	= false
			anim_sprite.offset.x 	= float( sprite["xorig"] )
			anim_sprite.offset.y 	= float( sprite["yorigin"] )
			anim_sprite.name 		= sprite["name"]
			
			print(sprite["frames"])
			var n_frames 			:= sprite["frames"].size() as int
			
			for frame : String in sprite["frames"]:
				var t_frame = frame.trim_prefix("images\\")
				var frame_suffix := t_frame.right(4) # get the last 4 characters. thats the file suffix (.png)
				t_frame = t_frame.trim_suffix( frame_suffix )
				
				var split_frame := t_frame.split("_", false)
				# split_frame[0] is the file name
				# split_frame[1] is its offset
				var _path = img_folder_path + "\\" + split_frame[0] + frame_suffix
				
				if not FileAccess.file_exists(_path):
					add_info("Error, file %s not found." % _path, NOTIF.ERROR)
					await get_tree().process_frame
					await get_tree().process_frame
					continue
				
				# https://forum.godotengine.org/t/how-to-add-frames-from-a-sprite-sheet-in-code/5230/2
				# WARNING this is bullshit.
				var texture 	: Texture2D = ResourceLoader.load(_path, "Texture2D")
				var offset 		:= float( split_frame[1] )
				var img_x 		:= texture.get_width() / float(n_frames)
				var img_y 		:= texture.get_height()
				
				var atlas := AtlasTexture.new()
				atlas.atlas = texture
				atlas.region = Rect2( 
					Vector2( img_x * offset, 			0), 
					Vector2( img_x, 					img_y)
					)
				
				spr_frames.add_frame("default", atlas)
			
			anim_sprite.sprite_frames = spr_frames
			
			var scene = PackedScene.new()
			scene.pack(anim_sprite)
			ResourceSaver.save( scene, out_folder_path + "\\%s.tscn" % sprite["name"] )
			
	OS.shell_open (ProjectSettings.globalize_path( out_folder_path ) )
