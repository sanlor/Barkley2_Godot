extends Control

## CHaracter creation. Lots of objects are involved in this.

# o_cc_data holds some important data
# o_cc_effect_crystal - Some kind of effect, not sure
# o_cc_effect_backdrop - Some kind of effect, particules, aparently
# 
# Events are in this order:
# o_cc_wizard - wizar apears, moves hands and talk: - DONE
# o_cc_name - Player adds its name and handles text displaying
## FOCUS ON THESE ONES ^^^^^^^^

@onready var animation_player = $AnimationPlayer

@onready var fade_texture = $fade_texture

@onready var cc_wizard_base = $cc_wizard_base
@onready var cc_wizard_emote = $cc_wizard_emote
@onready var cc_wizard_talk = $cc_wizard_talk

@onready var cc_textbox = $cc_textbox

## Timers //
var timer_alpha_in 			= 10.0 / 10
var timer_prepare_hands 	= 25.0
var timer_show_hands 		= 0.0;
var timer_sound 			= 25.0
var timer_ready_to_proceed 	= 35.0

var image_index_intro = 0.0;

func play_sfx(track_name : String):
	#B2_Sound.play("sn_cc_wizard_arms")
	B2_Sound.play(track_name)

func _ready():
	fade_texture.show()
	#await get_tree().create_timer(8.0).timeout
	
	B2_Music.play			( "mus_charcreate" )
	animation_player.play	( "wizard_intro" )
	#var tween := create_tween()
	#tween.tween_property(fade_texture, "modulate:a", 0.0, timer_alpha_in )
	#B2_Sound.play("sn_cc_wizard_arms")
	
func wizard_is_talking():
	cc_wizard_talk.show()
	var new_frame := wrapi(cc_wizard_talk.frame, 0, 3)
	new_frame += randi_range(0,1) + 1
	cc_wizard_talk.frame = new_frame
	
func wizard_is_silent():
	cc_wizard_talk.hide()
	pass
	
func wizard_is_emoting():
	pass
	
func _on_animation_player_animation_finished(anim_name):
	if anim_name == "wizard_intro":
		cc_textbox.display_text( Text.pr( "Greetings, young one. I have been awaiting your#arrival for some time now. The world has been#waiting for your arrival. Ah, but my manners...#Please, take a seat and make yourself comfortable.") )
		await cc_textbox.finished_typing
		cc_textbox.display_text( Text.pr( "Tell me about yourself... Yes, your name... What is#your name?") )
		await cc_textbox.finished_typing
		cc_textbox.texbox_hide()
		await cc_textbox.visibility_changed
		
		breakpoint
		
		
#text[1] = "Tell me about yourself... Yes, your name... What is#your name?";   
#text[2] = "Yes, an ancient name... a noble name. It has been#some time since I've heard that name. And yet, I#knew you carried it as soon as I laid eyes on you.";
#text[3] = "It is a name that bears much strength, but also#much sorrow. It is a name with a tragic history, a#glorious history. And it is a name with history yet#unwritten...";   
#text[4] = "Now answer me these questions, " + o_cc_data.character_name + "."; 
