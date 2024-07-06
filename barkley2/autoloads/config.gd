extends Node

## This autoload replaces the script "Config".
## Its only use is to save and load settings, along with emiting signals to let the other nodes know (if needed).
## The settings.ini file that this game makes if cross compatible with the original. cool, aint it?

enum SCALE {X2 = 2,X3 = 3,X4 = 4} ## The original game uses floats for values. Because of that, Im using Enums with specific values, even for boolean checks.
enum FILTER {OFF, CRT, BLOOM}
enum {OFF,ON}

## NOTES
# GMS Is a mess. Godot can also read/write ini files, check this: https://docs.godotengine.org/en/stable/classes/class_configfile.html
# null is TEMPORARY

var vsync := OFF
var AlBhed := OFF
var fullscreen := OFF
var screen_scale := SCALE.X2
var currentFilter := FILTER.OFF
var scanlines := OFF ## I think its an unused variable. Since the original game saves this variable, im doing it too.
#
var sfx_gain_master := 1.0
var bgm_gain_master := 1.0
var music = null
var sounds = null

signal game_settings_saved
signal game_settings_loaded

var savefolder 	:= "user://_resources/"
var savefile 	:= "settings.ini"


func _init():
	## Original comments VV
	# We can load with default values.
	# We also save immediately just to ensure the file is editable by devs on initial boot.
	game_load()
	apply_config(false)
	
func _ready():
	pass

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
		game_save()

func game_load():
	var config = ConfigFile.new()
	var error := config.load( savefolder + savefile )
	
	if error != OK:
		push_warning("No config file exist. Creating a new one.")
		game_save()
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

func game_save(): # //key, value
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
	
	if not DirAccess.dir_exists_absolute(savefolder): ## make sure that the _resource folder exists.
		DirAccess.make_dir_absolute( savefolder )
	
	var err := config.save(savefolder + savefile)
	if err == OK:
		game_settings_saved.emit()
	else:
		push_error("Something went wrong with the settings saving routine: ", err)
