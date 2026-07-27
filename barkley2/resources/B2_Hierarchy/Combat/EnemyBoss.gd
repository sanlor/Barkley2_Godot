@icon("res://barkley2/assets/b2_original/images/merged/sMiniSwordbaneRed.png")
extends B2_EnemyCombatActor
class_name B2_EnemyBoss

@onready var trail_spawner: Timer = $ActorAnim/trail_spawner

var time 			:= 0.0
var sprite_wave 	:= 0.0

func _before_death() -> void:
	trail_spawner.queue_free()

func _look_at_player() -> void:
	if curr_input:
		if curr_input.x > 0:		ActorAnim.scale.x = -1
		else:						ActorAnim.scale.x = +1
	elif curr_aim:
		if curr_aim.x > 0:			ActorAnim.scale.x = -1
		else:						ActorAnim.scale.x = +1
	elif B2_CManager.o_hoopz:
		if global_position.direction_to( B2_CManager.o_hoopz.global_position ).x > 0:	ActorAnim.scale.x = -1
		else:																			ActorAnim.scale.x = +1
	else:
		ActorAnim.scale.x = +1

func get_aim_origin() -> Vector2: return global_position

func _wave_sprite() -> void:
	ActorAnim.offset.y = -ActorAnim.animation_data.get( ActorAnim.animation, Vector2(0,0) ).y + sprite_wave

func _physics_process( delta: float ) -> void:
	if Engine.is_editor_hint():	return
		
	## Makers the AI think.
	if actor_ai: actor_ai.step()
		
	match curr_STATE:
		STATE.NORMAL:			_look_at_player()
		_:						pass # breakpoint ## TODO Set default states
		
	## Anim stuff
	last_movement_vector 	= movement_vector
	
	## Movement stuff
	var move := curr_input # Take the input from the keyboard / Gamepag and apply directly.
	velocity = ( walk_speed * delta ) * move
	
	velocity += external_velocity
	external_velocity = Vector2.ZERO # Reset Ext velocity
	apply_central_force( velocity / Engine.time_scale )
	
	## Trail stuff
	time += 0.025
	sprite_wave = sin( time ) * 6.0
	_wave_sprite()
