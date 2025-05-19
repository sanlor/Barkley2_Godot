extends Control

## NOTE This room loads the oTitle object.
# This also forces the resolution to 384 x 240.
# This scene tries to recreate the room r_title, with the object oTitle.

@export var debug_data := false
@export var hide_demo_msg := false
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

@onready var title_buttons := [
	start_button,
	settings_button,
	quit_button
]

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

## Stock Ticker ## Maybe this isnt used in the "final" game? 18/05/25 - This seems related to the object o_minotaur01 or room r_chu_minotaur01
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
	
	set_title_names()

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
			title_layer.show()
			settings_layer.hide()
			gameslot_layer.hide()
			character_layer.hide()
			vr_layer.hide()
		"settings", "keymap", "gamepad":
			title_layer.hide()
			settings_layer.show()
			gameslot_layer.hide()
			character_layer.hide()
			vr_layer.hide()
		"gameslot", "destruct_confirm":
			title_layer.hide()
			settings_layer.hide()
			gameslot_layer.show()
			character_layer.hide()
			vr_layer.hide()
		"gamestart_character":
			title_layer.hide()
			settings_layer.hide()
			gameslot_layer.hide()
			character_layer.show()
			vr_layer.hide()
		"vr":
			title_layer.hide()
			settings_layer.hide()
			gameslot_layer.hide()
			character_layer.hide()
			vr_layer.show()
			
		_: ## Catch all
			push_error("Unknown mode called: ", mode)
			
func _input(event):
	if event is InputEventMouseMotion:
		pass

func _process(_delta):
	if B2_Config.tim_follow_mouse:
		
		tim = get_global_mouse_position().x / 384
		
		for child in bg.get_children():
			if child.has_method("apply_tim"):
				child.apply_tim( tim )
				
	#// Stock ticker //
	#for (i = 0; i < 6; i += 1) 
	#{
		#if (stock_x[i] > -80) stock_x[i] -= 20 * dt_sec();
		#else stock_x[i] = 500;
	#}
	pass

func _draw():
	if hide_demo_msg:
		return
	var qrx = 150;
	var qry = 100 + 15# + 5 ; # + 5 was added by me.
	var font := preload("res://barkley2/resources/fonts/fn_small.tres")
	#draw_text(qrx, qry, "DEMO game for backers.");
	draw_string( font, Vector2(qrx,qry), Text.pr("DEMO game for backers.")					,HORIZONTAL_ALIGNMENT_LEFT,-1,16,Color.YELLOW)
	qry += 14; 
	#draw_text(qrx, qry, "Substantial levels of WONK and JANK.");
	draw_string( font, Vector2(qrx,qry), Text.pr("Substantial levels of WONK and JANK.")	,HORIZONTAL_ALIGNMENT_LEFT,-1,16,Color.YELLOW)
	qry += 14; 
	#draw_text(qrx, qry, "Experience accordingly.");
	draw_string( font, Vector2(qrx,qry), Text.pr("Experience accordingly.")					,HORIZONTAL_ALIGNMENT_LEFT,-1,16,Color.YELLOW)
	

## 29/04/25 its been a long time since I've been here. The title screen is very different from the rest of the game.
## it was my first shot on porting the GML code to Godot.
func _on_vr_btn_button_pressed() -> void:
	mode = "vr"
	change_menu()
	vr_layer.show_menu()
