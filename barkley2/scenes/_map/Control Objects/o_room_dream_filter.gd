extends Node2D

@onready var eyelid_filler_left: 		Sprite2D = $eyelid_filler_left
@onready var eyelid_filler_right: 		Sprite2D = $eyelid_filler_right
@onready var top_eyelid: 				Sprite2D = $top_eyelid
@onready var botton_eyelid: 			Sprite2D = $botton_eyelid


## Blink ##
var eye_position = 64.0;
var eye_position_goal = 64.0;
var timer_eye_open = 15.0;
var timer_blink = 25.0; 
var blink_blood = 0.1;
var alpha_eye = 0.0;
var alpha_eye_drain = false;
var alpha_intensity = 0.0
var layers = 4;

func _ready() -> void:
	## Don't exist after tutorial is done ##
	if B2_Playerdata.Quest( "tutorialProgress", null, 0 ) >= 100:
		queue_free()
		
	#var room : String = get_parent().name
	var room = "" #debug
	print(B2_Playerdata.Quest("tutorialProgress", null, 0))
	if room == "r_fct_factoryOutpost01": alpha_intensity = 0.15;
	elif B2_Playerdata.Quest("tutorialProgress", null, 0) 	== 9: alpha_intensity = 0.3;
	elif B2_Playerdata.Quest("tutorialProgress", null, 0) 	== 8: alpha_intensity = 0.45;
	elif B2_Playerdata.Quest("tutorialProgress", null, 0) 	== 5: alpha_intensity = 0.8;
	else: alpha_intensity = 1;

func execute_event_user_0():
	print("aaaaaa")
	pass
	
func execute_event_user_1():
	print("aaaaaa")
	pass

func execute_event_user_2():
	print("aaaaaa")
	pass
