extends ColorRect

signal finished

@onready var o_mg_booty_minigame: Node = $"../.."

@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var r_ado_result_label: Label = $result_box/adoration_box/r_ado_result_label
@onready var r_too_result_label: Label = $result_box/toot_box/r_too_result_label
@onready var r_var_result_label: Label = $result_box/variety_box/r_var_result_label
@onready var r_quo_result_label: Label = $quot_box/r_quo_result_label

@onready var final_result_label: Label = $final_result_label
@onready var press_button_label: Label = $press_button_label

func _ready() -> void:
	pass

func begin_sequence() -> void:
	animation_player.play("finish_sequence")

func finish_sequence() -> void:
	## TODO
	push_warning("TODO")
	
	finished.emit()

func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	finish_sequence()
