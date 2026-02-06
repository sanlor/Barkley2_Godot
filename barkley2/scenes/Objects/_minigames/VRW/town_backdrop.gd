extends Control

func _process(_delta: float) -> void:
	if B2_CManager.camera:
		position.x = B2_CManager.camera.position.x# + B2_CManager.camera.offset.x 
		position.x -= 384.0 / 2.0
		position.x = clampf( position.x, 0.0, 1055.0)
