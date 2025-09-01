extends Control

## NOTE This room loads the oTitle object.
# This also forces the resolution to 384 x 240.
# This scene tries to recreate the room r_title, with the object oTitle.

@export var debug_data 			:= false
@export var show_demo_msg 		:= true
@export var show_janky_logo		:= true
@export var show_stock_ticker 	:= false
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
@onready var title_layer: CanvasLayer 		= $title_layer
@onready var settings_layer: CanvasLayer 	= $settings_layer
@onready var character_layer: CanvasLayer 	= $character_layer
@onready var vr_layer: CanvasLayer 			= $vr_layer

@onready var title_panel = $title_layer/title_panel

## Inside the Title panel
@onready var start_button 		= $title_layer/title_panel/start_button
@onready var settings_button 	= $title_layer/title_panel/settings_button
@onready var quit_button 		= $title_layer/title_panel/quit_button
@onready var vr_button: 		B2_Border_Button 	= $title_layer/vr_btn
@onready var debug_button: 		B2_Border_Button 	= $title_layer/debug_btn

## VR Stuff
@onready var mission_1: 	Button = $vr_layer/mission_list/MarginContainer/ScrollContainer/VBoxContainer/mission_1
@onready var mission_2: 	Button = $vr_layer/mission_list/MarginContainer/ScrollContainer/VBoxContainer/mission_2
@onready var mission_3: 	Button = $vr_layer/mission_list/MarginContainer/ScrollContainer/VBoxContainer/mission_3
@onready var mission_4: 	Button = $vr_layer/mission_list/MarginContainer/ScrollContainer/VBoxContainer/mission_4
@onready var mission_5: 	Button = $vr_layer/mission_list/MarginContainer/ScrollContainer/VBoxContainer/mission_5
@onready var begin_btn: 	B2_Border_Button = $vr_layer/begin_btn
@onready var back_btn: 		B2_Border_Button = $vr_layer/back_btn

## Character stuff
@onready var cc_button: 	B2_Border_Button = $character_layer/CC_Button
@onready var x_1_button: 	B2_Border_Button = $character_layer/X1_Button
@onready var skip_button:	B2_Border_Button = $character_layer/Skip_Button
@onready var return_button: B2_Border_Button = $character_layer/Return_Button

@onready var title_buttons := [
	start_button,
	settings_button,
	quit_button
]

## Character Slots
@onready var gameslot_layer = $gameslot_layer
#endregion

@onready var game_version_lbl: Label = $game_version_lbl

# region Color stuff
var text_color_normal := Color.GRAY # c_gray; // For text that cannot be interacted with
var text_color_button := Color.LIGHT_GRAY # c_ltgray; // Text that can be clicked
var text_color_hover  := Color.WHITE # c_white;
var text_color_select := Color.ORANGE # c_orange;

var title_highlight_color := Color.ORANGE
var settings_highlight_color := Color.ORANGE
var gameslot_highlight_color := Color.ORANGE

var key_highlight_color := Color(240, 50, 255) # make_color_rgb(240, 50, 255);

## Stock ticker -- This was disabled on the janky demo
var stock_x : Array[float]
var stock_y : float

#endregion

# menu state
var mode = "basic" :# "basic", "settings", "keymap", "gamepad", "gameslot","destruct_confirm", "gamestart_character", "vr" ## NOTE This reeeealy should be an enum.
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
	## Logo Flash
	s_barkley_2_logo.modulate = Color.WHITE * 2.0
	
	## Logo Flash normalizer
	var t := create_tween()
	t.tween_property(s_barkley_2_logo, "modulate", Color.WHITE, 1.0)
	
	## Load Title stuff
	B2_Config.title_screen_loaded.emit()
	
	for n in bg.get_children():
		if n is AnimatedSprite2D:
			n.play("default")
	
	B2_Config.language_changed.connect( set_title_names )
	B2_Screen.set_cursor_type( B2_Screen.TYPE.POINT )
	
	B2_Screen.can_pause = false
	
	## Room teleport shenanigans
	B2_RoomXY.reset_room()
	
	## Music
	await get_tree().process_frame
	B2_Music.room_get( "r_title" )
	mode = "basic" ## default state of the game.
	
	for i in 40:
		var star = O_TITLE_STARPASS.instantiate()
		star.position = Vector2( randf_range(0, get_viewport_rect().end.x), randf_range(0, get_viewport_rect().end.y) )
		star.name = "star" + str(i)
		add_child(star)
	
	## Stock Ticker ## Maybe this isnt used in the "final" game? 18/05/25 - This seems related to the object o_minotaur01 or room r_chu_minotaur01
	## 23/05/25 im bored, lets enable this for no reason.
	#if show_stock_ticker:
	stock_x.resize(7)
	stock_x[0] = 20.0;
	stock_x[1] = 100.0;
	stock_x[2] = 180.0;
	stock_x[3] = 260.0;
	stock_x[4] = 340.0;
	stock_x[5] = 420.0;
	stock_x[6] = 500.0;
	#stock_y = 225;
	stock_y = 3; ## This looks way better
	
	#region Menu Layout stuff. Not necessary, but I really want to make a 1:1 recreation.
	
	## Decorations
	# Barkley logo
	#draw_sprite(s_jankyDemo01, 0, SCREEN_WIDTH/1.5, SCREEN_HEIGHT/2 - 20);
	s_janky_demo_01.global_position = Vector2(get_viewport_rect().end.x / 1.5, get_viewport_rect().end.y /2 - 20) - (s_janky_demo_01.size / 2)
	s_janky_demo_01.visible = show_janky_logo ## Hide the logo if you want.
	
	## Create Panels / Borders
	# Border("generate", 0, 100 + 16, 60 + 16 - 1); // Title Box
	title_panel.set_panel_size( 100 + 16, 60 + 16 - 1 )
	title_panel.global_position = Vector2( title_x - 8, title_y - 15 )
	for i in range( title_buttons.size() ): # Set the button positions
		title_buttons[i].size = Vector2(100, title_row + 1)
		title_buttons[i].global_position = Vector2(title_x + 50, title_y + (title_row * i) + (title_gap * i) + 4) - ( title_buttons[i].size / 2 )
	
	set_title_names()
	
	## Set game version.
	game_version_lbl.text = str( ProjectSettings.get_setting("application/config/version") )

func _input(event: InputEvent) -> void:
	if event is InputEventJoypadButton or event is InputEventKey:
		
		## Debug fun stuff
		if event.is_pressed():
			if Input.is_key_pressed(KEY_1):
				s_janky_demo_01.visible = not s_janky_demo_01.visible
				queue_redraw()
			if Input.is_key_pressed(KEY_2):
				show_demo_msg = not show_demo_msg
				queue_redraw()
			if Input.is_key_pressed(KEY_3):
				show_stock_ticker = not show_stock_ticker
				queue_redraw()
		
		## Handle keyboard and gamepad inputs, to make sure that "something" always has input focus.
		match mode:
			"basic":
				if not check_focus( [ start_button, settings_button, quit_button, vr_button, debug_button ] ):
					start_button.grab_focus()
			"settings":
				pass
			"keymap":
				pass
			"gamepad":
				pass
			"gameslot":
				pass
			"destruct_confirm":
				pass
			"gamestart_character":
				if not check_focus( [ cc_button, x_1_button, skip_button, return_button ] ):
					cc_button.grab_focus()
			"vr":
				if not check_focus( [ mission_1, mission_2, mission_3, mission_4, mission_5, begin_btn, back_btn ] ):
					mission_1.grab_focus()

func check_focus( btn_array : Array ) -> bool:
	for btn in btn_array:
		if btn.has_focus():
			return true
	return false

# Translate the title menu to albhed, if necessary
func set_title_names():
	start_button.text		= Text.pr("Game Time")
	settings_button.text	= Text.pr("Settings")
	quit_button.text		= Text.pr("Quit")
	
func init_menus(): ## This is just to alling with the old code. There are better ways to do this.
	## Settings
	pass
	
func change_menu( force_mode := ""): # "basic", "settings", "keymap", "gamepad", "gameslot","destruct_confirm", "gamestart_character"
	if force_mode:
		mode = force_mode
		
	match mode:
		"basic":
			title_layer.show() 			# <-
			settings_layer.hide()
			gameslot_layer.hide()
			character_layer.hide()
			vr_layer.hide()
		"settings", "keymap", "gamepad":
			title_layer.hide()
			settings_layer.show() 		# <-
			gameslot_layer.hide()
			character_layer.hide()
			vr_layer.hide()
		"gameslot", "destruct_confirm":
			title_layer.hide()
			settings_layer.hide()
			gameslot_layer.show() 		# <-
			character_layer.hide()
			vr_layer.hide()
		"gamestart_character":
			title_layer.hide()
			settings_layer.hide()
			gameslot_layer.hide()
			character_layer.show() 		# <-
			vr_layer.hide()
		"vr":
			title_layer.hide()
			settings_layer.hide()
			gameslot_layer.hide()
			character_layer.hide()
			vr_layer.show() 			# <-
			
		_: ## Catch all
			push_error("Unknown mode called: ", mode)
			

func _process(_delta):
	if B2_Config.tim_follow_mouse:
		
		tim = get_global_mouse_position().x / 384.0
		
		for child in bg.get_children():
			if child.has_method("apply_tim"):
				child.apply_tim( tim )
				
	
				
	#// Stock ticker //
	if show_stock_ticker:
		for i in 7: 
			if (stock_x[i] > -80.0): stock_x[i] -= 20.0 * _delta
			else: stock_x[i] = 500.0
		queue_redraw()

func _draw():
	if show_demo_msg:
		var qrx = 150 + 20 # + 20 added by me
		var qry = 100 + 15 + 2 ; # + 2 was added by me.
		var font := preload("res://barkley2/resources/fonts/fn_small.tres")
		#draw_text(qrx, qry, "DEMO game for backers.");
		draw_string( font, Vector2(qrx,qry), Text.pr("DEMO game for backers.")					,HORIZONTAL_ALIGNMENT_LEFT,-1,16,Color.YELLOW)
		qry += 14; 
		#draw_text(qrx, qry, "Substantial levels of WONK and JANK.");
		draw_string( font, Vector2(qrx,qry), Text.pr("Substantial levels of WONK and JANK.")	,HORIZONTAL_ALIGNMENT_LEFT,-1,16,Color.YELLOW)
		qry += 14; 
		#draw_text(qrx, qry, "Experience accordingly.");
		draw_string( font, Vector2(qrx,qry), Text.pr("Experience accordingly.")					,HORIZONTAL_ALIGNMENT_LEFT,-1,16,Color.YELLOW)
	
	## Talk about wasting time coding a useless thing, right? 23/05/25
	if show_stock_ticker and stock_x:
		var font2 := preload("uid://b6ag0xl5d2ibh")
		draw_rect( Rect2( Vector2(0,stock_y - 3), Vector2(384,20) ), Color( Color.BLACK, 0.75 ), true )
		var ticker_color := Color.from_rgba8(80, 255, 40)
		draw_string( font2, Vector2(stock_x[0],stock_y), Text.pr("DOW +6%")			,HORIZONTAL_ALIGNMENT_CENTER,-1,16,ticker_color)
		draw_string( font2, Vector2(stock_x[1],stock_y), Text.pr("Oil -9%")			,HORIZONTAL_ALIGNMENT_CENTER,-1,16,ticker_color)
		draw_string( font2, Vector2(stock_x[2],stock_y), Text.pr("Milk +75%")		,HORIZONTAL_ALIGNMENT_CENTER,-1,16,ticker_color)
		draw_string( font2, Vector2(stock_x[3],stock_y), Text.pr("Grain +0%")		,HORIZONTAL_ALIGNMENT_CENTER,-1,16,ticker_color)
		draw_string( font2, Vector2(stock_x[4],stock_y), Text.pr("Werthers +4%")	,HORIZONTAL_ALIGNMENT_CENTER,-1,16,ticker_color)
		draw_string( font2, Vector2(stock_x[5],stock_y), Text.pr("BBQ +1.5%")		,HORIZONTAL_ALIGNMENT_CENTER,-1,16,ticker_color)
		draw_string( font2, Vector2(stock_x[6],stock_y), Text.pr("ToG -45%")		,HORIZONTAL_ALIGNMENT_CENTER,-1,16,ticker_color)
		## Part of me want to add a Criptocurrency reference to this, but i wonder if it will be way lame or funny because its lame.
		## I also wanted to make a "stock market simulator" using perlin noise, changing these values. Maybe some other time.

## 29/04/25 its been a long time since I've been here. The title screen is very different from the rest of the game.
## it was my first shot on porting the GML code to Godot.
## Add VR Missions section to the game, to test the combat feature.
func _on_vr_btn_button_pressed() -> void:
	mode = "vr"
	change_menu()
	vr_layer.show_menu()

func _on_debug_btn_button_pressed() -> void:
	B2_Config.select_user_slot( 100 )
	B2_Playerdata.preload_skip_tutorial_save_data()
	B2_Gun.add_gun_to_gunbag()
	B2_Gun.add_gun_to_gunbag()
	B2_Gun.add_gun_to_gunbag()
	B2_Gun.add_gun_to_gunbag()
	B2_Music.stop( 2.0 )
	B2_Playerdata.Quest("saveDisabled", 1) ## Disable save for the debug room.
	B2_RoomXY.warp_to( "r_air_entrance03, 417, 615, 1", 2.0 )
