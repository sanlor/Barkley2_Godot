@icon("uid://c0a8mxfkhbqid")
extends B2_FSM
class_name B2_FSM_Dash
## Actor dashes torward a direction
@export_category("General")
@export var look_at_player				:= true

@export_category("Dash delay Setup")
@export var dash_delay 					:= 2.0
@export var dash_delay_variation 		:= 1.0 				# Add a modifier to the 'dash_delay' -> dash_delay + randf_range( 0.0, dash_delay_variation )
@export var delay_smoke_emitter			: GPUParticles2D

@export_category("Dash action Setup")
@export var dash_smoke_emitter			: GPUParticles2D
@export var dash_time					:= 1.0
@export var dash_speed					:= 4.0
@export var after_dash_state			: B2_FSM

var delay_timer 	: Timer
var dash_timer 		: Timer

func enter() -> void:
	super()
	# Create timer for delay
	delay_timer = _create_timer( _trigger_timer )
	delay_timer.start( dash_delay + randf_range( 0.0, dash_delay_variation ) )
	
	# Create timer for dashing
	dash_timer = _create_timer( _finish_dashing )
	
	# Make some smoke partiles while "charging" the dash.
	if delay_smoke_emitter:
		delay_smoke_emitter.emitting = true
		delay_smoke_emitter.rotation = enemy_actor.global_position.angle_to_point( my_actor.global_position )
	
func exit() -> void:
	super()
	# Free timers
	_timer_cleanup( delay_timer, _trigger_timer)
	_timer_cleanup( dash_timer, _finish_dashing)
	
func _trigger_timer() -> void:
	if delay_smoke_emitter:
		delay_smoke_emitter.emitting = false
		
	var my_dir := my_actor.global_position.direction_to( enemy_actor.global_position )
	_dash_at_target( my_dir, dash_speed )

func _dash_at_target( my_dir : Vector2, charge_speed : float ) -> void:
	dash_timer.start( dash_time )
	my_actor.damage_player_on_contact = true
	my_actor.curr_input = my_dir * charge_speed

func _finish_dashing() -> void:
	my_actor.curr_input = Vector2.ZERO
	my_actor.curr_aim = Vector2.ZERO
	my_actor.damage_player_on_contact = false
	my_ai.state_transition( self, after_dash_state )

func step() -> void:
	if always_face_the_enemy:
		my_actor.curr_aim = my_actor.global_position.direction_to( enemy_actor.global_position )
		
		if delay_smoke_emitter:
			delay_smoke_emitter.rotation = enemy_actor.global_position.angle_to_point( my_actor.global_position )
