extends Control

## NOTE This room loads the oTitle object.
# This also forces the resolution to 384 x 240.
# This scene tries to recreate the room r_title, with the object oTitle.

## Godot Specific:

#region Images

@onready var bg = $bg
const O_TITLE_STARPASS = preload("res://barkley2/scenes/sTitle/oTitleStarpass.tscn")

#endregion

# region Panels

# Menu Panels
var title_box
var game_slot_1
var game_slot_2
var game_slot_3
var game_slot_4
var back_box
var obliterate_box
var settings_box
var settings_return_box
var settings_general_box
var settings_control_box
var settings_gamepad_box # formely "dicks"
var settings_get_key_box # for the key remap

var stock_x := Array() # for the stock ticker

#endregion

# region Color stuff

var text_color_normal := Color.GRAY # c_gray; // For text that cannot be interacted with
var text_color_button := Color.LIGHTGRAY # c_ltgray; // Text that can be clicked
var text_color_hover  := Color.WHITE # c_white;
var text_color_select := Color.ORANGE # c_orange;

var title_highlight_color := Color.ORANGE
var settings_highlight_color := Color.ORANGE
var gameslot_highlight_color := Color.ORANGE

var key_highlight_color := Color(240, 50, 255) # make_color_rgb(240, 50, 255);

#endregion

# menu state
var mode = "basic" :# "basic", "settings", "keymap", "gamepad", "gameslot","destruct_confirm", "gamestart_character" ## NOTE This reeeealy should be an enum.
	set(_mode):
		mode = _mode
		change_menu() #automatically update the menu

#endregion

#region Bunch of stupid variables related to the menus layout

## Basic title
	var title_x = 142
	var title_y = 170

	var title_row = 16
	var title_gap = 0

	# Draw buttons

	## Game slots
	var gameslot_width = 344 - 8;
	
	var gameslot_x = 30;
	var gameslot_y = 10; 
	
	var gameslot_row = 60 - 2;
	var gameslot_gap = 10;


	# Obliterate button
	var gameslot_destruct_x = 244;
	var gameslot_destruct_y = 214;

	# back button
	var gameslot_back_x = 40;
	var gameslot_back_y = 214;

	## Character Select ## "Create Character", "Play as X114JAM9", "Skip the Stupid Prologue", "Return"
	var character_x = 20;
	var character_y = 20;
	var character_row = 20;
	var character_gap = 5;

	## Draw Settings
	var settings_x = 40;
	var settings_y = 64 - 6;
	var settings_row = 16;
	var settings_gap = 0;
	var settings_width = (24 * 8);
	var settings_option_x = 143 - 32;
	
	var settings_tab_y = settings_y - 48;
	var settings_return_y = settings_y + settings_row * 9 + settings_gap * 9 + 0;

	# Draw General
	var slider_mx = 200; # Music
	var slider_sx = 200; # Sfx
	var slider_my = 40; # Music
	var slider_sy = 60; # Sfx

	# Draw Gamepad Menu

	# Draw Keymap
	var key_get = -1;
	var key_lag = 0;
	var key_x = 40;
	var key_y = 64 - 6; ## 24;
	var key_row = 16;
	var key_gap = 0;
	
	## Stock Ticker ## Maybe this isnt usedin the "final" game?
	stock_x[0] = 20;
	stock_x[1] = 100;
	stock_x[2] = 180;
	stock_x[3] = 260;
	stock_x[4] = 340;
	stock_x[5] = 420;
	stock_x[6] = 500;
	stock_y = 225;

	## Other garbage ##
	var confirm_x = 132;
	var confirm_y = 150;
	var confirm_width = 50;
	var confirm_gap = 20;

#endregion

var tim := 0.0 ## important variable. controles how much ot the ziggurat is near hell. range from 0 to 1

func _ready():
	for n in bg.get_children():
		if n is AnimatedSprite2D:
			n.play("default")
	
	## Debug
	var w_scale := 2
	get_window().position /= w_scale
	get_window().size *= w_scale
	
	for i in 40:
		var star = O_TITLE_STARPASS.instantiate()
		star.position = Vector2( randf_range(0, get_viewport_rect().end.x), randf_range(0, get_viewport_rect().end.y) )
		star.name = "star" + str(i)
		add_child(star)

	## Create Panels / Borders
	# Border("generate", 0, 100 + 16, 60 + 16 - 1); // Title Box
	title_box = Border.generate(100 + 16, 60 + 16 - 1)

	# for (i = 1; i &lt; 4; i += 1) Border("generate", i, 344, 66); // Game Slot
	game_slot_1 = Border.generate( 344, 66 )
	game_slot_2 = Border.generate( 344, 66 )
	game_slot_3 = Border.generate( 344, 66 )
	game_slot_4 = Border.generate( 344, 66 )
	
	# Border("generate", 4, 100, 32); // Back
	back_box = Border.generate(100, 32)

	# Border("generate", 5, 100, 32); // Obliterate
	obliterate_box = Border.generate(100, 32)

	# Border("generate", 6, 320 + 8, 176 - 22); // Settings
	settings_box = Border.generate(320 + 8, 176 - 22)

	# Border("generate", 7, 320 + 8, 32); // Settings - Return
	settings_return_box = Border.generate(320 + 8, 32)

	# for (i = 8; i &lt; 11; i += 1) Border("generate", i, 106, 32); // 8, 9, 10 = General, Controls, Dicks
	settings_general_box = Border.generate(106, 32)
	settings_control_box = Border.generate(106, 32)
	settings_gamepad_box = Border.generate(106, 32)

	# Border("generate", 11, 256, 64); // Get key
	settings_get_key_box = Border.generate(256, 64)

	init_menus()
	change_menu()

func init_menus(): ## THis is just to alling with the old code. There are better ways to do this.
	pass

func change_menu():
	pass

func _input(event):
	if event is InputEventMouseMotion:
		pass

func _process(delta):
	#for n in bg.get_children():
		#if n.has_method("move_left"):
			#n.move_left( 80 * delta )
	pass
