extends Control

@onready var input_1: 	VBoxContainer = $TextureRect/each_input/input1
@onready var input_2: 	VBoxContainer = $TextureRect/each_input/input2
@onready var input_3: 	VBoxContainer = $TextureRect/each_input/input3
@onready var input_4: 	VBoxContainer = $TextureRect/each_input/input4
@onready var input_5: 	VBoxContainer = $TextureRect/each_input/input5
@onready var input_6: 	VBoxContainer = $TextureRect/each_input/input6
@onready var input_7: 	VBoxContainer = $TextureRect/each_input/input7
@onready var input_8: 	VBoxContainer = $TextureRect/each_input/input8
@onready var input_9: 	VBoxContainer = $TextureRect/each_input/input9
@onready var input_10: 	VBoxContainer = $TextureRect/each_input/input10
@onready var inputs := [input_1,input_2,input_3,input_4,input_5,input_6,input_7,input_8,input_9,input_10]
var curr_input := 0

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
var target_knock 			:= [2,1,2,2,1,2,3,3,3,0]

func _physics_process(_delta: float) -> void:
	if curr_input >= 10:
		## Avoid OOB errors
		return
		
	if Input.is_action_just_pressed("Up"):
		var i := 1
		inputs[ curr_input ].set_note( i, target_knock[i] == curr_input )
		curr_input += 1
	elif Input.is_action_just_pressed("Down"):
		var i := 3
		inputs[ curr_input ].set_note( i, target_knock[i] == curr_input )
		curr_input += 1
	elif Input.is_action_just_pressed("Left"):
		var i := 2
		inputs[ curr_input ].set_note( i, target_knock[i] == curr_input )
		curr_input += 1
	elif Input.is_action_just_pressed("Right"):
		var i := 0
		inputs[ curr_input ].set_note( i, target_knock[i] == curr_input )
		curr_input += 1
