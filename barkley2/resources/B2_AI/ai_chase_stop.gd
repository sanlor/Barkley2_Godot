extends B2_AI_Chase
class_name B2_AI_Chase_Stop

@export var look_sfx := "explosiverat_stopandlook"

var chase_timer 	: Timer
var stop_timer 		: Timer

## This AI just chases the player and sometimes, just stops.
func _ready() -> void:
	_timer_setup()
	
func _timer_setup() -> void:
	var t := Timer.new()
	t.one_shot = true
	
	chase_timer 	= t.duplicate()
	stop_timer 		= t.duplicate()
	chase_timer.wait_time = randf_range( 5.5, 15.0 ) 	## Max time that the AI chases the player.
	stop_timer.wait_time = randf_range( 0.5, 10.0 ) 		## Max time that the AI stays stopped.
	chase_timer.timeout.connect( _chase_timeout )
	stop_timer.timeout.connect( _stop_timeout )
	add_child( chase_timer, true )
	add_child( stop_timer, true )
	
	chase_timer.start()
	
func step() -> void:
	## Check if has a valid target
	if B2_CManager.o_hoopz:
		if actor:
			if chase_timer.time_left and not B2_CManager.o_hoopz.is_actor_dead:
				var ActorNav := actor.ActorNav
				var target := B2_CManager.o_hoopz
				
				ActorNav.set_target_position( target.global_position )
				actor.curr_input = actor.global_position.direction_to( ActorNav.get_next_path_position() )
			else:
				actor.curr_input = Vector2.ZERO
	
func _chase_timeout() -> void:
	stop_timer.start()
	if actor:
		## Face a random direction
		actor.curr_input = Vector2.LEFT.rotated( randf_range(0,TAU) )
		actor.play_local_sound( look_sfx )
	
func _stop_timeout() -> void:
	chase_timer.start()
