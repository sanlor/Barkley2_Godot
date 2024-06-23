extends Node

## NOTES
# GMS Is a mess. Godot can also read/write ini files, check this: https://docs.godotengine.org/en/stable/classes/class_configfile.html
# null is TEMPORARY

var vsync = null
var AlBhed = null
var fullscreen = null
var screen_scale = null
var currentFilter = null
var scanlines = null
#
var sfx_gain_master = null
var bgm_gain_master = null
var music = null
var sounds = null

#func _init():
func _ready():
	game_init()
	
func game_init():
	# We can load with default values.
	# We also save immediately just to ensure the file is editable by devs on initial boot.
	##Config("load");
	##Config("save", "vsync", global.vsync);
	##Config("save", "alBhed", global.AlBhed);
	##Config("save", "FullScreen", global.fullscreen);
	##Config("save", "Scaling", global.screen_scale);
	##Config("save", "Filter", global.currentFilter);
	## Config("save", "ScanLines", global.scanlines);
	pass

func game_load():
	#ini_open(working_directory+"_resources\settings.ini");
	#ini_write_string("settings", "x", "xxx");
#
	#global.vsync = ini_read_real("settings","vsync", 1);
	#global.AlBhed = ini_read_real("settings", "alBhed", 0);
	#global.fullscreen = ini_read_real("settings", "FullScreen", 1);
	#global.screen_scale = ini_read_real("settings", "Scaling", 2);
	#global.currentFilter = ini_read_real("settings", "Filter", 2);
	#global.scanlines = global.currentFilter == 0;
#
	#global.sfx_gain_master = ini_read_real("settings", "SoundLevel", 1);
	#global.bgm_gain_master = ini_read_real("settings", "MusicLevel", 1);
	#global.music = global.bgm_gain_master;
	#global.sounds = global.sfx_gain_master;
#
	#if(global.fullscreen) global.screen_scale = 4;
#
	#ini_close();
	pass

func game_save(): # //key, value
	#ini_open(working_directory+"_resources\settings.ini");
#
	#if(is_string(argument[2])){
	#ini_write_string("settings", argument[1], argument[2]);
	#} else {
	#ini_write_real("settings", argument[1], argument[2]);
	#}
#
	#ini_close();
	#}
	pass
