extends Control

## NOTE This room loads the oTitle object.
# This also forces the resolution to 384 x 240.
# This scene tries to recreate the room r_title, with the object oTitle.

@export var debug_data := false

## Godot Specific:

signal mode_change(String)

#region Images

@onready var bg = $bg
const O_TITLE_STARPASS = preload("res://barkley2/scenes/sTitle/oTitleStarpass.tscn")

@onready var s_barkley_2_logo = $s_barkley2_logo
@onready var s_janky_demo_01 = $s_jankyDemo01

# Animated
@onready var s_title_starfield_bright = $bg/sTitleStarfieldBright
@onready var s_title_nebula_red_smoke = $bg/sTitleNebulaRedSmoke
@onready var s_title_nebula_red_faces = $bg/sTitleNebulaRedFaces
@onready var s_title_hell_mouth = $bg/sTitleHellMouth
@onready var s_title_ziggurat = $bg/sTitleZiggurat

# Static
@onready var s_title_starfield_dim = $bg/sTitleStarfieldDim
@onready var s_title_nebula_blue_mid = $bg/sTitleNebulaBlueMid
@onready var s_title_nebula_blue = $bg/sTitleNebulaBlue
@onready var s_title_nebula_blue_bottom = $bg/sTitleNebulaBlueBottom
@onready var s_title_nebula_red = $bg/sTitleNebulaRed
@onready var s_title_nebula_red_hell = $bg/sTitleNebulaRedHell

#endregion

# region Panels

## Title panel
@onready var title_layer = $CanvasLayer
@onready var settings_layer = $settings_layer

@onready var title_panel = $CanvasLayer/title_panel

## Inside the Title panel
@onready var start_button = $CanvasLayer/title_panel/start_button
@onready var settings_button = $CanvasLayer/title_panel/settings_button
@onready var quit_button = $CanvasLayer/title_panel/quit_button

@onready var title_buttons := [
	start_button,
	settings_button,
	quit_button
]
## Settings panel
@onready var settings_panel = $settings_layer/settings_panel
@onready var settings_general_panel = $settings_layer/general_panel
@onready var settings_keys_panel = $settings_layer/keys_panel
@onready var settings_gamepad_panel = $settings_layer/gamepad_panel
@onready var settings_return_panel = $settings_layer/return_panel

## Inside the Settings panel
@onready var general_options = $settings_layer/settings_panel/general
@onready var keys_options = $settings_layer/settings_panel/keys
@onready var gamepad_options = $settings_layer/settings_panel/gamepad


@onready var gameslot_panel = null
@onready var characters_panel = null

@onready var settings_panels := [
	settings_general_panel,
	settings_keys_panel,
	settings_gamepad_panel,
]

@onready var settings_general_button = $settings_layer/general_panel/settings_general_button
@onready var settings_keys_button = $settings_layer/keys_panel/settings_keys_button
@onready var settings_gamepad_button = $settings_layer/gamepad_panel/settings_gamepad_button

@onready var settings_buttons := [
	settings_general_button,
	settings_keys_button,
	settings_gamepad_button
]
@onready var settings_return_button = $settings_layer/return_panel/settings_return_button

var stock_x := Array() # for the stock ticker

## Character Slots
@onready var gameslot_layer = $gameslot_layer

#endregion

# region Color stuff

var text_color_normal := Color.GRAY # c_gray; // For text that cannot be interacted with
var text_color_button := Color.LIGHT_GRAY # c_ltgray; // Text that can be clicked
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
		mode_change.emit()

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
@warning_ignore("integer_division")
var key_x = 40 / 4 					## / 4 added by me
@warning_ignore("integer_division")
var key_y = (64 - 6) / 4; ## 24; 	## / 4 added by me
var key_row = 16;
var key_gap = 0;

## Stock Ticker ## Maybe this isnt usedin the "final" game?
#stock_x[0] = 20;
#stock_x[1] = 100;
#stock_x[2] = 180;
#stock_x[3] = 260;
#stock_x[4] = 340;
#stock_x[5] = 420;
#stock_x[6] = 500;
#stock_y = 225;

## Other garbage ##
var confirm_x = 132;
var confirm_y = 150;
var confirm_width = 50;
var confirm_gap = 20;

var drx
var dry

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
	
	## Music
	B2_Music.room_get( "r_title" )
	mode = "basic" ## default state of the game.
	
	for i in 40:
		var star = O_TITLE_STARPASS.instantiate()
		star.position = Vector2( randf_range(0, get_viewport_rect().end.x), randf_range(0, get_viewport_rect().end.y) )
		star.name = "star" + str(i)
		add_child(star)
	
	#region Menu Layout stuff. Not necessary, but I really want to make a 1:1 recreation.
	
	## Decorations
	# Barkley logo
	#draw_sprite(s_jankyDemo01, 0, SCREEN_WIDTH/1.5, SCREEN_HEIGHT/2 - 20);
	s_janky_demo_01.global_position = Vector2(get_viewport_rect().end.x / 1.5, get_viewport_rect().end.y /2 - 20) - (s_janky_demo_01.size / 2)
	
	
	## Create Panels / Borders
	# Border("generate", 0, 100 + 16, 60 + 16 - 1); // Title Box
	title_panel.set_panel_size( 100 + 16, 60 + 16 - 1 )
	title_panel.global_position = Vector2( title_x - 8, title_y - 15 )
	for i in range( title_buttons.size() ): # Set the button positions
		title_buttons[i].size = Vector2(100, title_row + 1)
		title_buttons[i].global_position = Vector2(title_x + 50, title_y + (title_row * i) + (title_gap * i) + 4) - ( title_buttons[i].size / 2 )

	# for (i = 1; i &lt; 4; i += 1) Border("generate", i, 344, 66); // Game Slot
	
	# Border("generate", 4, 100, 32); // Back

	# Border("generate", 5, 100, 32); // Obliterate

	# Border("generate", 6, 320 + 8, 176 - 22); // Settings
	settings_panel.set_panel_size(320 + 8, 176 - 22) ## Settings
	var xsp = 11; ## Space for Music, Sound, Language, etc text ## NOTE No Idea what this is.
	#Border("draw back", 6, settings_x - 8, settings_y - 8 - 2 - 5);
	settings_panel.global_position = Vector2(settings_x - 8, settings_y - 8 - 2 - 5) # - (settings_panel.size / 2) ## NOTE WTF! some stuff assume a center origin position and other the top left.
	for i in range(settings_panels.size()):
		# for (i = 8; i &lt; 11; i += 1) Border("generate", i, 106, 32); // 8, 9, 10 = General, Controls, Dicks
		settings_panels[i].set_panel_size(106, 32)
		# Border("draw back", 8 + i, drx, dry);
		drx = settings_x - 8 + (i * 111);
		dry = settings_tab_y;
		settings_panels[i].global_position = Vector2(drx, dry)
		#draw_sprite_ext(s1x1, 0, drx, dry + 4, 102, 24, 0, c_white, 0.25);
		#draw_sprite_ext(s1x1, 0, drx, dry + 4, 102, 24, 0, c_orange, 0.25);
		settings_buttons[i].set_size( Vector2(102, 24) )
		settings_buttons[i].global_position = Vector2(drx, dry + 4,)# - (settings_buttons[i].size / 2)
		pass ## NOTE Incomplete
		
	# Border("generate", 7, 320 + 8, 32); // Settings - Return
	settings_return_panel.set_panel_size(320 + 8, 32) ## Return Panel and button
	# drx = settings_x - 8; #dry = settings_return_y; #Border("draw back", 7, drx, dry);
	settings_return_panel.global_position = Vector2(settings_x - 8, settings_return_y)
	# draw_sprite_ext(s1x1, 0, drx, dry + 4, 320, 24, 0, c_white, 0.25);
	settings_return_button.set_size( Vector2(320, 24) )
	settings_return_button.global_position = Vector2(settings_x - 8, settings_return_y + 4)
	
	var settings_name_0 = $settings_layer/settings_panel/general/settings_name_0
	var settings_name_1 = $settings_layer/settings_panel/general/settings_name_1
	var settings_name_3 = $settings_layer/settings_panel/general/settings_name_3
	var settings_name_4 = $settings_layer/settings_panel/general/settings_name_4
	var settings_name_5 = $settings_layer/settings_panel/general/settings_name_5
	var settings_name_6 = $settings_layer/settings_panel/general/settings_name_6
	var settings_name_7 = $settings_layer/settings_panel/general/settings_name_7
	var set_names := general_options.get_children() # should be 7 labels

	dry = settings_y + settings_row * 0 + settings_gap * 0;
	
	## Set settings labels
	for l in 7:
		if l == 2:
			## Add a blank space
			dry += 16
		drx = settings_x + settings_option_x + 16;
		set_names[l].global_position = Vector2(settings_x + xsp, dry + 4)
		set_names[l].size = Vector2(drx + (10 * 8), dry + 4)
		dry += 16
		
	# music, sound, 
	
	## Set the options buttons. THIS IS A MESS
	var volume_keys := [$settings_layer/settings_panel/general/settings_name_0/minus, $settings_layer/settings_panel/general/settings_name_0/plus, $settings_layer/settings_panel/general/settings_name_1/minus, $settings_layer/settings_panel/general/settings_name_1/plus]
	dry = settings_y + settings_row * 0 + settings_gap * 0;
	drx = settings_x + settings_option_x;
	for v in 4: ## Slider buttons (four of them)
		volume_keys[v].global_position = Vector2(drx, dry)
		volume_keys[v].size = Vector2(16,16) #
		drx += 22 * 8;
		if v == 1:
			drx = settings_x + settings_option_x;
			dry += 16
	## Music / Sound Sliders
	var set_buttons := [$settings_layer/settings_panel/general/settings_name_0/music_slider, $settings_layer/settings_panel/general/settings_name_1/sound_slider, $settings_layer/settings_panel/general/settings_name_3/crt_button, $settings_layer/settings_panel/general/settings_name_3/bloom_button, $settings_layer/settings_panel/general/settings_name_3/none_button, $settings_layer/settings_panel/general/settings_name_4/joke_on_button, $settings_layer/settings_panel/general/settings_name_4/joke_off_button, $settings_layer/settings_panel/general/settings_name_5/english_button, $settings_layer/settings_panel/general/settings_name_5/albhed_button, $settings_layer/settings_panel/general/settings_name_6/fullscreen_button, $settings_layer/settings_panel/general/settings_name_6/window_button, $"settings_layer/settings_panel/general/settings_name_7/2x_button", $"settings_layer/settings_panel/general/settings_name_7/3x_button", $"settings_layer/settings_panel/general/settings_name_7/4x_button"]
	set_buttons[0].global_position = Vector2(settings_x + settings_option_x + 16, settings_y + settings_row * 0 + settings_gap * 0)
	set_buttons[0].size = Vector2(8 * 20 + 1, 17)
	set_buttons[1].global_position = Vector2(settings_x + settings_option_x + 16, settings_y + settings_row * 0 + settings_gap * 0 + 16)
	set_buttons[1].size = Vector2(8 * 20 + 1, 17)
	
	## Filter
	dry = settings_y + settings_row * 3 + settings_gap * 3;
	drx = settings_x + settings_option_x;
	@warning_ignore("integer_division")
	var spc = settings_width / 3
	
	set_buttons[2].global_position = Vector2(drx, dry)
	set_buttons[2].size = Vector2(spc - 1, 15)
	drx += spc
	set_buttons[3].global_position = Vector2(drx, dry)
	set_buttons[3].size = Vector2(spc - 1, 15)
	drx += spc
	set_buttons[4].global_position = Vector2(drx, dry)
	set_buttons[4].size = Vector2(spc - 1, 15)
	drx += spc
	dry += 16
	
	## Jokes
	drx = settings_x + settings_option_x;
	@warning_ignore("integer_division")
	spc = settings_width / 2
	set_buttons[5].global_position = Vector2(drx, dry)
	set_buttons[5].size = Vector2(spc - 1, 15)
	drx += spc
	set_buttons[6].global_position = Vector2(drx, dry)
	set_buttons[6].size = Vector2(spc - 1, 15)
	drx += spc
	dry += 16
	
	## Language
	drx = settings_x + settings_option_x;
	@warning_ignore("integer_division")
	spc = settings_width / 2
	set_buttons[7].global_position = Vector2(drx, dry)
	set_buttons[7].size = Vector2(spc - 1, 15)
	drx += spc
	set_buttons[8].global_position = Vector2(drx, dry)
	set_buttons[8].size = Vector2(spc - 1, 15)
	drx += spc
	dry += 16
	
	## Full Screen
	drx = settings_x + settings_option_x;
	@warning_ignore("integer_division")
	spc = settings_width / 2
	set_buttons[9].global_position = Vector2(drx, dry)
	set_buttons[9].size = Vector2(spc - 1, 15)
	drx += spc
	set_buttons[10].global_position = Vector2(drx, dry)
	set_buttons[10].size = Vector2(spc - 1, 15)
	drx += spc
	dry += 16
	
	## Scaling
	drx = settings_x + settings_option_x;
	@warning_ignore("integer_division")
	spc = settings_width / 3
	set_buttons[11].global_position = Vector2(drx, dry)
	set_buttons[11].size = Vector2(spc - 1, 15)
	drx += spc
	set_buttons[12].global_position = Vector2(drx, dry)
	set_buttons[12].size = Vector2(spc - 1, 15)
	drx += spc
	set_buttons[13].global_position = Vector2(drx, dry)
	set_buttons[13].size = Vector2(spc - 1, 15)
	drx += spc
	dry += 16
	
	#breakpoint
	# Border("generate", 11, 256, 64); // Get key ## TODO # Still inside the settings menu
	
	#endregion
	#  initial pos
	xsp = 11; ## Space for Music, Sound, Language, etc text
	#draw_sprite_ext(s1x1, 0, drx + 76, dry, 65, 17, 0, c_white, 0.25);
	
	#region key settings menu
	
	var dirty_inputs := InputMap.get_actions() ## has a lot of internal keymappings
	var clean_inputs := Array()
	for i in dirty_inputs:
		if not i.begins_with(&"ui_"):
			clean_inputs.append(i)
		
	# Action name
	for l in 16:
		@warning_ignore("integer_division")
		drx = key_x + xsp + ( (l / 8) * 144 )
		var h = l % 8;
		dry = key_y + key_row * h + key_gap * h; ## + 4;
		
		var label := Label.new()
		label.text = clean_inputs[l]
		label.name = clean_inputs[l] + "_label"
		label.set_deferred("size", Vector2(70, 15) ) # size is weird. THis only is set on the next frame or something.
		label.global_position = Vector2(drx, dry + 4)
		#label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		
		keys_options.add_child(label)
		
		var button := RemapButton.new()
		button.set_size( Vector2(65, 15) )
		#button.set_size( Vector2(drx + 76 + 64, dry + 15) )
		button.global_position = Vector2(drx + 75, dry + 4) ## drx + 80
		#button.text = InputMap.action_get_events( clean_inputs[l] ).front().as_text()
		button.action = clean_inputs[l] #InputMap.action_get_events( clean_inputs[l] ).front().as_text()
		button.name = clean_inputs[l] + "_button"
		button.alignment = HORIZONTAL_ALIGNMENT_LEFT
		if clean_inputs[l] == "Pause": button.disabled = true
		keys_options.add_child(button)

	#endregion
	
	
func init_menus(): ## This is just to alling with the old code. There are better ways to do this.
	## Settings
	pass
	
	
func change_menu(): # "basic", "settings", "keymap", "gamepad", "gameslot","destruct_confirm", "gamestart_character"
	match mode:
		"basic":
			title_layer.show()
			settings_layer.hide()
			gameslot_layer.hide()
		"settings", "keymap", "gamepad":
			title_layer.hide()
			settings_layer.show()
			gameslot_layer.hide()
		"gameslot", "destruct_confirm":
			title_layer.hide()
			settings_layer.hide()
			gameslot_layer.show()
		_: ## Catch all
			push_error("Unknown mode called: ", mode)
			
func _input(event):
	if event is InputEventMouseMotion:
		pass

func _draw():
	var qrx = 150;
	var qry = 100 + 15# + 5 ; # + 5 was added by me.
	var font := preload("res://barkley2/resources/fonts/fn_small.tres")
	#draw_text(qrx, qry, "DEMO game for backers.");
	draw_string( font, Vector2(qrx,qry), "DEMO game for backers.",HORIZONTAL_ALIGNMENT_LEFT,-1,12,Color.YELLOW)
	qry += 14; 
	#draw_text(qrx, qry, "Substantial levels of WONK and JANK.");
	draw_string( font, Vector2(qrx,qry), "Substantial levels of WONK and JANK.",HORIZONTAL_ALIGNMENT_LEFT,-1,12,Color.YELLOW)
	qry += 14; 
	#draw_text(qrx, qry, "Experience accordingly.");
	draw_string( font, Vector2(qrx,qry), "Experience accordingly.",HORIZONTAL_ALIGNMENT_LEFT,-1,12,Color.YELLOW)
	
