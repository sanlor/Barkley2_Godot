extends B2_InteractiveActor

@onready var sound_emiter: AudioStreamPlayer2D = $sound_emiter

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

	## Activation & Deactivation for Curfew
	if B2_Database.time_check("tnnCurfew") == "during" and not is_inside_room():
		queue_free()
		
	if B2_Database.time_check("tnnCurfew") != "during" and is_inside_room():
		queue_free()
		
	## AT THE APPARTMENT ##
	if get_room_name() == "r_tnn_marketDistrict01":
		ActorAnim.animation = "default"
	else:
		ActorAnim.animation = "hildeSleeping"
		
	ActorAnim.play()
	
	
func _on_actor_anim_frame_changed() -> void:
	if get_room_name() == "r_tnn_marketDistrict01":
		if ActorAnim.frame == 1:
			var stream = B2_Sound.get_sound( "sn_hildeburga_wrench01" )
			sound_emiter.stream = load( stream )
			sound_emiter.play()
			
	if get_room_name() == "r_tnn_rentcontrolled01":
		if ActorAnim.frame == 1:
			var stream = B2_Sound.get_sound( "sn_almaberga_snoreIn" )
			sound_emiter.stream = load( stream )
			sound_emiter.play()
			
		if ActorAnim.frame == 9:
			var stream = B2_Sound.get_sound( "sn_almaberga_snoreOut" )
			sound_emiter.stream = load( stream )
			sound_emiter.play()
