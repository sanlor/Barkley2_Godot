extends GPUParticles2D

func emit_delay( time : float ) -> void:
	await get_tree().create_timer( time ).timeout
	emitting = true
	
func _on_finished() -> void:
	queue_free()
