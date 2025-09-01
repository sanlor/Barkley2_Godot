extends B2_EnvironInteractive

@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

func paperwork_pick_animation() -> void:
	play("paperwork_pick")
	await animation_finished
	play("paperwork_check")
	
func paperwork_end_animation() -> void:
	play("paperwork_end")
	await animation_finished
	play("fucker")

func _on_frame_changed() -> void:
	if animation == "paperwork_end":
		if frame == 14:
			audio_stream_player_2d.play()
