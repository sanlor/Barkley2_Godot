extends Node

## This autoload replaces the script "Config".
## Its only use is to save and load settings, along with emiting signals to let the other nodes know (if needed).
## The settings.ini file that this game makes if cross compatible with the original. cool, aint it?

# check Settings() script.

## Configuration Consts
# Max distance you can be from someone to click them in PIXELS
var settingInteractiveDistance 			:= 64.0; ## For KEYBOARD ## Was 100
var settingInteractiveDistanceGamepad 	:= 48.0; ## For GAMEPAD ## Was 64

## Monitor
var main_display = 0

# Screen Layers
const ROOMXY_LAYER		:= 40 # Room Transitions
const SHADER_LAYER 		:= 30 # Shaders and Cursor
const MAP_LAYER			:= 29 # Maps screen
const NOTE_LAYER		:= 29 # Notes screen
const PAUSE_LAYER		:= 28 # Pause screen
const NOTICE_LAYER		:= 26 # "You got pistol"
const DIALOG_LAYER		:= 24 # Dialog Boxes
const EFFECTATMO_LAYER	:= 1001 # Rain and fog/smog
const HUD_LAYER			:= 20 # Inventory, etc
const GUI_LAYER			:= 20 # Inventory, etc
const DEBUG_LAYER		:= 41 # Debug Info

# Combat Settings
const COMBAT_TICKER_SPEED			:= 0.035	## Battle pacing, lower is faster. NOTE dont go too low.
const PLAYER_ACTION_MULTIPLIER 		:= 0.20		## Player speed multiplier (action recovery)
const WEAPON_ACTION_MULTIPLIER 		:= 0.20		## Player's weapon speed multiplier (action recovery)
const OVERHEAT_WEAPON_PENALTY 		:= 0.25		## Penalty applied to an oveheating weapon. Lower is slower (Duh)
const ENEMY_ACTION_MULTIPLIER 		:= 0.05		## Enemy speed multiplier (action recovery)

const PLAYER_BULLET_DAMAGE_MULTIPLIER	:= 5.0 ## Final multiplier for the player's bullets
const PLAYER_MELEE_DAMAGE_MULTIPLIER	:= 1.0 ## Final multiplier for the player's melee damage
const ENEMY_BULLET_DAMAGE_MULTIPLIER	:= 1.0 ## Final multiplier for the enemies's bullets
const ENEMY_MELEE_DAMAGE_MULTIPLIER		:= 1.0 ## Final multiplier for the enemies's melee damage

const BULLET_SPREAD_MULTIPLIER		:= 0.0125	## When firing an automatic weapon, apply an penalty to accuracy. lower is less accurate (i think).

# Dialog stuff
var dialogY := 140.0

# Used by the B2_RoomXY autoload
var settingFadeIn 		:= 0.50;
var settingFadeDelay 	:= 1.0; ## Time to wait between rooms, will scale based on room load time to make it consistent
var settingFadeOut 		:= 0.50;



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
var sfx_gain_master 	:= 1.0
var bgm_gain_master 	:= 1.0
var music 				= null
var sounds 				= null

signal game_settings_saved
signal game_settings_loaded

signal language_changed

signal title_screen_loaded ## NOTICE Signal important to reset some game variables.

var configsavefolder 	:= "user://_resources/"
var configsavefile 		:= "settings.ini"

## User Profile
var selected_slot 		:= 0
var usersavefile 		: Dictionary
var usersavefolder 		:= "user://"

## Main menu stuff
var tim_follow_mouse := false

## Dev stuff
var dev_notes := false

func _init():
	config_load()
	apply_config(false)
	
func _ready():
	pass

func _notification(what):
	## Save game during game exit.
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		if B2_Playerdata.record_curr_location():
			B2_Playerdata.SaveGame() ## Do the saving bit.

func get_current_save_slot() -> int:
	return selected_slot

func has_user_save( slot ): # slot -> 0 to 2
	assert( slot >= 0 or slot <= 2)
	var savefile := "save%s.b2" % str(slot)
	if FileAccess.file_exists(usersavefolder + savefile ):
		return true
	else:
		return false
	
func select_user_slot( slot ):
	assert( slot >= 0 or slot <= 2 or slot == 100 or slot == 69) ## slot 69 is used for VR missions. lol.
	# slot 100 is for debug purposes
	selected_slot = slot
	
	usersavefile.clear()
	B2_Gun.reset()
	B2_Playerdata.player_stats = B2_HoopzStats.new()
	
	var file := "save%s.b2" % str( slot )
	if FileAccess.file_exists( usersavefolder + file ):
		var savefile := FileAccess.open( usersavefolder + file, FileAccess.READ )
		var json := JSON.new()
		var parse_error := json.parse( savefile.get_as_text() )
		if parse_error == OK:
			usersavefile = json.get_data()
			savefile.close()
			
			B2_Gun.load_guns()
			B2_Playerdata.player_stats.load_stats()
		else:
			push_error( "cant load save file:", parse_error )

	
# scr_savedata_put()
func get_user_save_data( path : String, default = null ): ## return null if its invalid
				
	## This is a similar script to the scr_savedata_get
	var temp_dict := usersavefile
	var path_array := path.split(".")
	var loops := 0
	for i in path_array:
		if temp_dict.has(i):
			loops += 1
			if loops == path_array.size():
				return temp_dict[i]
				
			elif temp_dict[i] is not Dictionary:
				return temp_dict[i]
			else:
				temp_dict = temp_dict[i]
				#print(path + ": " + str(temp_dict))
		else:
			if B2_Debug.WARN_INVALID_CHECKS:
				push_warning( "Key ", i, " does not exist currently. Returning null" )
			return default
	
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
	assert( slot >= 0 or slot <= 2) ## Useless assert. Its funny, so im keeping it.
	var file := "save%s.b2" % str( slot )
	if FileAccess.file_exists( usersavefolder + file ):
		# Creating a save slot on a existing slot? this is wrong, the old one should be deleted first
		# breakpoint
		pass
		
	selected_slot = slot
	var savefile := FileAccess.open( usersavefolder + file, FileAccess.WRITE )
	#var json := JSON.new()
	savefile.store_string( JSON.stringify( usersavefile, "\t" ) )
	savefile.close()
	print_rich( "[color=blue]Game savedusing slot %s.[/color]" % slot )
	
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
		
	change_window_scale()
		
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

func change_window_scale() -> void:
	for i in DisplayServer.get_screen_count(): # debug
		print("Screen %s is %s." % [i, DisplayServer.screen_get_size(i)])
		
	if fullscreen == ON:
		DisplayServer.window_set_mode( DisplayServer.WINDOW_MODE_FULLSCREEN )
	else:
		var screen_pos		:= DisplayServer.screen_get_position( main_display )
		var screen_center 	:= DisplayServer.screen_get_size( main_display ) / 2
		var window_size		:= Vector2i(384, 240) * screen_scale
		
		DisplayServer.window_set_mode( DisplayServer.WINDOW_MODE_WINDOWED )
		
		if not Engine.is_embedded_in_editor(): ## Godot 4.4 quickfix.
			DisplayServer.window_set_size( window_size )
			DisplayServer.window_set_position( (screen_pos + screen_center) - window_size / 2, main_display )
	

func config_load():
	var config = ConfigFile.new()
	var error := config.load( configsavefolder + configsavefile )
	
	if error != OK:
		push_warning("No config file exist. Creating a new one.")
		config_save()
		return
		
	vsync 				= str_to_var( config.get_value("settings","vsync") 				)
	AlBhed 				= str_to_var( config.get_value("settings","alBhed") 			)
	fullscreen 			= str_to_var( config.get_value("settings","FullScreen") 		)
	screen_scale 		= str_to_var( config.get_value("settings","Scaling") 			)
	currentFilter 		= str_to_var( config.get_value("settings","Filter") 			)
	scanlines 			= str_to_var( config.get_value("settings","ScanLines") 			)
#	
	sfx_gain_master 	= str_to_var( config.get_value("settings","SoundLevel") 		)
	bgm_gain_master 	= str_to_var( config.get_value("settings","MusicLevel") 		)
	dev_notes			= str_to_var( config.get_value("settings","dev_notes", "false") 	) # "false" is needed to keep compatibility with older save files
	
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
	config.set_value("settings", "dev_notes", 		var_to_str(dev_notes) 				)
	
	if not DirAccess.dir_exists_absolute( configsavefolder ): ## make sure that the _resource folder exists.
		DirAccess.make_dir_absolute( configsavefolder )
	
	var err := config.save(configsavefolder + configsavefile)
	if err == OK:
		game_settings_saved.emit()
	else:
		push_error("Something went wrong with the settings saving routine: ", err)
