extends B2_InteractiveActor

@onready var audio_stream_player_2d: 	AudioStreamPlayer2D = $AudioStreamPlayer2D

## Made with B2_TOOL_DWARF_CONVERTER
func _ready() -> void:
	_setup_actor()
	_setup_interactiveactor()

	ANIMATION_STAND 						= "default"
	ANIMATION_SOUTH 						= ""
	ANIMATION_SOUTHEAST 					= ""
	ANIMATION_SOUTHWEST 					= ""
	ANIMATION_WEST 							= ""
	ANIMATION_NORTH 						= ""
	ANIMATION_NORTHEAST 					= ""
	ANIMATION_NORTHWEST 					= ""
	ANIMATION_EAST 							= ""
	ANIMATION_STAND_SPRITE_INDEX 			= [0, 0, 0, 0, 0, 0, 0, 0]
	ActorAnim.animation 					= "default"
	
	## Gone to the mines ##
	if B2_Playerdata.Quest("govKalevi") >= 4 and get_room_area() == "tnn":
		queue_free()
	if B2_Playerdata.Quest("govKalevi") <= 3 and get_room_area() == "min":
		queue_free()
	
	## Check if Inside, if so change Kalevi's animation to "standing" and check for existence of curfew
	if is_inside_room():
		if B2_Database.time_check("tnnCurfew") == "before" or B2_Database.time_check("tnnCurfew") == "after":
			queue_free()
		else:
			ActorAnim.animation = "kaleviStanding"
	else:
		## Activation & Deactivation for Curfew Outside
		if B2_Database.time_check("tnnCurfew") == "during":
			queue_free()
		else:
			ActorAnim.animation = "default"
			ActorAnim.play()

func _on_actor_anim_frame_changed() -> void:
	match ActorAnim.frame:
		3:
			if B2_ClockTime.time_gate() != 3:
				audio_stream_player_2d.pitch_scale = randf_range( 0.75, 1.25 )
				audio_stream_player_2d.play()
		8:
			if randf() < 0.4:
				ActorAnim.frame = 2 
			else:
				ActorAnim.frame = 0
			ActorAnim.stop()
			await get_tree().create_timer( randf_range(0,1) ).timeout
			ActorAnim.play()
