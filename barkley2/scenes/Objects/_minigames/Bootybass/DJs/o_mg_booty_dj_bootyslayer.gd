extends "res://barkley2/scenes/Objects/_minigames/Bootybass/DJs/o_mg_booty_dj_segments.gd"

var o_bootySlayer01 : B2_InteractiveActor
var o_animeBulldog01 : B2_InteractiveActor

func _ready() -> void:
	super()
	
	dj = 1
	
	# This node expects to find a node called "o_bootySlayer01" and "o_animeBulldog01" as its sibling.
	o_bootySlayer01 = get_parent().find_child("o_bootySlayer01")
	o_animeBulldog01 = get_parent().find_child("o_animeBulldog01")
	assert(o_animeBulldog01)
	assert(o_bootySlayer01)
	
	o_bootySlayer01.cinema_set( "default" )
	o_animeBulldog01.cinema_set( "stop" )
	
	play_music()
	enable_dj_lights()
	spin_camera()
