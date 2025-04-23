@tool
extends B2_Border

signal battle_results_finished

const MAX_CHARS := 50

@onready var result_title_label: Label = $MarginContainer/result_title_label
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var can_change_msg := false # avoid interactions before the battle is finished

## Result msg structure:
# "{ "msg":"placeholder message", "sfx":"sn_placeholder" }
var results : Array[Dictionary] = []

var tween : Tween

func _post_ready() -> void:
	hide()

func _input(_event: InputEvent) -> void:
	if can_change_msg:
		if Input.is_action_just_pressed("Action") or Input.is_action_just_pressed("Holster"):
			_next_message()

func _next_message() -> void:
	if not results.is_empty():
		var msg : Dictionary = results.pop_front()
		
		if msg.has("sfx"):
			B2_Sound.play( msg["sfx"] )
		if msg.has("msg"):
			result_title_label.text = msg["msg"]
		else:
			push_error("Invalid msg: ", msg)
			
	else:
		# finished displaying message.
		can_change_msg = false
		hide_battle_results()

## TODO tween_animation
func display_battle_results() -> void:
	show()
	_next_message()
	animation_player.play("show_menu")
	await animation_player.animation_finished
	can_change_msg = true
	
## TODO tween_animation
func hide_battle_results() -> void:
	animation_player.play("hide_menu")
	await animation_player.animation_finished
	
	battle_results_finished.emit()
	hide()
