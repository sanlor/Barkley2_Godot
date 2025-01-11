extends B2_InteractiveActor

## NOTE This character has some weird code to animate the chrod plucking. im just going to ignore it.

@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

## Made with B2_TOOL_DWARF_CONVERTER
func _ready() -> void:
	_setup_actor()
	_setup_interactiveactor()
	
	# Curfew stuff
	if B2_Database.time_check("tnnCurfew") == "during":
		queue_free()
	
	# Quest checks
	## Gone to the wasteland ##
	if B2_Playerdata.Quest("govGuillaume") >= 2 and get_room_area() == "tnn":
		queue_free()
	
	## At the wasteland ##
	if B2_Playerdata.Quest("govGuillaume") < 2 and get_room_area() == "wst":
		queue_free()
	
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
