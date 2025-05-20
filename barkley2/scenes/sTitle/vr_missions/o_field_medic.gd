extends B2_InteractiveActor

@export var waypoints : Array[B2_Ped_Waypoint]= []
@onready var step_smoke: GPUParticles2D = $step_smoke

func _ready() -> void:
	
	_setup_actor()
	_setup_interactiveactor()
	
	ANIMATION_STAND 						= "default"
	ANIMATION_SOUTH 						= "default"
	ANIMATION_SOUTHEAST 					= "default"
	ANIMATION_SOUTHWEST 					= "default"
	ANIMATION_WEST 							= "default"
	ANIMATION_NORTH 						= "default"
	ANIMATION_NORTHEAST 					= "default"
	ANIMATION_NORTHWEST 					= "default"
	ANIMATION_EAST 							= "default"
	ANIMATION_STAND_SPRITE_INDEX 			= [0, 0, 0, 0, 0, 0, 0, 0]
	ActorAnim.animation 					= "default"

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	if is_moving:
		destination = global_position
		set_movement_target( destination )
	ActorAnim.frame = randi_range(0,5)
	ActorAnim.stop()
	for i in randi_range(5,15):
		var s := Vector2.RIGHT.rotated( randf() * TAU ) * randf_range(1,15)
		step_smoke.emit_particle( Transform2D( 0, Vector2( randf_range(-10,10), randf_range(-10,10) ) ), s, Color.WHITE, Color.WHITE, 2 )

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	if not is_moving:
		if not waypoints.is_empty():
			var waypoint : B2_Ped_Waypoint = waypoints.pick_random()
			cinema_moveto( waypoint.global_position, "MOVE_NORMAL" )
			ActorAnim.stop()
