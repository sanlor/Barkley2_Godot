extends Node

## B2 Cinema Manager
# Keeps track of CinemaScript running on the scene.

signal event_started
signal event_ended

# Loaded actors, part of the original scr_event_hoopz_switch_cutscene() script.
var o_cts_hoopz 	: B2_Actor 			= null
var o_hoopz 		: B2_Player		 	= null ## TODO Create a B2_CombatActor class

func play_cutscene( cutscene_script : B2_Script, _event_caller : Node2D, frame_await := false ):
	var b2_cinema := B2_CinemaPlayer.new()
	
	get_tree().current_scene.add_child( b2_cinema )
	b2_cinema.play_cutscene( cutscene_script, _event_caller, frame_await )
