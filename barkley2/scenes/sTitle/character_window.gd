extends CanvasLayer

const R_CC 		= preload("res://barkley2/rooms/r_cc.tscn")
const R_WIP 	= preload("res://barkley2/rooms/r_wip.tscn")

## TEMP - Should have a better way to do this.
#const R_FCT_EGG_ROOMS_01 = preload("res://barkley2/rooms/factory/floor2/r_fct_eggRooms01.tscn")
## NOTE Found a better way. use B2_RoomXY

@onready var r_title 	= $".."
@onready var fade_out 	= $fade_out

@onready var cc_button 		: B2_Border_Button = 		$CC_Button
@onready var x1_button 		: B2_Border_Button = 		$X1_Button
@onready var skip_button 	: B2_Border_Button = 		$Skip_Button

@onready var return_button 	: B2_Border_Button = 		$Return_Button

## Character Select ## "Create Character", "Play as X114JAM9", "Skip the Stupid Prologue", "Return"
var character_x = 20;
var character_y = 20;
var character_row = 20;
var character_gap = 5;

## Some moth job from the original code
var gameslot_x = 30;
var gameslot_y = 10; 

var settings_x = 40;
var settings_y = 64 - 6;
var settings_row = 16;
var settings_gap = 0;
var settings_width = (24 * 8);
var settings_option_x = 143 - 32;

var settings_tab_y = settings_y - 48;
var settings_return_y = settings_y + settings_row * 9 + settings_gap * 9 + 0;

func _ready():
	cc_button.button_pressed.connect( _on_cc_button_button_pressed )
	x1_button.button_pressed.connect( _on_x_1_button_button_pressed )
	skip_button.button_pressed.connect( _on_skip_button_button_pressed )
	return_button.button_pressed.connect( _on_return_button_button_pressed )
	
	var drx = (get_viewport().get_visible_rect().size.x / 2) - 90; ## settings_x - 8;
	#print(get_viewport().get_visible_rect())
	var dry = gameslot_y + 40; ## settings_return_y;
	
	var character_buttons := [cc_button, x1_button, skip_button]
	
	for i in 3:
		character_buttons[i].set_panel_size(180, 32)
		character_buttons[i].global_position = Vector2(drx, dry)
		var label := Label.new()
		label.horizontal_alignment 	= HORIZONTAL_ALIGNMENT_CENTER
		label.vertical_alignment 	= VERTICAL_ALIGNMENT_CENTER
		label.size = character_buttons[i].get_panel_size()
		if i == 0:
			label.text = Text.pr("Create Character")
		elif i == 1:
			label.text = Text.pr("Play as X114JAM9")
		elif i == 2:
			label.text = Text.pr("Skip the Stupid Prologue")
		character_buttons[i].add_decorations(label)
		dry += 40;
	
	return_button.set_panel_size(320 + 8, 32) ## Return Panel and button
	return_button.global_position = Vector2(settings_x - 8, settings_return_y)
	
	var returnlabel := Label.new()
	returnlabel.text = Text.pr("Return")
	returnlabel.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	returnlabel.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	returnlabel.size = return_button.get_panel_size()
	return_button.add_decorations(returnlabel)

# "basic", "settings", "keymap", "gamepad", "gameslot","destruct_confirm", "gamestart_character" ## NOTE This reeeealy should be an enum.
func _on_return_button_button_pressed():
	r_title.mode = "gameslot"
	hide()

func _on_cc_button_button_pressed(): ## Open the CC. Good luck
	#show_notice()
	_disable_buttons()
	load_new_room( "r_cc" )
	
func _on_x_1_button_button_pressed():
	_disable_buttons()
	B2_Playerdata.preload_CC_save_data() 		# load some default data
	B2_Playerdata.preload_tutorial_save_data() 	# Add some other data
	load_new_room( "r_fct_eggRooms01" ) 		# Default opening room. 

# THis behaves differently from the actual game. It plays the Wilmer cutscene and everything.
func _on_skip_button_button_pressed():
	_disable_buttons()
	B2_Playerdata.preload_skip_tutorial_save_data()
	load_new_room( "r_tnn_wilmer02" )
	#show_notice()

func _disable_buttons(): # called when loading the game.
	cc_button.disabled 		= true
	x1_button.disabled 		= true
	skip_button.disabled 	= true
	
func show_notice():
	var oConfirm : B2_Confirm = preload("res://barkley2/scenes/confirm/b2_confirm.tscn").instantiate()
	oConfirm.givTxt = Text.pr("This is not available at this point.")
	oConfirm.curr_mode = B2_Confirm.MODE.NOTICE
	oConfirm.option3_pressed.connect( func(): oConfirm.queue_free() 	)
	add_child(oConfirm)

func load_new_room( room : String ):
	B2_Music.stop( 2.0 )
	B2_RoomXY.warp_to( room, 0.5 )
