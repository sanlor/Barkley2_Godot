extends RigidBody2D
class_name B2_CombatActor

signal actor_created			## used during combat. ## NOTE Unused
signal actor_died				## used during combat.

signal stop_animation 			## Stop all active animations (Walking, attacking, dodging, etc) ## NOTE it this used?
signal destination_reached 		## Actor was moving, reached its destination.
signal set_played 				## Actor was playing some animation, but its done now.

signal state_changed			## emitted when the actor state (attack, aim, normal) changes.

## Actor state, shared betweem all actors.
enum STATE{
	NORMAL, 	## Normal state. Do normal stuff for the context
	ROLL, 		## Actor is currently rolling
	AIM, 		## Actor is Aiming at something
	SHOOT,		## Actor is shooting at something
	POINT, 		## Actor is pointing at something
	HIT, 		## Actor is being hit
	JUMP, 		## Actor is jumping
	DEFENDING, 	## Actor is defending
	VICTORY, 	## Turn-based Combat - Actor Won
	DEFEAT		## Turn-based Combat - Actor lost
	}
var prev_STATE := STATE.NORMAL
var curr_STATE := STATE.NORMAL :
	set(s) : 
		if not curr_STATE == s:
			prev_STATE = curr_STATE
			curr_STATE = s
			state_changed.emit()

## Cinema Movement
@export var ActorAnim 			: AnimatedSprite2D
@export var ActorAudioPlayer	: AudioStreamPlayer2D
@export var ActorNav 			: NavigationAgent2D
@export var ActorCol 			: CollisionShape2D

## Speed stuff
var speed_multiplier 		:= 10000.0 # was 900.0
var speed_slow 				:= 2.0 * speed_multiplier # was 1.5
var speed_normal 			:= 9.5 * speed_multiplier # was 2.5
var speed_fast 				:= 9.5 * speed_multiplier # was 5.0
var speed 					:= speed_normal

# Movement
var external_velocity 	:= Vector2.ZERO
var velocity			:= Vector2.ZERO

@export_category("Movement Physics")
@export var walk_speed			:= 5000000
@export var roll_impulse		:= 25000
@export var walk_damp			:= 10.0
@export var roll_damp			:= 4.0

## Sets the actor AI. Hoopz should use a special "player" AI that handles user inputs.
@export_category("A.I") ## Artificial... Inteligence... -Neil Breen
@export var actor_ai 		: B2_AI

@export_category("Pathfinding")
@export var path_desired_distance 	= 4.0
@export var target_desired_distance = 4.0

@export_category("Animation")
@export var animation_speed 	:= 1.5			## Multiplier used on playset animations

var is_moving 		:= false ## The actor is moving somewhere.
var is_playingset 	:= false ## The actor is playing some animation.

var facing_vector			:= Vector2.DOWN ## Where the actor should look at

# Actions - Used By AIs
var curr_input 				:= Vector2.ZERO
var curr_aim				:= Vector2.ZERO
var last_direction 			:= Vector2.ZERO
var last_input 				:= Vector2.ZERO

# used to define the movement sprite
var movement_vector 		:= Vector2.ZERO
var real_movement_vector 	:= Vector2.ZERO
var last_movement_vector 	:= Vector2.ZERO

## stop processing damage.
var actor_is_dying 	:= false
var is_actor_dead	:= false

## Jump
var jump_tween : Tween
var jump_height := 32.0
var jump_speed	:= 0.35
var jump_target := Vector2.ZERO

#func apply_damage( _damage : float) -> void:
#	push_warning("Method not setup for node %s." % name)

func apply_curr_input( dir : Vector2 ) -> void:
	curr_input = dir
	
func apply_curr_aim( dir : Vector2 ) -> void:
	curr_aim = dir

## TODO
func _connect_ai_signals() -> void:
	if actor_ai:
		actor_ai.aim_trigger.connect( _ai_aim_ranged )
		actor_ai.melee_attack_trigger.connect( _ai_melee_attack )
		actor_ai.ranged_attack_trigger.connect( _ai_ranged_attack )
		actor_ai.roll_trigger.connect( _ai_roll_at )
		actor_ai.charge_trigger.connect( _ai_charge_at )
		actor_ai.jump_trigger.connect( _ai_jump )
	else:
		push_error("Actor AI not loaded on node %s." % name)

func _ai_ranged_attack( _enabled : bool ) -> void:
	pass
	
func _ai_melee_attack( _enabled : bool ) -> void:
	pass
	
func _ai_aim_ranged( _enabled : bool ) -> void:
	pass
	
func _ai_charge_at( _enabled : bool ) -> void:
	pass
	
func _ai_roll_at( _enabled : bool ) -> void:
	pass
	
func _ai_jump( _enabled : bool ) -> void:
	pass

## Handle the most basic animations
func normal_animation(_delta : float):
	var input := curr_input
	
	if input != Vector2.ZERO: # AI is moving the Actor
		if last_input != input:
			
			match input.round():
				Vector2.UP + Vector2.LEFT:			pass # hoopz_normal_body.play(WALK_NW)
				Vector2.UP + Vector2.RIGHT:			pass # hoopz_normal_body.play(WALK_NE)
				Vector2.DOWN + Vector2.LEFT:		pass # hoopz_normal_body.play(WALK_SW)
				Vector2.DOWN + Vector2.RIGHT:		pass # hoopz_normal_body.play(WALK_SE)
					
				Vector2.UP:							pass # hoopz_normal_body.play(WALK_N)
				Vector2.LEFT:						pass # hoopz_normal_body.play(WALK_W)
				Vector2.DOWN:						pass # hoopz_normal_body.play(WALK_S)
				Vector2.RIGHT:						pass # hoopz_normal_body.play(WALK_E)
					
				_: # Catch All
					print("Catch all, ", input)
	else:
		# AI is not moving the actor anymore
		pass
		
		var curr_direction : Vector2 = input
	
		# Update var
		last_direction = curr_direction
		
	# Update var
	last_input = input

## Used for pathfinding to a specific location
func set_movement_target(movement_target: Vector2):
	ActorNav.set_target_position(movement_target)

func cinema_jump( jump_offset := Vector2.ZERO ) -> void:
	if jump_tween: jump_tween.kill()
	jump_tween = create_tween()
	jump_tween.tween_callback( set.bind("curr_STATE", STATE.JUMP) )
	jump_tween.tween_callback( set.bind("jump_target", position + jump_offset) )
	jump_tween.tween_property( ActorAnim, "position:y", -jump_height, jump_speed ).set_trans(		Tween.TRANS_SINE)
	jump_tween.tween_property( ActorAnim, "position:y", 0.0, jump_speed ).set_trans(				Tween.TRANS_SINE)
	jump_tween.tween_callback( set.bind("curr_STATE", STATE.NORMAL) )
	jump_tween.tween_callback( set.bind("last_input", Vector2.INF) )					## Reset last input (For animations)

func cinema_lookat( target_node : Node2D ) -> void:
	var _direction := position.direction_to( target_node.position ).round()
	cinema_look( _direction )
	
func cinema_look( _direction : Vector2 ) -> void:
	movement_vector = _direction
	
func cinema_moveto( _target_spot : Vector2, _speed : String ) -> void:
	## NOTE 27/02/25 Copied this from the B2_Actor script, with small changes.
	assert( is_instance_valid(ActorNav), "ActorNav not valid for node %s." % name ) ## FIXME
	match _speed:
		"MOVE_FAST": 	speed = speed_fast
		"MOVE_SLOW": 	speed = speed_slow
		"MOVE_NORMAL":	speed = speed_normal
		
	if _target_spot is Vector2:
		set_movement_target( _target_spot )
		
		is_moving 				= true
		real_movement_vector 	= position.direction_to( _target_spot )
		movement_vector 		= real_movement_vector.round()
		ActorCol.call_deferred("set_disabled", true) # Disable collision while moving

func cinema_playset( _sprite_frame : String, _sprite_frame_2 : String, _speed := 10.0, _dis_flip := false ): ## NOTE Not sure how to deal with this?
	if ActorAnim.sprite_frames.has_animation( _sprite_frame ):
		is_playingset = true
		ActorAnim.animation = _sprite_frame
		#flip_sprite()
		ActorAnim.sprite_frames.set_animation_loop( _sprite_frame, false )
		ActorAnim.sprite_frames.set_animation_speed( _sprite_frame, _speed )
		ActorAnim.play( _sprite_frame )
		await ActorAnim.animation_finished # Play set and wait for the animation to finish
	else:
		push_error("Actor " + str(self) + ": cinema_playset() " + _sprite_frame + " not found" )
		ActorAnim.animation_finished.emit() 	# Emit signals to avoid deadlocking the script.
		set_played.emit() 						# Emit signals to avoid deadlocking the script.
		
	if ActorAnim.sprite_frames.has_animation( _sprite_frame_2 ):
		ActorAnim.stop()
		ActorAnim.animation = _sprite_frame_2
		#flip_sprite()
		is_playingset = false
		set_played.emit()
	else:
		push_error("Actor " + str(self) + ": cinema_playset() " + _sprite_frame_2 + " not found" )
		is_playingset = false
		ActorAnim.animation_finished.emit() 	# Emit signals to avoid deadlocking the script.
		set_played.emit() 						# Emit signals to avoid deadlocking the script.
	return

## Function checks if the node is doing anything
## Return void right awai if its idle. Await for a signal if its busy.
func check_actor_activity() -> void:
	if is_moving:
		# is moving toward something.
		await destination_reached
		return
	elif is_playingset:
		# is playing some animation.
		await set_played
		return
	else:
		# not doing anything important
		return

## Combat stuff

func damage_actor( _damage : float, _force : Vector2 ) -> void:
	push_warning("Damage behaviour not set for actor %s. Doing nothing." % self.name )
	_after_damage()

func _after_damage() -> void:
	pass

func destroy_actor() -> void:
	push_warning("Death behaviour not set for actor %s. Doing nothing." % self.name )
	_before_death()
	_after_death()

func _before_death() -> void:
	pass

func _after_death() -> void:
	pass

func _on_velocity_computed( safe_velocity: Vector2 ):
	apply_central_force( safe_velocity )
	last_movement_vector = movement_vector
	
## Default behaviour for Combat actors. Overide this to change its behaviour.
func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
	_process_movement( delta )
	
func _process_movement( _delta : float ) -> void:
	## NOTE 27/02/25 Copied this from the B2_Actor script, with small changes.
		
	if is_moving:
		# Do not query when the map has never synchronized and is empty.
		if NavigationServer2D.map_get_iteration_id( ActorNav.get_navigation_map() ) == 0:
			return
		
		if ActorNav.is_target_reached() or ActorNav.is_navigation_finished(): # Finish navigation
			is_moving = false
			ActorCol.call_deferred("set_disabled", false) 	# Reenable the collision.
			destination_reached.emit()
			return
			
		var next_path_position: Vector2 = ActorNav.get_next_path_position()
		var new_velocity: Vector2 = global_position.direction_to( next_path_position ) * ( speed / Engine.time_scale ) # This "Engine.time_scale" is used when the game is FFWDing. Actors used to have issues reaching the waypoint without this.
		
		## Update movement vector for animation purposes.
		real_movement_vector 	= position.direction_to( next_path_position )
		movement_vector 		= real_movement_vector.round()
		
		if ActorNav.avoidance_enabled:
			ActorNav.set_velocity(new_velocity)
		else:
			_on_velocity_computed(new_velocity)
