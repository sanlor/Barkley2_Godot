@icon("uid://c0a8mxfkhbqid")
extends B2_FSM
class_name B2_FSM_Dash
## Actor dashes torward a direction

@export_category("Dash delay Setup")
@export var dash_delay 					:= 3.0
@export var dash_delay_variation 		:= 1.0 				# Add a modifier to the 'dash_delay' -> dash_delay + randf_range( 0.0, dash_delay_variation )
@export var delay_smoke_emitter			: GPUParticles2D
@export var delay_play_animation		:= ""				# Animation to play diring the dash delay
@export var delay_loop_animation		:= false
@export_category("Dash action Setup")
@export var dash_smoke_emitter			: GPUParticles2D
@export var dash_play_animation			:= ""				# Animation to play diring the dash delay
@export var dash_loop_animation			:= false
@export var after_dash_state			: B2_FSM

var timer : Timer

func enter() -> void:
	# Create timer
	timer = Timer.new()
	add_child( timer, true )
	timer.start( dash_delay + randf_range( 0.0, dash_delay_variation ) )
	timer.connect( "timeout", _trigger_timer )
	
func exit() -> void:
	# Free timer
	timer.disconnect( "timeout", _trigger_timer )
	timer.stop()
	timer.queue_free()
	
func _trigger_timer() -> void:
	pass

func step() -> void:
	pass
