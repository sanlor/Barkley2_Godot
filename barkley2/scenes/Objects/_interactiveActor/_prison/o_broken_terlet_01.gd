extends B2_EnvironInteractive


func _on_animation_changed() -> void:
	if animation == "toiletExplode":
		offset = Vector2(-18,-67)
	else:
		offset = Vector2(0,-40)
