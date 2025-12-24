extends Node
## This node controls the DJ music 

# // DJ SEGMENTS // 
#	0 = anime bulldog, 
#	1 = the other guy 
# // Change the dj variable when you create this instance accordingly //

var dj 				:= 0;

# Start timer #
var timer 			:= 30; #180
var timer_segment 	:= 100; #2300 // 385
var timer_return 	:= 0;   # 0 default
var timer_camera 	:= 25;

@export var o_mg_booty_surface : Node

func _ready() -> void:
	assert( is_instance_valid(o_mg_booty_surface) )
	# Lights off #
	o_mg_booty_surface.disable_light();
	
	B2_Music.play("mus_blankTEMP")

	#instance_create(0, 0, o_mg_booty_camera);
	 
func spin_camera() -> void: # replaces 'o_mg_booty_camera'.
	pass
