@tool
extends TextureRect

@onready var cc_textbox_fg = $cc_textbox_fg
@onready var textbox = $textbox

@onready var default_type_timer = $default_type_timer

## Wizard
@export var wizard_cc : Control = get_parent()


## CC layout colors ##
var color_textbox = Color8(0, 0, 115);
var color_event = Color8(60, 0, 90);
var color_question_hover = Color8(255, 0, 0);
var color_question_nohover = Color8(255, 190, 0);

var textbox_pause = 0.02 #0.16;
var textbox_wizard_cooldown = 0.04 #0.16;

var my_text := ""

## Typing stuff
var comma_pause := 0.4 #0.8
var period_pause := 1.1 #2.2
var dash_pause := 0.4 #0.8

var normal_typing := 1.0
var fast_typing := 0.01
var curr_typing_speed := normal_typing

signal finished_typing
signal input_pressed

## SFX
var wizard_sounds := [ "sn_cc_wizard_talk01", "sn_cc_wizard_talk02", "sn_cc_wizard_talk03" ]

func _ready():
	hide()
	global_position = Vector2(12, 170)
	#cc_textbox_fg.global_position = Vector2(192, 198)
	textbox.global_position = Vector2(21, 176)
	default_type_timer.wait_time = textbox_pause
	_init_textbox()
	
func _process(_delta):
	if not Engine.is_editor_hint():
		if 	Input.is_action_just_pressed("Action"):
			curr_typing_speed = fast_typing
			if textbox.visible_ratio == 1.0:
				input_pressed.emit()
			else:
				textbox.visible_ratio = 1.0
				wizard_cc.wizard_is_silent()
				B2_Sound.play( wizard_sounds.pick_random() )
				
		if Input.is_action_just_released("Action"):
			curr_typing_speed = normal_typing
		
func _init_textbox():
	textbox.text = ""
	modulate = Color.TRANSPARENT
	
## Text box tweens into existence.
func texbox_show():
	modulate = Color.TRANSPARENT
	show()
	var tween := create_tween()
	tween.tween_property(self, "modulate", Color.WHITE, 0.25)
	await tween.finished
	
## Text box tweens out.
func texbox_hide():
	var tween := create_tween()
	tween.tween_property(self, "modulate", Color.TRANSPARENT, 0.25)
	textbox.text = ""
	hide()
	
func display_text( text : String):
	if not visible:
		texbox_show()
	textbox.text = text
	textbox.visible_characters = 0
	
	default_type_timer.start() # start the typing timer
	
func _on_default_type_timer_timeout():
	if textbox.visible_ratio == 1.0:
		await input_pressed
		wizard_cc.wizard_is_silent()
		finished_typing.emit()
		return
		
	var add_wait := 0.0
	var curr_char : String = textbox.text [ textbox.visible_characters ]
	match curr_char: # add a pause for certain characters
		" ":
			add_wait = 0.0
			wizard_cc.wizard_is_silent()
		",":
			add_wait = comma_pause
			wizard_cc.wizard_is_silent()
		".":
			add_wait = period_pause
			wizard_cc.wizard_is_silent()
		"-":
			add_wait = dash_pause
			wizard_cc.wizard_is_silent()
		_:
			# Avoid playing sounds when players skips
			if curr_typing_speed == normal_typing:
				B2_Sound.play( wizard_sounds.pick_random() )
				
			wizard_cc.wizard_is_talking()
			
	textbox.visible_characters += 1
	default_type_timer.start( (textbox_pause + add_wait) * curr_typing_speed )
	
#draw_sprite_ext(s_cc_textbox_backdrop, 0, view_xview + 12, view_yview + 170, 1, 1, 0, o_cc_data.color_textbox, alpha_textbox);
#draw_sprite_ext(s_cc_textbox_frames, 0, 192, 198, 1, 1, 0, c_white, alpha_textbox * 2);
#
#// Text for texboxes //
#draw_set_color(c_white);
#draw_set_alpha(alpha_textbox * 2);
#draw_set_font(global.fn_2);
#draw_set_halign(fa_left);
#draw_set_valign(fa_top);
#draw_text(21, 176, textbox_written);



