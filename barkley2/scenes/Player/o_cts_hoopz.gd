extends B2_InteractiveActor

# Cutscene version of hoopz.
# check scr_event_hoopz_switch_cutscene()

func _ready() -> void:
	B2_Cinema.o_cts_hoopz = self
	change_costume("diaper")
	
func change_costume(costume_name : String) -> void:
	match costume_name:
		"matthias":
			ANIMATION_STAND 						= "s_matthias_look"
			ANIMATION_SOUTH 						= "s_matthias_idle_down"
			ANIMATION_SOUTHEAST 					= "s_matthias_idle_down"
			ANIMATION_SOUTHWEST 					= "s_matthias_idle_down"
			ANIMATION_WEST 							= "s_matthias_idle_down"
			ANIMATION_NORTH 						= "s_matthias_idle_up"
			ANIMATION_NORTHEAST 					= "s_matthias_idle_up"
			ANIMATION_NORTHWEST 					= "s_matthias_idle_up"
			ANIMATION_EAST 							= "s_matthias_idle_down"
			ANIMATION_STAND_SPRITE_INDEX 			= [1, 1, 0, 0, 0, 0, 0, 1]
			ActorAnim.animation 					= "s_matthias_look"
		"governor":
			ANIMATION_STAND 						= "s_governorLook"
			ANIMATION_SOUTH 						= "s_governorSE"
			ANIMATION_SOUTHEAST 					= "s_governorSE"
			ANIMATION_SOUTHWEST 					= "s_governorSE"
			ANIMATION_WEST 							= "s_governorSE"
			ANIMATION_NORTH 						= "s_governorNE"
			ANIMATION_NORTHEAST 					= "s_governorNE"
			ANIMATION_NORTHWEST 					= "s_governorNE"
			ANIMATION_EAST 							= "s_governorSE"
			ANIMATION_STAND_SPRITE_INDEX 			= [1, 1, 0, 0, 0, 0, 0, 1]
			ActorAnim.animation 					= "s_governorLook"
		"untamo":
			ANIMATION_STAND 						= "s_mg_vrw_player"
			ANIMATION_SOUTH 						= "s_mg_vrw_player"
			ANIMATION_SOUTHEAST 					= "s_mg_vrw_player"
			ANIMATION_SOUTHWEST 					= "s_mg_vrw_player"
			ANIMATION_WEST 							= "s_mg_vrw_player"
			ANIMATION_NORTH 						= "s_mg_vrw_player"
			ANIMATION_NORTHEAST 					= "s_mg_vrw_player"
			ANIMATION_NORTHWEST 					= "s_mg_vrw_player"
			ANIMATION_EAST 							= "s_mg_vrw_player"
			ANIMATION_STAND_SPRITE_INDEX 			= [1, 1, 0, 0, 0, 0, 0, 1]
			ActorAnim.animation 					= "s_mg_vrw_player"
		"diaper":
			ANIMATION_STAND 						= "s_cts_hoopz_diaper_stand"
			ANIMATION_SOUTH 						= "walk_S"
			ANIMATION_SOUTHEAST 					= "walk_SE"
			ANIMATION_SOUTHWEST 					= "walk_SW"
			ANIMATION_WEST 							= "walk_W"
			ANIMATION_NORTH 						= "walk_N"
			ANIMATION_NORTHEAST 					= "walk_NE"
			ANIMATION_NORTHWEST 					= "walk_NW"
			ANIMATION_EAST 							= "walk_E"
													 # N, NE, E, SE, S, SW, W, NW
			ANIMATION_STAND_SPRITE_INDEX 			= [0, 1, 2, 3, 4, 3, 2, 1]
			ActorAnim.animation 					= "s_cts_hoopz_diaper_stand"
		"prison":
			ANIMATION_STAND 						= "sHoopzPrison"
			ANIMATION_SOUTH 						= "prision_S"
			ANIMATION_SOUTHEAST 					= "prision_SE"
			ANIMATION_SOUTHWEST 					= "prision_SW"
			ANIMATION_WEST 							= "prision_W"
			ANIMATION_NORTH 						= "prision_N"
			ANIMATION_NORTHEAST 					= "prision_NE"
			ANIMATION_NORTHWEST 					= "prision_NW"
			ANIMATION_EAST 							= "prision_E"
			ANIMATION_STAND_SPRITE_INDEX 			= [15, 5, 15, 5, 10, 0, 10, 0]
			ActorAnim.animation 					= "sHoopzPrison"
		# Else, You Are Hoopz.
		_:
			ANIMATION_STAND 						= "s_cts_hoopz_stand"
			ANIMATION_SOUTH 						= "s_cts_hoopzS"
			ANIMATION_SOUTHEAST 					= "s_cts_hoopzSE"
			ANIMATION_SOUTHWEST 					= "s_cts_hoopzSW"
			ANIMATION_WEST 							= "s_cts_hoopzW"
			ANIMATION_NORTH 						= "s_cts_hoopzN"
			ANIMATION_NORTHEAST 					= "s_cts_hoopzNE"
			ANIMATION_NORTHWEST 					= "s_cts_hoopzNW"
			ANIMATION_EAST 							= "s_cts_hoopzE"
			ANIMATION_STAND_SPRITE_INDEX 			= [6, 2, 5, 1, 4, 0, 3, 7]
			ActorAnim.animation 					= "s_cts_hoopz_stand"

	pass
