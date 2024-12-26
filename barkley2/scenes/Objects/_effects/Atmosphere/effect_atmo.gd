extends Control
class_name B2_EffectAtmo

func _enter_tree() -> void:
	await get_tree().process_frame
	
	z_index = B2_Config.EFFECTATMO_LAYER
	mouse_filter = MOUSE_FILTER_IGNORE # Ignore mouse inputs
	
	if get_parent() is B2_ROOMS:
		var room_size := get_parent().room_size as Vector2
		print("B2_EffectAtmo: size is %s." % room_size)
		if Engine.is_editor_hint():
			size = Vector2.ZERO
		else:
			size = room_size
