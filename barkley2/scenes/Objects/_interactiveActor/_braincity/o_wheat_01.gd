extends B2_PlantInteract

func _ready() -> void:
	play( Array( sprite_frames.get_animation_names() ).pick_random(), randf_range(0.01,0.5) )
	
	if sound:
		audio_stream_player_2d.stream = load( B2_Sound.get_sound(sound) )
	else:
		push_warning("No sound set.")
		
	if slow_on_collision:
		area_2d.linear_damp_space_override = Area2D.SPACE_OVERRIDE_COMBINE
		area_2d.linear_damp = 0.5
