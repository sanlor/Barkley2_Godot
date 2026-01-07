extends B2_EnvironInteractive

func _ready() -> void:
	# Dont appear once ransacked or if wilmer still lives #
	if B2_Playerdata.Quest("wilmerBones") >= 1 and get_room_name() == "r_tnn_residentialDistrict01": queue_free()
	if B2_Playerdata.Quest("wilmerEvict") < 10 and get_room_name() == "r_tnn_residentialDistrict01": queue_free()

	# Dont appear if you haven't laid them next to Esther's Grave #
	if B2_Playerdata.Quest("wilmerBones") < 2 and get_room_name() == "r_pea_snowTop01": queue_free()
	
	var t := create_tween()
	self_modulate.a = 0.0
	t.tween_property(self, "self_modulate:a", 1.0, 1.0)
