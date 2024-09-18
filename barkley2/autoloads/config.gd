extends Node

## This autoload replaces the script "Config".
## Its only use is to save and load settings, along with emiting signals to let the other nodes know (if needed).
## The settings.ini file that this game makes if cross compatible with the original. cool, aint it?

## TODO port script scr_player_newPlayerIdentity()

enum SCALE {X2 = 2,X3 = 3,X4 = 4} ## The original game uses floats for values. Because of that, Im using Enums with specific values, even for boolean checks.
enum FILTER {OFF, CRT, BLOOM}
enum {OFF,ON}

## NOTES
# GMS Is a mess. Godot can also read/write ini files, check this: https://docs.godotengine.org/en/stable/classes/class_configfile.html
# null is TEMPORARY

var vsync := OFF
var AlBhed := OFF :
	set(al):
		AlBhed = al
		language_changed.emit()
		
var fullscreen := OFF
var screen_scale := SCALE.X2

var currentFilter := FILTER.OFF :
	set(filter):
		currentFilter = filter
		if currentFilter == FILTER.CRT:
			B2_Shaders.toggle_crt_shader( true )
		if currentFilter == FILTER.BLOOM:
			B2_Shaders.toggle_crt_shader( false )
		if currentFilter == FILTER.OFF:
			B2_Shaders.toggle_crt_shader( false )
			
var scanlines := OFF ## I think its an unused variable. Since the original game saves this variable, im doing it too.
#
var sfx_gain_master := 1.0
var bgm_gain_master := 1.0
var music = null
var sounds = null

signal game_settings_saved
signal game_settings_loaded

signal language_changed

var configsavefolder 	:= "user://_resources/"
var configsavefile 		:= "settings.ini"

## User Profile
var selected_slot 		:= 0
var usersavefile 		: Dictionary
var usersavefolder 		:= "user://"

## Main menu stuff
var tim_follow_mouse := false

func _init():
	## Original comments VV
	# We can load with default values.
	# We also save immediately just to ensure the file is editable by devs on initial boot.
	config_load()
	apply_config(false)
	
func _ready():
	pass

func has_user_save( slot ): # slot -> 0 to 2
	assert( slot >= 0 or slot <= 2)
	var savefile := "save%s.b2" % str(slot)
	if FileAccess.file_exists(usersavefolder + savefile ):
		return true
	else:
		return false
	
func select_user_slot( slot ):
	assert( slot >= 0 or slot <= 2 or slot == 100)
	# slot 100 is for debug purposes
	selected_slot = slot
	
	usersavefile.clear()
	
	var file := "save%s.b2" % str( slot )
	if FileAccess.file_exists( usersavefolder + file ):
		var savefile := FileAccess.open( usersavefolder + file, FileAccess.READ )
		var json := JSON.new()
		var parse_error := json.parse( savefile.get_as_text() )
		if parse_error == OK:
			usersavefile = json.get_data()
			savefile.close()
		else:
			push_error( "cant load save file:", parse_error )

	
# scr_savedata_put()
func get_user_save_data( path : String ): ## return null if its invalid
	if usersavefile.is_empty():
		push_error("No save data to get! Defaulting to debug slot 100.")
		select_user_slot( 100 )
		#return
				
	## This is a similar script to the scr_savedata_get
	var temp_dict := usersavefile
	var path_array := path.split(".")
	var loops := 0
	for i in path_array:
		if temp_dict.has(i):
			loops += 1
			if loops == path_array.size():
				return temp_dict[i]
			else:
				temp_dict = temp_dict[i]
		else:
			push_warning( "invalid key: ", i, " - Valid keys are: ", temp_dict.keys() )
			return
	
func set_user_save_data( path : String, value ):
	if usersavefile.is_empty():
		#push_error("Game not loaded. No place to save. discarting data: " + str(path) + " - " + str(value) )
		#return
		print("save game was empty.")
		usersavefile = Dictionary()
	
	var temp_dict := usersavefile # serves as the current directory of the search.
	var path_array := path.split(".") # Path to follow Ex.: "quest.vars.PlayerCCName"
	var loops := 0
	for i in path_array:
		loops += 1
		if temp_dict.has(i) and not loops == path_array.size():
			temp_dict = temp_dict[i]
			continue
			
		if loops == path_array.size():
			temp_dict[i] = value
			
		else:
			temp_dict[i] = Dictionary()
			temp_dict = temp_dict[i]

			#push_warning( "invalid key: ", i, " - Valid keys are: ", temp_dict.keys() )
	#print("Debug: save game is ", usersavefile)
			
func create_user_save_data( slot : int ): # Should be used on the title screen, que a new game on a empty slot is created. for CC, only create save game at the end.
	assert( slot >= 0 or slot <= 2)
	var file := "save%s.b2" % str( slot )
	if FileAccess.file_exists( usersavefolder + file ):
		# Creating a save slot on a existing slot? this is wrong, the old one should be deleted first
		# breakpoint
		pass
		
	selected_slot = slot
	var savefile := FileAccess.open( usersavefolder + file, FileAccess.WRITE )
	#var json := JSON.new()
	savefile.store_string( JSON.stringify( usersavefile ) )
	
	savefile.close()
	
func delete_user_save_data( slot : int ): # Should be used on the title screen.
	assert( slot >= 0 or slot <= 2)
	var file := "save%s.b2" % str( slot )
	if FileAccess.file_exists( usersavefolder + file ):
		DirAccess.remove_absolute(usersavefolder + file)
	else:
		push_warning("Tried to remove a save that doesnt exist: ", usersavefolder + file)
	
func apply_config( _save := true):
	if vsync == ON:
		DisplayServer.window_set_vsync_mode( DisplayServer.VSYNC_ENABLED )
	else:
		DisplayServer.window_set_vsync_mode( DisplayServer.VSYNC_DISABLED )
		
	if AlBhed == ON: ## TODO
		pass
	else:
		pass
		
	if fullscreen == ON:
		DisplayServer.window_set_mode( DisplayServer.WINDOW_MODE_FULLSCREEN )
	else:
		DisplayServer.window_set_mode( DisplayServer.WINDOW_MODE_WINDOWED )
		DisplayServer.window_set_size( Vector2i(384, 240) * screen_scale )
		
	if currentFilter == ON: ## TODO
		pass
	else:
		pass
	
	if scanlines == ON: ## TODO
		pass
	else:
		pass
		
	if _save:
		config_save()

func config_load():
	var config = ConfigFile.new()
	var error := config.load( configsavefolder + configsavefile )
	
	if error != OK:
		push_warning("No config file exist. Creating a new one.")
		config_save()
		return
		
	vsync 				= str_to_var( config.get_value("settings","vsync") 			)
	AlBhed 				= str_to_var( config.get_value("settings","alBhed") 		)
	fullscreen 			= str_to_var( config.get_value("settings","FullScreen") 	)
	screen_scale 		= str_to_var( config.get_value("settings","Scaling") 		)
	currentFilter 		= str_to_var( config.get_value("settings","Filter") 		)
	scanlines 			= str_to_var( config.get_value("settings","ScanLines") 		)
#	
	sfx_gain_master 	= str_to_var( config.get_value("settings","SoundLevel") 	)
	bgm_gain_master 	= str_to_var( config.get_value("settings","MusicLevel") 	)
	
	game_settings_loaded.emit()
	print( "Settings loaded! ", Time.get_ticks_msec() )

func config_save(): # //key, value
	var config = ConfigFile.new()
	config.set_value("settings", "MusicLevel", 		var_to_str(bgm_gain_master) 		)
	config.set_value("settings", "ScanLines", 		var_to_str(scanlines) 				)
	config.set_value("settings", "Scaling", 		var_to_str(screen_scale) 			)
	config.set_value("settings", "alBhed", 			var_to_str(AlBhed) 					)
	config.set_value("settings", "x", 				"xxx"								) ## No idea what this does
	config.set_value("settings", "vsync", 			var_to_str(vsync) 					)
	config.set_value("settings", "FullScreen", 		var_to_str(fullscreen) 				)
	config.set_value("settings", "Filter", 			var_to_str(currentFilter) 			)
	config.set_value("settings", "SoundLevel", 		var_to_str(sfx_gain_master) 		)
	
	if not DirAccess.dir_exists_absolute( configsavefolder ): ## make sure that the _resource folder exists.
		DirAccess.make_dir_absolute( configsavefolder )
	
	var err := config.save(configsavefolder + configsavefile)
	if err == OK:
		game_settings_saved.emit()
	else:
		push_error("Something went wrong with the settings saving routine: ", err)
