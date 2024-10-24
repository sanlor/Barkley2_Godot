extends Control
class_name B2_EffectAtmo

func _enter_tree() -> void:
	await get_tree().process_frame
	
	z_index = B2_Config.EFFECTATMO_LAYER
	
	if get_parent() is B2_ROOMS:
		var room_size := get_parent().room_size as Vector2
		size = room_size
		print("B2_EffectAtmo: size is %s." % room_size)
