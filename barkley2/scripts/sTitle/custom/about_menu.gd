extends B2_Border

func _on_close_pressed():
	get_parent().queue_free()
