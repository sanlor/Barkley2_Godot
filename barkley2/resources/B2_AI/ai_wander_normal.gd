extends B2_AI_Wander
class_name B2_AI_Wander_Normal

@export var time_to_new_wander_target	:= 5.0
@export var distance_to_wander_target 	:= 10.0
@export var speed_multiplier			:= 50000

var wander_timer : Timer

func _ready() -> void:
	if get_parent() is B2_EnemyCombatActor:
		actor = get_parent()
		
	### Timer Setup
	wander_timer = Timer.new()
	wander_timer.name = "wander_timer"
	add_child( wander_timer, true )
	wander_timer.timeout.connect( _debug_get_random_pos )
	wander_timer.start( 5.0 )

func step() -> void:
	if actor.is_changing_states:
		return
		
	if actor.curr_MODE != B2_EnemyCombatActor.MODE.INACTIVE:
		return
	
	if actor.is_moving:
		actor.velocity = actor.global_position.direction_to( wander_target_pos ) * speed_multiplier
	else:
		actor.velocity = Vector2.ZERO
		
	actor.apply_central_force( actor.velocity ) ## MOOOOOVE

	## DEBUG
	if actor.global_position.distance_to( wander_target_pos ) < distance_to_wander_target:
		actor.is_moving = false
		wander_target_pos = Vector2.ZERO
		wander_timer.start( time_to_new_wander_target * randf_range( 0.5, 1.5 ) )
		
	## DEPRECATED
	#if _detect_player():
		#actor.is_changing_states = true
		#emote.emit( "!" )
		#var origin_offset : float = actor.ActorAnim.offset.y
		#
		#actor.curr_MODE = B2_EnemyCombatActor.MODE.COMBAT
		#actor.start_combat()
		#actor.is_changing_states = false
	
func _debug_get_random_pos():
	actor.is_moving = true
	wander_target_pos = home_point
	wander_target_pos += Vector2.LEFT.rotated( randf_range(0, TAU) ) * randf_range(0, home_radius)
	
func _detect_player() -> bool: ## DEPRECATED
	if is_instance_valid( B2_CManager.o_hoopz ):
		if actor.position.distance_to( B2_CManager.o_hoopz.position ) < detection_radius:
			actor.velocity = Vector2.ZERO
			return true
	return false
