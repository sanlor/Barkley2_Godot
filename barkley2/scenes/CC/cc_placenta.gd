extends Control

## Placenta!
# this only shows a stupid tree, some dialog and the option to continue with the CC or start the game.

#signal answer_event # "Continue growing";
#signal answer_party # "Begin living";
signal answer(bool)
signal transition_ended

@onready var tree = $tree
@onready var frame_bg = $frame_bg

@onready var continue_cc = $frame_bg/frame/continue_cc
@onready var live = $frame_bg/frame/live


var stage := -1 # should never go past 2 (or 4, depending on the debug setup)

func _ready():
	tree.frame = stage
	#continue_cc.global_position 	= Vector2(132,194) - continue_cc.size / 2
	#live.global_position 			= Vector2(151,212) - live.size / 2
	
func show_options():
	if stage == 4:
		continue_cc.disabled = true
		
	frame_bg.modulate.a = 0.0
	frame_bg.show()
	
	var tween := create_tween()
	tween.tween_property(frame_bg, "modulate:a", 1.0, 0.25)

func next_stage():
	stage += 1
	tree.frame = stage
	await get_tree().process_frame
	
func get_stage() -> int:
	return stage

func _on_continue_cc_pressed():
	var tween := create_tween()
	tween.tween_property( frame_bg, "modulate:a", 0.0, 0.25 )
	tween.tween_callback( frame_bg.hide )
	#tween.tween_callback( emit_signal.bind("answer_event") )
	tween.tween_callback( emit_signal.bind("answer", true ) )

func _on_live_pressed():
	var tween := create_tween()
	tween.tween_property( frame_bg, "modulate:a", 0.0, 0.25 )
	tween.tween_callback( frame_bg.hide )
	#tween.tween_callback( emit_signal.bind("answer_party") )
	tween.tween_callback( emit_signal.bind("answer", false ) )
