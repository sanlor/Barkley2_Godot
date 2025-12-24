@icon("res://barkley2/assets/b2_original/images/merged/s_bball.png")
extends Node
## This node controls the DJ music 

# // DJ SEGMENTS // 
#	0 = anime bulldog, 
#	1 = the other guy 
# // Change the dj variable when you create this instance accordingly //

signal finished ## Emited after the event finishes.

var dj 				:= 0;

# Start timer #
var timer 			:= 30; #180
var timer_segment 	:= 100; #2300 // 385
var timer_return 	:= 0;   # 0 default
var timer_camera 	:= 25;

@export var o_mg_booty_surface : Node

func _ready() -> void:
	# This node expects to find a node called "o_mg_booty_surface" as its sibling.
	o_mg_booty_surface = get_parent().find_child("o_mg_booty_surface")
	
	assert( is_instance_valid(o_mg_booty_surface), "Node 'o_mg_booty_surface' not found." )
	
	# Lights off #
	o_mg_booty_surface.disable_light();
	
	B2_Music.play("mus_blankTEMP", 0.0)
	#instance_create(0, 0, o_mg_booty_camera);
	push_warning(">>>> %s <<<<: still INDEV." % name)
	spin_camera()
	 
func spin_camera() -> void: # replaces 'o_mg_booty_camera'.
	await get_tree().physics_frame ## TEMP!
	finished.emit()
