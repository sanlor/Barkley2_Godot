extends B2_Duergar

func _ready() -> void:
	modulate.a = 0.0
	
	ANIMATION_STAND 						= "s_archambeau01"
	ANIMATION_SOUTH 						= "s_archambeauSE"
	ANIMATION_SOUTHEAST 					= "s_archambeauSE"
	ANIMATION_SOUTHWEST 					= "s_archambeauSE"
	ANIMATION_WEST 							= "s_archambeauSE"
	ANIMATION_NORTH 						= "s_archambeauNE"
	ANIMATION_NORTHEAST 					= "s_archambeauNE"
	ANIMATION_NORTHWEST 					= "s_archambeauNE"
	ANIMATION_EAST 							= "s_archambeauSE"
	ANIMATION_STAND_SPRITE_INDEX 			= [1, 1, 0, 0, 0, 0, 0, 1]
	ActorAnim.animation 					= "s_archambeau01"
