extends B2_InteractiveActor

func _ready() -> void:
	_setup_actor()
	_setup_interactiveactor()
	
	## Animation
	ANIMATION_STAND				= "default"
	ANIMATION_SOUTH 			= "walk_s"
	ANIMATION_SOUTHEAST 		= "walk_s"
	ANIMATION_SOUTHWEST 		= "walk_s"
	ANIMATION_WEST 				= "walk_w"
	ANIMATION_NORTH 			= "walk_n"
	ANIMATION_NORTHEAST 		= "walk_n"
	ANIMATION_NORTHWEST 		= "walk_n"
	ANIMATION_EAST 				= "walk_e"
	ANIMATION_STAND_SPRITE_INDEX 	= [ 2, 2, 3, 0, 0, 0, 3, 2 ] # N, NE, E, SE, S, SW, W, NW
	ActorAnim.animation 	= ANIMATION_STAND

func execute_event_user_0():
	push_warning("Loading debug settings")
	## Debug Stuff
	B2_Playerdata.preload_skip_tutorial_save_data()
	B2_Gun.add_gun_to_bandolier()
	B2_Gun.add_gun_to_bandolier()
	B2_Gun.get_bandolier()[0].use_ammo( 5 ) 	## Test smelt
	B2_Gun.get_bandolier()[1].use_ammo( 10 ) 	## Test smelt
	#B2_Gun.add_gun_to_bandolier()
	B2_Gun.add_gun_to_gunbag()
	B2_Gun.add_gun_to_gunbag()
	B2_Gun.add_gun_to_gunbag()
	B2_Gun.add_gun_to_gunbag()
	B2_Gun.add_gun_to_gunbag()
	B2_Gun.add_gun_to_gunbag()
	B2_Vidcon.give_vidcon( 0 )
	B2_Vidcon.give_vidcon( 1 )
	B2_Vidcon.give_vidcon( 2 )
	B2_Vidcon.give_vidcon( 3 )
	B2_Vidcon.unbox_vidcon( 0 )
	B2_Vidcon.unbox_vidcon( 1 )
	B2_Jerkin.gain_jerkin("Lead Jerkin")
	B2_Jerkin.gain_jerkin("Vestal Jerkin")
	B2_Jerkin.gain_jerkin("Bottlecap Jerkin")
