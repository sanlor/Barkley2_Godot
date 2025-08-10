extends CanvasLayer

signal animation_finished

@warning_ignore("unused_parameter")
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	animation_finished.emit()
	queue_free()
