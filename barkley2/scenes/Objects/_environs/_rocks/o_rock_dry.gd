extends AnimatedSprite2D

func _ready() -> void:
	@warning_ignore("narrowing_conversion")
	var ran : int = (position.x * 80.12) + (position.y * 201.37) / (position.x / 2) / (position.y / 2) * (position.x * position.y);
	ran = floor(ran % 3);
	frame = wrapi( ran, 0, sprite_frames.get_frame_count("default") - 1 )
