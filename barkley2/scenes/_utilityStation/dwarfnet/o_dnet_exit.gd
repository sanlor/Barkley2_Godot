extends Control

@onready var dnet_screen: CanvasLayer = $"../.."
@onready var exit_player: AudioStreamPlayer = $exit_player
@onready var ja_btn: Button = $big_pussy_is_a_funny_name_for_a_character/HBoxContainer/ja_btn
@onready var nein_btn: Button = $big_pussy_is_a_funny_name_for_a_character/HBoxContainer/nein_btn

func _on_nein_btn_pressed() -> void:
	$".."._update_status( $"..".STATUS.HOME )

func _on_ja_btn_pressed() -> void:
	ja_btn.disabled = true
	nein_btn.disabled = true
	
	exit_player.play()
	await exit_player.finished
	dnet_screen.close_dnet()
