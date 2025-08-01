extends RigidBody2D
class_name B2_CombatActor

signal actor_died				## used during combat.

signal stop_animation 			## Stop all active animations (Walking, attacking, dodging, etc) ## NOTE it this used?
signal destination_reached 		## Actor was moving, reached its destination.
signal set_played 				## Actor was playing some animation, but its done now.

signal state_changed			## emitted when the actor state (attack, aim, normal) changes.

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

#func apply_damage( _damage : float) -> void:
#	push_warning("Method not setup for node %s." % name)

## Used for pathfinding to a specific location
func set_movement_target(movement_target: Vector2):
	ActorNav.set_target_position(movement_target)

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

func damage_actor( _damage : int, _force : Vector2 ) -> void:
	push_warning("Damage behaviour not set for actor %s. Doing nothing." % self.name )
	_after_damage()

func _after_damage() -> void:
	pass

func destroy_actor() -> void:
	push_warning("Death behaviour not set for actor %s. Doing nothing." % self.name )
	_after_death()

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
