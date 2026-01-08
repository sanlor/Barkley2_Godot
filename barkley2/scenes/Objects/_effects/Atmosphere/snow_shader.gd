extends ColorRect

func _process(_delta: float) -> void:
	if is_node_ready():
		if B2_CManager.camera: ## FIXME 
			position = B2_CManager.camera.position - get_viewport_rect().size / 2.0
			position += B2_CManager.camera.offset
