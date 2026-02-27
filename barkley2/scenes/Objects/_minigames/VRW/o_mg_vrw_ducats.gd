extends B2_EnvironInteractive
class_name B2_Minigame_VRW_Ducats

var rng := RandomNumberGenerator.new()

func begin() -> void:
	speed_scale = rng.randf_range(0.8,1.2)
	
# Moved to 'o_mg_vrw_ducats_dupe'
#func execute_event_user_0():
	#is_interactive = false
	#var t := create_tween()
	#t.tween_property( self, "modulate", Color.TRANSPARENT, 1.0 )
	#t.tween_callback( queue_free )
