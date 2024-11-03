extends B2_InteractiveActor

@export var eggroom_computer : B2_EnvironInteractive

func _ready() -> void:
	_setup_actor()
	_setup_interactiveactor()
	ANIMATION_STAND 						= "s_eggDrone01"
	ANIMATION_SOUTH 						= "s_eggDroneDOWN01"
	ANIMATION_SOUTHEAST 					= "s_eggDroneDOWN01"
	ANIMATION_SOUTHWEST 					= "s_eggDroneDOWN01"
	ANIMATION_WEST 							= "s_eggDroneDOWN01"
	ANIMATION_NORTH 						= "s_eggDroneUP01"
	ANIMATION_NORTHEAST 					= "s_eggDroneUP01"
	ANIMATION_NORTHWEST 					= "s_eggDroneUP01"
	ANIMATION_EAST 							= "s_eggDroneDOWN01"
	ANIMATION_STAND_SPRITE_INDEX 			= [1, 1, 0, 0, 0, 0, 0, 1]
	ActorAnim.animation 					= "s_eggDrone01"

func execute_event_user_1():
	# Set battle mode.
	# also, change sometning with the computer
	# eggroom_computer is important
	if get_parent() is B2_ROOMS:
		get_parent().pre_drone_fight()
	else:
		# Where am i?
		breakpoint
