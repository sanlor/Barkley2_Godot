extends ColorRect

@onready var warning_text = $warning_text
@onready var accept_btn = $accept_btn
@onready var deny_btn = $deny_btn

signal choice_has_been_made(bool)
var choice := false
var button_space := 0.0

var popup_warning 	:= "Forgot to add a warning text#Jackass!";
var popup_yes 		:= "Ops";
var popup_no 		:= "Sorry";

func _ready():
	modulate.a = 0
	var tween := create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 0.75)
	
	warning_text.text = Text.pr( popup_warning )
	warning_text.modulate = Color.RED
	warning_text.global_position = Vector2( 187, 80 ) - (warning_text.size / 2)
	
	accept_btn.text = Text.pr( popup_yes )
	accept_btn.size = Vector2(50,20)
	accept_btn.global_position = Vector2( 160 - button_space, 142 ) - (accept_btn.size / 2)
	
	deny_btn.text = Text.pr( popup_no )
	deny_btn.size = Vector2(50,20)
	deny_btn.global_position = Vector2( 210 + button_space, 142 ) - (deny_btn.size / 2)
	
	accept_btn.pressed.connect( func(): choice = true; gender_warning_hide() )
	deny_btn.pressed.connect( func(): choice = false; gender_warning_hide() )

func gender_warning_hide():
	B2_Sound.play("sn_cc_generic_button1")
	var tween := create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.75)
	await tween.finished
	choice_has_been_made.emit( choice )
	queue_free()
