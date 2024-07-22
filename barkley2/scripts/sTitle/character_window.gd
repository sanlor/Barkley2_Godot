extends CanvasLayer

const R_CC = preload("res://barkley2/rooms/r_cc.tscn")

@onready var r_title = $".."
@onready var fade_out = $fade_out

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
	fade_out.show()
	fade_out.modulate.a = 0.0
	var tween := create_tween()
	tween.tween_property(fade_out, "modulate:a", 1.0, 1.0)
	tween.tween_interval(2.5)
	tween.tween_callback( get_tree().change_scene_to_packed.bind(R_CC) )

func _on_x_1_button_button_pressed():
	show_notice()

func _on_skip_button_button_pressed():
	show_notice()

func show_notice():
	var oConfirm : B2_Confirm = preload("res://barkley2/scenes/confirm/b2_confirm.tscn").instantiate()
	oConfirm.givTxt = Text.pr("This is the end of the game (for now).")
	oConfirm.curr_mode = B2_Confirm.MODE.NOTICE
	oConfirm.option3_pressed.connect( func(): oConfirm.queue_free() 	)
	add_child(oConfirm)
