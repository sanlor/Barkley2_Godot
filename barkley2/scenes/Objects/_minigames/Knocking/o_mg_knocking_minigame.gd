extends Control

signal finished

@onready var right_arrow_text: 	TextureRect = $TextureRect/ColorRect/HBoxContainer/right_arrow_text
@onready var up_arrow_text: 	TextureRect = $TextureRect/ColorRect/HBoxContainer/up_arrow_text
@onready var left_arrow_text: 	TextureRect = $TextureRect/ColorRect/HBoxContainer/left_arrow_text
@onready var down_arrow_text: 	TextureRect = $TextureRect/ColorRect/HBoxContainer/down_arrow_text


@onready var timer: 		Timer 		= $Timer
@onready var texture_rect: 	TextureRect = $TextureRect
@onready var input_1: 		Control = $TextureRect/each_input/input1
@onready var input_2: 		Control = $TextureRect/each_input/input2
@onready var input_3: 		Control = $TextureRect/each_input/input3
@onready var input_4: 		Control = $TextureRect/each_input/input4
@onready var input_5: 		Control = $TextureRect/each_input/input5
@onready var input_6: 		Control = $TextureRect/each_input/input6
@onready var input_7: 		Control = $TextureRect/each_input/input7
@onready var input_8: 		Control = $TextureRect/each_input/input8
@onready var input_9: 		Control = $TextureRect/each_input/input9
@onready var input_10: 		Control = $TextureRect/each_input/input10
@onready var inputs 	:= [input_1,	input_2,	input_3,	input_4,	input_5,	input_6,	input_7,	input_8,	input_9,	input_10]
var curr_input 			:= 0
var target_knock 		:= [2,			1,			2,			2,			1,			2,			3,			3,			3,			0]

@export var set_quest_variables	:= false

# Create
# Setup #
var target_show					:= 0.0;
var target_teach 				:= 0.0;
var target_room 				:= "longinus"; # For what event to call on destroy
var knock_clear 				:= 0.0;
var knock_wrong 				:= "sn_utilitycursor_buttondisabled01"; # Sound

# Positions of grafix and texts #
var y_position 					:= 144.0;
var y_goal 						:= 0.0;
var x_position_text1 			:= 384.0;
var x_position_text2 			:= 384.0;
var x_goal_text1 				:= 0.0;
var x_goal_text2 				:= 0.0;
var text1 						:= "INPUT:";
var text2 						:= "The secret knock";

# Motion of grafix and texts #
var speed_x 					:= (8.0 * 60.0);
var speed_y 					:= (8.0 * 60.0);

# Dimmer setup #
var dimmer_position 			:= 1.0;
var dimmer_goal 				:= 0.0;

# Timers #
var timer_mg_start 				:= 13.0;
var timer_mg_start_effect 		:= 5.0;
var timer_mg_end 				:= 0.0;
var timer_mg_end_effect_1 		:= 0.0;
var timer_mg_end_effect_2 		:= 0.0;
var timer_mg_end_effect_3 		:= 0.0;
var timer_mg_end_effect_4 		:= 0.0;

# Alpha values #
var alpha 						:= 0.0;
var alpha_goal 					:= 1.0;
var alpha_dim 					:= 0.0;
var alpha_dim_goal 				:= 0.0;
var alpha_flash 				:= 0.1;
var alpha_flash_goal 			:= 0.0;

# Knocks #
var knock_finished 				:= 0;
var knock_last 					:= -1;
var knock_last_cou 				:= 0;
var knock_position 				:= 0;
var knock_cooldown 				:= 0;
var knocking_mode 				:= false;
var knock_result 				:= 0;
var knock_at_position 			:= []
var knock_effect 				:= []
#for (i = 0; i < 10; i += 1) 
#{
	#knock_at_position[i] = -1;
	#knock_effect[i] = -1;
#}

# DEBUG # Test target knocks #


var minigame_failed			:= false

## Disable processisng for now
func _init() -> void:
	set_physics_process( false )

func _ready() -> void:
	## Set_position
	global_position = B2_CManager.camera.global_position - Vector2(0, 120)
	
	## Set animation position
	texture_rect.position.y = 288.0
	
	## Tween that shit.
	var t := create_tween()
	t.tween_property(texture_rect, "position:y", 48, 1.0).set_trans(Tween.TRANS_CUBIC)
	t.tween_callback( set_physics_process.bind(true) )
	
	print( "%s: quest variable settings is -> %s" % [name, set_quest_variables] )

func hide_minigame() -> void:
	texture_rect.position.y = 48.0
	
	if set_quest_variables:
		## Get results
		if minigame_failed:  B2_Playerdata.Quest("longinusDoorOpen", 1);
		else:				 B2_Playerdata.Quest("longinusDoorOpen", 3);
	
	var t := create_tween()
	t.tween_property(texture_rect, "position:y", 288.0, 1.0).set_trans(Tween.TRANS_CUBIC)
	t.tween_callback( finished.emit )
	t.tween_callback( queue_free )

func _physics_process(_delta: float) -> void:
	if curr_input >= 10:
		## Avoid OOB errors
		timer.start()
		set_physics_process( false )
		return
		
	if Input.is_action_just_pressed("Up"):
		var i := 1
		pulse_arrow(i)
		var correct	: bool = target_knock[ curr_input ] == i
		if not correct: minigame_failed = true
		inputs[ curr_input ].set_note( i, correct )
		curr_input += 1
	elif Input.is_action_just_pressed("Down"):
		var i := 3
		pulse_arrow(i)
		var correct	: bool = target_knock[ curr_input ] == i
		if not correct: minigame_failed = true
		inputs[ curr_input ].set_note( i, correct )
		curr_input += 1
	elif Input.is_action_just_pressed("Left"):
		var i := 2
		pulse_arrow(i)
		var correct	: bool = target_knock[ curr_input ] == i
		if not correct: minigame_failed = true
		inputs[ curr_input ].set_note( i, correct )
		curr_input += 1
	elif Input.is_action_just_pressed("Right"):
		var i := 0
		pulse_arrow(i)
		var correct	: bool = target_knock[ curr_input ] == i
		if not correct: minigame_failed = true
		inputs[ curr_input ].set_note( i, correct )
		curr_input += 1

func pulse_arrow( id : int ) -> void:
	var t := create_tween()
	var text : TextureRect
	match id:
		0:	text = right_arrow_text
		1:	text = up_arrow_text
		2:	text = left_arrow_text
		3:	text = down_arrow_text
		_:	breakpoint
	text.scale = Vector2(2,2)
	t.tween_property(text, "scale", Vector2.ONE, 0.25)
	
func _on_timer_timeout() -> void:
	hide_minigame()
