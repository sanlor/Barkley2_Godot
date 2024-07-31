@tool
extends Control

# Pretty different implementation from the original. the original one was pretty weird and hard to port exaclty.
# You can press the right button to erase the paint.

signal crest_finished
signal fade_finished
@onready var crest_frames = $crest_frames

@onready var red_btn = $red_btn
@onready var yellow_btn = $yellow_btn
@onready var blue_btn = $blue_btn
@onready var green_btn = $green_btn
@onready var purple_btn = $purple_btn
@onready var gray_btn = $gray_btn
@onready var button_array := [red_btn, yellow_btn, blue_btn, green_btn, purple_btn, gray_btn]

@onready var accept_btn_bg = $accept_btn/accept_btn_bg
@onready var accept_btn = $accept_btn

var drawn_something := false
var can_draw := false
var accept_is_hovering := false
var selected_color	:= Color.RED

func _ready():
	crest_frames.position = Vector2(192, 96) - (crest_frames.size / 2)
	
	red_btn.pressed.connect( func(): selected_color = Color.RED; 		B2_Sound.play("sn_cc_generic_button1") )
	yellow_btn.pressed.connect( func(): selected_color = Color.YELLOW; 	B2_Sound.play("sn_cc_generic_button1") )
	blue_btn.pressed.connect( func(): selected_color = Color.BLUE; 		B2_Sound.play("sn_cc_generic_button1") )
	green_btn.pressed.connect( func(): selected_color = Color.GREEN; 	B2_Sound.play("sn_cc_generic_button1") )
	purple_btn.pressed.connect( func(): selected_color = Color.PURPLE; 	B2_Sound.play("sn_cc_generic_button1") )
	gray_btn.pressed.connect( func(): selected_color = Color.GRAY; 		B2_Sound.play("sn_cc_generic_button1") )
	
	accept_btn_bg.mouse_entered.connect( func(): accept_is_hovering = true )
	accept_btn_bg.mouse_exited.connect( func(): accept_is_hovering = false )
	accept_btn.global_position = Vector2(192, 220) - (accept_btn.size / 2)
	
	for i in 6:
		if i == 0:
			button_array[i].button_pressed = true
		button_array[i].position = Vector2( 132 + i * 24, 190 ) - (button_array[i].size / 2)
	
	crest_show()
	
func _process(_delta):
	if accept_is_hovering:
		accept_btn_bg.color = Color(0.157, 0.745, 0.98, 0.5)
		if Input.is_action_just_pressed("Action"):
			crest_frames.can_draw = false
			B2_Playerdata.character_crest = true
			B2_Playerdata.character_crest_data = crest_frames.get_crest()
			B2_Playerdata.Quest("playerCCCrestMade", "1");
			#scr_savedata_put_list("playerCCCrestColor", dslCol); ## Script not ported (Too much trouble)
			#scr_savedata_put_list("playerCCCrestX", dslX);
			#scr_savedata_put_list("playerCCCrestY", dslY);
			B2_Sound.play("sn_cc_button_accept")
			get_parent().wizard_is_emoting()
			crest_hide()
	else:
		accept_btn_bg.color = Color(0.235, 0, 0.353, 0.5)

func crest_show():
	modulate.a = 0
	var tween := create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 1.0)
	tween.tween_callback( emit_signal.bind( "fade_finished" ))

func crest_hide():
	var tween := create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 1.0)
	await tween.finished
	crest_finished.emit()
	#queue_free()
