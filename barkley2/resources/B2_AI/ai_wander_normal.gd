extends B2_AI_Wander
class_name B2_AI_Wander_Normal

@export var time_to_new_wander_target	:= 5.0
@export var distance_to_wander_target 	:= 10.0

var wander_timer : Timer

func _ready() -> void:
	if get_parent() is B2_EnemyCombatActor:
		actor = get_parent()
		
	### Timer Setup
	wander_timer = Timer.new()
	wander_timer.name = "wander_timer"
	add_child( wander_timer, true )
	wander_timer.timeout.connect( _debug_get_random_pos )
	wander_timer.start( time_to_new_wander_target * randf_range( 0.2, 1.0 ) )
	# _debug_get_random_pos()

## AI Action
func action() -> void:
	pass

func step() -> void:
	if is_active:
		if actor.is_changing_states:
			return
			
		if actor.curr_MODE != B2_EnemyCombatActor.MODE.INACTIVE:
			return
			
		## DEBUG
		if actor.global_position.distance_to( wander_target_pos ) < distance_to_wander_target:
			actor.is_moving = false
			wander_target_pos = Vector2.ZERO
			wander_timer.start( time_to_new_wander_target * randf_range( 0.2, 2.0 ) )
			if randi_range(0,9) >= 5:
				B2_Sound.play("junkbot_death_partclink")
				actor.play_idle_anim()
		
	
func _debug_get_random_pos():
	if is_active:
		actor.is_moving = true
		wander_target_pos = home_point
		wander_target_pos += Vector2.LEFT.rotated( randf_range(0, TAU) ) * randf_range(0.1, home_radius)
		actor.set_movement_target( wander_target_pos )
