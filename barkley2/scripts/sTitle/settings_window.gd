extends CanvasLayer

@onready var r_title = get_parent()

@onready var general = $settings_panel/general
@onready var keys = $settings_panel/keys
@onready var gamepad = $settings_panel/gamepad

@onready var music_slider = $settings_panel/general/settings_name_0/music_slider
@onready var sound_slider = $settings_panel/general/settings_name_1/sound_slider

## Settings panel
@onready var settings_panel = $settings_panel

@onready var settings_general_panel = $general_panel
@onready var settings_keys_panel = $keys_panel
@onready var settings_gamepad_panel = $gamepad_panel

@onready var settings_return_panel = $return_panel

## Inside the Settings panel
@onready var general_options = $settings_panel/general
@onready var keys_options = $settings_panel/keys
@onready var gamepad_options = $settings_panel/gamepad

@onready var settings_panels := [
	settings_general_panel,
	settings_keys_panel,
	settings_gamepad_panel,
]

@onready var settings_general_button = $general_panel
@onready var settings_keys_button = $keys_panel
@onready var settings_gamepad_button = $gamepad_panel

@onready var settings_buttons := [
	settings_general_button,
	settings_keys_button,
	settings_gamepad_button
]
@onready var settings_return_button = $return_panel/settings_return_button


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


func _ready():
	music_slider.value = B2_Music.get_volume()
	
	## Default state
	general.show()
	keys.hide()
	gamepad.hide()
	
	## Layout stuff
	var drx
	var dry
	
	#region general settings menu
	# Border("generate", 6, 320 + 8, 176 - 22); // Settings
	settings_panel.set_panel_size(320 + 8, 176 - 22) ## Settings
	var xsp = 11; ## Space for Music, Sound, Language, etc text ## NOTE No Idea what this is.
	#Border("draw back", 6, settings_x - 8, settings_y - 8 - 2 - 5);
	settings_panel.global_position = Vector2(settings_x - 8, settings_y - 8 - 2 - 5) # - (settings_panel.size / 2) ## NOTE WTF! some stuff assume a center origin position and other the top left.
	var settings_tab_names := ["General","Controls","Gamepad"]
	for i in range(settings_panels.size()):
		# for (i = 8; i &lt; 11; i += 1) Border("generate", i, 106, 32); // 8, 9, 10 = General, Controls, Dicks
		settings_panels[i].set_panel_size(106, 32)
		# Border("draw back", 8 + i, drx, dry);
		drx = settings_x - 8 + (i * 111);
		dry = settings_tab_y;
		settings_panels[i].global_position = Vector2(drx, dry)
		#draw_sprite_ext(s1x1, 0, drx, dry + 4, 102, 24, 0, c_white, 0.25);
		#draw_sprite_ext(s1x1, 0, drx, dry + 4, 102, 24, 0, c_orange, 0.25);
		settings_buttons[i].monitor_mouse = true
		#settings_buttons[i].set_size( Vector2(102, 24) )
		#settings_buttons[i].global_position = Vector2(drx, dry + 4,)# - (settings_buttons[i].size / 2)
		
		var label := Label.new()
		label.text = settings_tab_names[i]
		label.size = settings_buttons[i].get_panel_size()
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		settings_buttons[i].add_decorations(label)
		
		pass ## NOTE Incomplete
		
	# Border("generate", 7, 320 + 8, 32); // Settings - Return
	settings_return_panel.set_panel_size(320 + 8, 32) ## Return Panel and button
	# drx = settings_x - 8; #dry = settings_return_y; #Border("draw back", 7, drx, dry);
	settings_return_panel.global_position = Vector2(settings_x - 8, settings_return_y)
	# draw_sprite_ext(s1x1, 0, drx, dry + 4, 320, 24, 0, c_white, 0.25);
	settings_return_button.set_size( Vector2(320, 24) )
	settings_return_button.global_position = Vector2(settings_x - 8, settings_return_y + 4)
	
	var settings_name_0 = $settings_panel/general/settings_name_0
	var settings_name_1 = $settings_panel/general/settings_name_1
	var settings_name_3 = $settings_panel/general/settings_name_3
	var settings_name_4 = $settings_panel/general/settings_name_4
	var settings_name_5 = $settings_panel/general/settings_name_5
	var settings_name_6 = $settings_panel/general/settings_name_6
	var settings_name_7 = $settings_panel/general/settings_name_7
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
	var volume_keys := [$settings_panel/general/settings_name_0/minus, $settings_panel/general/settings_name_0/plus, $settings_panel/general/settings_name_1/minus, $settings_panel/general/settings_name_1/plus]
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
	var set_buttons := [$settings_panel/general/settings_name_0/music_slider, $settings_panel/general/settings_name_1/sound_slider, $settings_panel/general/settings_name_3/crt_button, $settings_panel/general/settings_name_3/bloom_button, $settings_panel/general/settings_name_3/none_button, $settings_panel/general/settings_name_4/joke_on_button, $settings_panel/general/settings_name_4/joke_off_button, $settings_panel/general/settings_name_5/english_button, $settings_panel/general/settings_name_5/albhed_button, $settings_panel/general/settings_name_6/fullscreen_button, $settings_panel/general/settings_name_6/window_button, $"settings_panel/general/settings_name_7/2x_button", $"settings_panel/general/settings_name_7/3x_button", $"settings_panel/general/settings_name_7/4x_button"]
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
	
	xsp = 11; ## Space for Music, Sound, Language, etc text
#endregion

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
	
	#region gamepad settings menu
	const S_XBOX_BUTTONS_A = preload("res://barkley2/assets/sTitle/gamepad/sXBOXButtons_0.png")
	const S_XBOX_BUTTONS_B = preload("res://barkley2/assets/sTitle/gamepad/sXBOXButtons_1.png")
	const S_XBOX_BUTTONS_X = preload("res://barkley2/assets/sTitle/gamepad/sXBOXButtons_2.png")
	const S_XBOX_BUTTONS_Y = preload("res://barkley2/assets/sTitle/gamepad/sXBOXButtons_3.png")
	const S_XBOX_BUTTONS_LB = preload("res://barkley2/assets/sTitle/gamepad/sXBOXButtons_4.png")
	const S_XBOX_BUTTONS_RB = preload("res://barkley2/assets/sTitle/gamepad/sXBOXButtons_5.png")
	const S_XBOX_BUTTONS_LT = preload("res://barkley2/assets/sTitle/gamepad/sXBOXButtons_6.png")
	const S_XBOX_BUTTONS_RT = preload("res://barkley2/assets/sTitle/gamepad/sXBOXButtons_7.png")
	const S_XBOX_BUTTONS_SEL = preload("res://barkley2/assets/sTitle/gamepad/sXBOXButtons_8.png")
	const S_XBOX_BUTTONS_STA = preload("res://barkley2/assets/sTitle/gamepad/sXBOXButtons_9.png")
	const S_XBOX_BUTTONS_RA = preload("res://barkley2/assets/sTitle/gamepad/sXBOXButtons_10.png")
	const S_XBOX_BUTTONS_LA = preload("res://barkley2/assets/sTitle/gamepad/sXBOXButtons_11.png")
	const S_XBOX_BUTTONS_UP = preload("res://barkley2/assets/sTitle/gamepad/sXBOXButtons_12.png")
	const S_XBOX_BUTTONS_RG = preload("res://barkley2/assets/sTitle/gamepad/sXBOXButtons_13.png")
	const S_XBOX_BUTTONS_DW = preload("res://barkley2/assets/sTitle/gamepad/sXBOXButtons_14.png")
	const S_XBOX_BUTTONS_LF = preload("res://barkley2/assets/sTitle/gamepad/sXBOXButtons_15.png")
	
	drx = key_x + 11 - 3; # + 5;
	dry = key_y + 4;
	
	var gamepad_buttons := []
	var gamepad_labels := []
	
	for tex in 14:
		gamepad_buttons.append( TextureRect.new() )
	for lb in 14:
		var l = Label.new()
		l.self_modulate = Color.DARK_GRAY
		gamepad_labels.append( l )
		
	gamepad_buttons[0].texture = S_XBOX_BUTTONS_LA
	gamepad_buttons[0].global_position = Vector2(drx,dry)
	gamepad_options.add_child( gamepad_buttons[0] )
	gamepad_labels[0].text = "Movement"
	gamepad_labels[0].global_position = Vector2( drx + (8 * 6) - 5, dry )
	gamepad_options.add_child( gamepad_labels[0] )
	dry += key_row * 1.5;
	
	gamepad_buttons[1].texture = S_XBOX_BUTTONS_RA
	gamepad_buttons[1].global_position = Vector2(drx,dry)
	gamepad_options.add_child( gamepad_buttons[1] )
	gamepad_labels[1].text = "Aiming"
	gamepad_labels[1].global_position = Vector2( drx + (8 * 6) - 5, dry )
	gamepad_options.add_child( gamepad_labels[1] )
	dry += key_row * 1.5;
	
	gamepad_buttons[2].texture = S_XBOX_BUTTONS_RB
	gamepad_buttons[2].global_position = Vector2(drx,dry)
	gamepad_options.add_child( gamepad_buttons[2] )
	gamepad_labels[2].text = "Action"
	gamepad_labels[2].global_position = Vector2( drx + (8 * 6) - 5, dry )
	gamepad_options.add_child( gamepad_labels[2] )
	dry += key_row;
	
	gamepad_buttons[3].texture = S_XBOX_BUTTONS_B
	gamepad_buttons[3].global_position = Vector2(drx,dry)
	gamepad_options.add_child( gamepad_buttons[3] )
	gamepad_labels[3].text = "Holster"
	gamepad_labels[3].global_position = Vector2( drx + (8 * 6) - 5, dry )
	gamepad_options.add_child( gamepad_labels[3] )
	dry += key_row;
	
	gamepad_buttons[4].texture = S_XBOX_BUTTONS_LB
	gamepad_buttons[4].global_position = Vector2(drx,dry)
	gamepad_options.add_child( gamepad_buttons[4] )
	gamepad_labels[4].text = "Roll"
	gamepad_labels[4].global_position = Vector2( drx + (8 * 6) - 5, dry )
	gamepad_options.add_child( gamepad_labels[4] )
	dry += key_row;
	
	gamepad_buttons[5].texture = S_XBOX_BUTTONS_Y
	gamepad_buttons[5].global_position = Vector2(drx,dry)
	gamepad_options.add_child( gamepad_buttons[5] )
	gamepad_labels[5].text = "Quickmenu"
	gamepad_labels[5].global_position = Vector2( drx + (8 * 6) - 5, dry )
	gamepad_options.add_child( gamepad_labels[5] )
	dry += key_row;
	
	gamepad_buttons[6].texture = S_XBOX_BUTTONS_LF
	gamepad_buttons[6].global_position = Vector2(drx,dry)
	gamepad_options.add_child( gamepad_buttons[6] )
	gamepad_labels[6].text = "Weapon >"
	gamepad_labels[6].global_position = Vector2( drx + (8 * 6) - 5, dry )
	gamepad_options.add_child( gamepad_labels[6] )
	dry += key_row;
	
	drx = key_x + 11 - 3 + 144;
	dry = key_y + 4;
	
	gamepad_buttons[7].texture = S_XBOX_BUTTONS_UP
	gamepad_buttons[7].global_position = Vector2(drx,dry)
	gamepad_options.add_child( gamepad_buttons[7] )
	gamepad_labels[7].text = "Gun'sbag"
	gamepad_labels[7].global_position = Vector2( drx + (8 * 6) - 5, dry )
	gamepad_options.add_child( gamepad_labels[7] )
	dry += key_row;
	
	gamepad_buttons[8].texture = S_XBOX_BUTTONS_DW
	gamepad_buttons[8].global_position = Vector2(drx,dry)
	gamepad_options.add_child( gamepad_buttons[8] )
	gamepad_labels[8].text = "Item Next"
	gamepad_labels[8].global_position = Vector2( drx + (8 * 6) - 5, dry )
	gamepad_options.add_child( gamepad_labels[8] )
	dry += key_row;
	
	gamepad_buttons[9].texture = S_XBOX_BUTTONS_X
	gamepad_buttons[9].global_position = Vector2(drx,dry)
	gamepad_options.add_child( gamepad_buttons[9] )
	gamepad_labels[9].text = "Item Use"
	gamepad_labels[9].global_position = Vector2( drx + (8 * 6) - 5, dry )
	gamepad_options.add_child( gamepad_labels[9] )
	dry += key_row;
	
	gamepad_buttons[10].texture = S_XBOX_BUTTONS_RG
	gamepad_buttons[10].global_position = Vector2(drx,dry)
	gamepad_options.add_child( gamepad_buttons[10] )
	gamepad_labels[10].text = "Zauber Next"
	gamepad_labels[10].global_position = Vector2( drx + (8 * 6) - 5, dry )
	gamepad_options.add_child( gamepad_labels[10] )
	dry += key_row;
	
	gamepad_buttons[11].texture = S_XBOX_BUTTONS_RT
	gamepad_buttons[11].global_position = Vector2(drx,dry)
	gamepad_options.add_child( gamepad_buttons[11] )
	gamepad_labels[11].text = "Zauber Use"
	gamepad_labels[11].global_position = Vector2( drx + (8 * 6) - 5, dry )
	gamepad_options.add_child( gamepad_labels[11] )
	dry += key_row * 1.5;
	
	gamepad_buttons[12].texture = S_XBOX_BUTTONS_LT
	gamepad_buttons[12].global_position = Vector2(drx,dry)
	gamepad_options.add_child( gamepad_buttons[12] )
	gamepad_labels[12].text = "Free Look"
	gamepad_labels[12].global_position = Vector2( drx + (8 * 6) - 5, dry )
	gamepad_options.add_child( gamepad_labels[12] )
	dry += key_row * 1.5;
	
	gamepad_buttons[13].texture = S_XBOX_BUTTONS_STA
	gamepad_buttons[13].global_position = Vector2(drx,dry)
	gamepad_options.add_child( gamepad_buttons[13] )
	gamepad_labels[13].text = "Pause"
	gamepad_labels[13].global_position = Vector2( drx + (8 * 6) - 5, dry )
	gamepad_options.add_child( gamepad_labels[13] )
	dry += key_row;
	#endregion

func _on_music_slider_value_changed(value):
	B2_Music.set_volume( value )

func _on_music_minus_pressed():
	music_slider.value -= 5.0

func _on_music_plus_pressed():
	music_slider.value += 5.0

func toggle_buttons():
	match r_title.mode:
		"settings":
			#settings_general_button.is_pressed 	= true
			settings_keys_button.is_pressed 		= false
			settings_gamepad_button.is_pressed 		= false
		"keymap":
			settings_general_button.is_pressed 		= false
		#	settings_keys_button.is_pressed 		= true
			settings_gamepad_button.is_pressed 		= false
		"gamepad":
			settings_general_button.is_pressed 		= false
			settings_keys_button.is_pressed 		= false
			#settings_gamepad_button.is_pressed 	= true
		_:
			#settings_general_button.is_pressed 	= true
			settings_keys_button.is_pressed 		= false
			settings_gamepad_button.is_pressed 		= false

# "basic", "settings", "keymap", "gamepad", "gameslot","destruct_confirm", "gamestart_character" ## NOTE This reeeealy should be an enum.
func _on_settings_general_button_pressed():
	r_title.mode = "settings"
	general.show()
	keys.hide()
	gamepad.hide()
	toggle_buttons()

func _on_settings_keys_button_pressed():
	r_title.mode = "keymap"
	general.hide()
	keys.show()
	gamepad.hide()
	toggle_buttons()
	
func _on_settings_gamepad_button_pressed():
	r_title.mode = "gamepad"
	general.hide()
	keys.hide()
	gamepad.show()
	toggle_buttons()
	
func _on_settings_return_button_pressed():
	r_title.mode = "basic"
	toggle_buttons()
	hide()
