extends B2_InteractiveActor

## https://youtu.be/SQKRnzWSW0M?t=9472

@export var my_vidcon := 0

var wait_anim := true
signal event_finished

@onready var animation_player: AnimationPlayer = $AnimationPlayer

## Made with B2_TOOL_DWARF_CONVERTER
func _ready() -> void:
	if B2_Vidcon.has_vidcon( my_vidcon ):
		queue_free()
	else:
		animation_player.play("RESET")
		_setup_actor()
		_make_cinema_script()
		_setup_interactiveactor()

func _make_cinema_script() -> void:
	var scr := B2_Script_Legacy.new()
	var my_script := \
	"FRAME      | NORMAL | %s
	EVENT       | %s | 0
	EVENT       | %s | 2
	WAIT        | 0
	NOTIFY      | You've obtained the vidcon...#@tempVidcon@
	EVENT       | %s | 3
	EVENT       | %s | 1
	WAIT        | 0" % [name, name, name, name, name]
	scr.original_script = my_script
	cutscene_script = scr

func execute_event_user_2() -> void:
	animation_player.play("treasure_free")
	await animation_player.animation_finished
	animation_player.play("treasure_flee")
	await animation_player.animation_finished
	event_finished.emit()
	
func execute_event_user_3() -> void:
	animation_player.play("treasure_end")
	await animation_player.animation_finished
	event_finished.emit()

func execute_event_user_1() -> void:
	await get_tree().process_frame ## need to wait to emit the signal.
	event_finished.emit()
	queue_free()
	
func execute_event_user_0() -> void:
	## Give Vidcon and get name
	B2_Vidcon.give_vidcon( my_vidcon )
	B2_Playerdata.Quest("tempVidcon", B2_Vidcon.get_vidcon_name(my_vidcon) );
	await get_tree().process_frame ## need to wait to emit the signal.
	event_finished.emit()
