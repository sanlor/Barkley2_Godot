extends TextureRect

## This is a very janky imitation of the original script.
#The original script is very weird. It feels "old" comparing it to the title screen code.
# I wornt reuse this code on the acual game, so I decided to half ass this.
# TODO fix text skip.

@onready var cc_textbox_question = $cc_textbox_question
@onready var cc_textbox_fg = $cc_textbox_fg
@onready var textbox = $textbox

#@onready var default_type_timer = $default_type_timer

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
var question_pause := 0.7 #2.2 ## Added by no, not on the original.
var exclamation_pause := 0.7 #2.2 ## Added by no, not on the original.

var normal_typing := 1.0
var fast_typing := 0.01
var curr_typing_speed := normal_typing

var type_timer := 0.0
var can_type := false
var is_typing := false

## Question stuff
var is_question := false
var option1 := ""
var option2 := ""

signal finished_typing
signal input_pressed
signal awnsered_question( bool )

## SFX
var wizard_sounds := [ "sn_cc_wizard_talk01", "sn_cc_wizard_talk02", "sn_cc_wizard_talk03" ]

func _ready():
	hide()
	global_position = Vector2(12, 170)
	#cc_textbox_fg.global_position = Vector2(192, 198)
	textbox.global_position = Vector2(21, 176)
	#default_type_timer.wait_time = textbox_pause
	_init_textbox()
	
func _process(delta):
	if not Engine.is_editor_hint():
		if 	Input.is_action_just_pressed("Action"):
			curr_typing_speed = fast_typing
			if textbox.visible_ratio == 1.0:
				input_pressed.emit()
			else:
				textbox.visible_ratio = 1.0
				wizard_cc.wizard_is_silent()
				B2_Sound.play( wizard_sounds.pick_random(), 0.0, false, 1, 2.0 )
				
		if Input.is_action_just_released("Action"):
			curr_typing_speed = normal_typing
	if can_type:
		_type_next_letter(delta)
		
		if textbox.visible_ratio == 1.0:
			can_type = false
			wizard_cc.wizard_is_silent()
			
			if is_question:
				_type_questions()
			else:
				await input_pressed # we dont wait for inputs on questions
				
			finished_typing.emit()
		
func _init_textbox():
	textbox.text = ""
	modulate = Color.TRANSPARENT
	
## Text box tweens into existence.
func texbox_show():
	modulate = Color.TRANSPARENT
	show()
	var tween := create_tween()
	tween.tween_property(self, "modulate", Color.WHITE, 0.10)
	await tween.finished
	
## Text box tweens out.
func texbox_hide( wait_time := 0.10 ):
	var tween := create_tween()
	tween.tween_property(self, "modulate", Color.TRANSPARENT, wait_time)
	tween.tween_callback( hide )
	await tween.finished
	can_type = false
	await get_tree().create_timer(wait_time).timeout
	return
	
func display_text( text : String): # Remember to pre-process the text via Text.pr() before sending it here.
	if can_type:
		breakpoint
		
	get_parent().move_child( self, -1 ) # make sure that the text box is always on top of the tree.
	if not visible:
		texbox_show()
		
	textbox.text = text
	textbox.visible_characters = 0
	type_timer = textbox_pause * curr_typing_speed
	can_type = true
	
func display_question( text : String, _option1 : String, _option2 : String): # Remember to pre-process the text via Text.pr() before sending it here.
	option1 = _option1
	option2 = _option2
	is_question = true
	display_text( text )
	
func _type_next_letter(delta):
	if not visible:
		push_error("The text box is bugging out! carefull with the timing of the hide and show tweens.")
		texbox_show()
		
	if type_timer > 0.0: # Waste time until the timer is below 0.0
		type_timer -= delta
	else:
		var add_wait := 0.0
		var curr_char : String = textbox.text [ textbox.visible_characters ]

		match curr_char: # add a pause for certain characters
			" ":
				add_wait = 0.0
				wizard_cc.wizard_is_silent() # a small pause, the wizard stop talking.
			",":
				add_wait = comma_pause
				wizard_cc.wizard_is_silent()
			".":
				add_wait = period_pause
				wizard_cc.wizard_is_silent()
			"-":
				add_wait = dash_pause
				wizard_cc.wizard_is_silent()
			"!":
				add_wait = exclamation_pause
				wizard_cc.wizard_is_silent()
			"?":
				add_wait = question_pause
				wizard_cc.wizard_is_silent()
			_:
				# Avoid playing sounds when players skips
				wizard_cc.wizard_is_talking()
				
				if curr_typing_speed == normal_typing:
					B2_Sound.play( wizard_sounds.pick_random(), 0.0, false, 1, 2.0 )
				
		#wizard_cc.wizard_is_talking()
		type_timer = (textbox_pause + add_wait) * curr_typing_speed
		
		if not textbox.visible_ratio == 1.0: # avoid issues with the text skipping
			textbox.visible_characters += 1
	
func _type_questions():
	cc_textbox_question.setup_questions(option1, option2)
	var choice : bool = await cc_textbox_question.awnsered_question
	is_question = false
	awnsered_question.emit( choice )
	
