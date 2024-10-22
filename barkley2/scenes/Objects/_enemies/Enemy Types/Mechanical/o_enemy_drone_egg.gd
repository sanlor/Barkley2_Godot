extends B2_EnemyCombatActor

@export var eggroom_computer : B2_EnvironInteractive

func explode():
	if get_parent() is B2_ROOMS:
		get_parent().post_drone_fight()
	else:
		# Where am i?
		breakpoint
