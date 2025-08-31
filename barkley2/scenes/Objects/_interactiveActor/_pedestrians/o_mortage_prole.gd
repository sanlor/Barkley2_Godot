@icon("res://barkley2/assets/b2_original/images/merged/s_pedestrianIcon.png")
extends RigidBody2D
class_name B2_Pedestrian_Mortgage
## Special version of a pedestrian, used in the Mortgage minigame.

# List of sprites that the peds can use.
const PED_SPRITES := [
	"res://barkley2/resources/B2_Pedestrians/s_ped_01.tres",
	"res://barkley2/resources/B2_Pedestrians/s_ped_02.tres",
	"res://barkley2/resources/B2_Pedestrians/s_ped_03.tres",
	"res://barkley2/resources/B2_Pedestrians/s_ped_04.tres",
	"res://barkley2/resources/B2_Pedestrians/s_ped_05.tres",
	"res://barkley2/resources/B2_Pedestrians/s_ped_06.tres",
	"res://barkley2/resources/B2_Pedestrians/s_ped_07.tres",
	"res://barkley2/resources/B2_Pedestrians/s_ped_08.tres",
	"res://barkley2/resources/B2_Pedestrians/s_ped_09.tres",
	"res://barkley2/resources/B2_Pedestrians/s_ped_10.tres",
	"res://barkley2/resources/B2_Pedestrians/s_ped_11.tres",
	"res://barkley2/resources/B2_Pedestrians/s_ped_12.tres",
	"res://barkley2/resources/B2_Pedestrians/s_ped_13.tres",
	"res://barkley2/resources/B2_Pedestrians/s_ped_14.tres",
	"res://barkley2/resources/B2_Pedestrians/s_ped_15.tres",
	"res://barkley2/resources/B2_Pedestrians/s_ped_16.tres",
	"res://barkley2/resources/B2_Pedestrians/s_ped_18.tres",
	"res://barkley2/resources/B2_Pedestrians/s_ped_20.tres",
	"res://barkley2/resources/B2_Pedestrians/s_ped_22.tres",
	"res://barkley2/resources/B2_Pedestrians/s_ped_24.tres",
	"res://barkley2/resources/B2_Pedestrians/s_ped_26.tres",
	"res://barkley2/resources/B2_Pedestrians/s_ped_28.tres",
	"res://barkley2/resources/B2_Pedestrians/s_ped_30.tres",
]

signal destination_reached

enum {ON_QUEUE,ON_COUNTER,LEAVING}
var ped_state := ON_QUEUE

## Debug
var debug := true

@export_category("Actor Stuff")
@export var my_shadow 		: Sprite2D
@export var ActorAnim 		: AnimatedSprite2D
@export var has_collision 	:= true
@export var ActorCol 		: CollisionShape2D
@export var ActorNav		: NavigationAgent2D

@export_category("Movement Stuff")
## Speed stuff
var speed_multiplier 		:= 20000.0 # was 900.0
@export var speed_slow 		:= 12.0 # was 1.5
@export var speed_normal 	:= 20.0 # was 2.5
@export var speed_fast 		:= 35.0 # was 5.0
var speed 					:= speed_normal

@export_category("Pathfinding")
@export var path_desired_distance 	= 4.0
@export var target_desired_distance = 4.0

@export_category("Animation")
@export var animation_speed 	:= 1.5			## Multiplier used on playset animations

## Node that controls this minigame.
var o_mg_wait_control01 : Sprite2D
var office_exit_path	: Array[Node2D]    ## Also known as "ped_gestation_and_incineration_stop". where a ped should head to exit the map.

var is_moving 			:= false
#var is_leaving			:= false			## Ped is leaving the office.
var playing_animation 	:= "stand"

#var destination 			:= Vector2.ZERO
#var destination_path 		:= PackedVector2Array()
#var destination_offset 		:= Vector2.ZERO # Vector2(8,8)

# used to define the movement sprite
var movement_vector 		:= Vector2.ZERO
var real_movement_vector 	:= Vector2.ZERO
var last_movement_vector 	:= Vector2.ZERO

var velocity				:= Vector2.ZERO

## List of spots that the actor must follow.
var my_target_list			:= []
var my_target_index			:= 0
var my_curr_target			: Node2D	# <- Where the ped wants to go
var my_last_target			: Node2D	# <- Where the ped is currently at.

## if another person is in my target, flip this var and wait.
var is_waiting_for_spot_vacancy := false

func _ready() -> void:
	if Engine.is_editor_hint():				return
	if not get_parent() is B2_ROOMS:		return
	assert( o_mg_wait_control01, "Forgot to set the most important node ('o_mg_wait_control01'), dumbass.")
		
	## Chillax.
	await get_tree().process_frame
	await get_tree().process_frame
		
	# Do some setup for the ped, mostly checking if the nodes are set correctly.
	_setup_actor()
	
	# Randomish speed for each ped
	speed *= randf_range(0.85, 1.15)
	
	## Randomize the sprite
	_change_costume()
	
	## Connect signals.
	o_mg_wait_control01.line_move_requested.connect( _move_line )
	
func _setup_actor():
	if not is_instance_valid( ActorAnim ):
		ActorAnim 	= get_node( "ActorAnim" )
	if not is_instance_valid( ActorCol ):
		ActorCol 	= get_node( "ActorCol" )
	if not is_instance_valid( ActorNav):
		ActorNav	= get_node( "ActorNav" )
	if is_instance_valid( ActorNav ): # Setup NavigationAgent2D
		ActorNav.path_desired_distance 			= path_desired_distance
		ActorNav.target_desired_distance 		= target_desired_distance
		ActorNav.velocity_computed.connect( Callable(_on_velocity_computed) )
		ActorNav.debug_enabled = B2_Debug.PATHFIND_SHOW
	else:
		push_error( "ActorNav is invalid for node %s." % name )
	
	if is_instance_valid( ActorAnim ):
		ActorAnim.use_parent_material = true ## Shader stuff
	else:
		push_error( "ActorAnim is invalid for node %s." % name )
		
	if not is_instance_valid( ActorCol ):
		push_error( "ActorCol is invalid for node %s." % name )
		
func set_target( target : Node2D ) -> void:
	is_moving = true
	my_curr_target = target
	my_last_target = target
	_move_to( my_curr_target.global_position )
		
func set_target_list( target_list : Array ) -> void:
	my_target_index = 0
	my_target_list = target_list
	my_curr_target = my_target_list[my_target_index]
	my_last_target = my_curr_target
	is_moving = true
	_move_to( my_curr_target.global_position )
		
func _change_costume():
	randomize()
	var costume : SpriteFrames = load( PED_SPRITES.pick_random() )
	ActorAnim.sprite_frames = costume
	
	# o_pedestrianActor - create - line 61
	if randi_range(0, 99) <= 30:
		speed *= randf_range( 0.85, 1.15 )
	
	movement_vector 		= Vector2.ZERO
	last_movement_vector 	= Vector2.ZERO
	
func _ped_animation(): # Apply animation when the character is moved by a cinema script.
	var _dir := "stand"
			
	if is_moving:
		match movement_vector:
			Vector2.UP + Vector2.LEFT: 		_dir = "walk_sideways"
			Vector2.UP + Vector2.RIGHT: 	_dir = "walk_sideways"
			Vector2.DOWN + Vector2.LEFT: 	_dir = "walk_sideways"
			Vector2.DOWN + Vector2.RIGHT: 	_dir = "walk_sideways"
				
			Vector2.UP: 		_dir = "walk_S" ## NOTE I goofed during the convertion proccess. N is S and S is N. No way im converting everything again.
			Vector2.LEFT: 		_dir = "walk_sideways"
			Vector2.DOWN: 		_dir = "walk_N" ## NOTE I goofed during the convertion proccess. N is S and S is N. No way im converting everything again.
			Vector2.RIGHT: 		_dir = "walk_sideways"
		
	if movement_vector.x < 0:
		ActorAnim.flip_h = true
	else:
		ActorAnim.flip_h = false
		
	if playing_animation != _dir:
		ActorAnim.play(_dir, animation_speed)
		playing_animation = _dir
		
	if _dir == "stand": 
		ActorAnim.stop()
		ActorAnim.animation = _dir
		match last_movement_vector:
			Vector2.UP + Vector2.LEFT: 		ActorAnim.frame = 1
			Vector2.UP + Vector2.RIGHT: 	ActorAnim.frame = 1
			Vector2.DOWN + Vector2.LEFT: 	ActorAnim.frame = 0
			Vector2.DOWN + Vector2.RIGHT: 	ActorAnim.frame = 0
				
			Vector2.UP: 		ActorAnim.frame = 1
			Vector2.LEFT: 		ActorAnim.frame = 2
			Vector2.DOWN: 		ActorAnim.frame = 0
			Vector2.RIGHT: 		ActorAnim.frame = 2
		
	last_movement_vector 	= movement_vector
	movement_vector 		= velocity.normalized().round()
	
func _on_velocity_computed(safe_velocity: Vector2):
	velocity = safe_velocity
	apply_central_force( velocity )
	_ped_animation()

func _move_to( _position : Vector2 ) -> void:
	ActorNav.set_target_position( _position )

func _move_line() -> void:
	## Ped should be stopped, on the counter.
	if ped_state == ON_COUNTER:
		## The ped **SHOULD** be in the 13 spot.
		if my_curr_target.name == "o_mg_wait_spot13":
			if debug: print(office_exit_path)
			ped_state = LEAVING
			#is_waiting_for_spot_vacancy = false ## <- sometimes the var stayied as true, for some reason.
			set_target_list( office_exit_path )
	

func _ped_stopped_moving() -> void:
	is_moving = false
	movement_vector = o_mg_wait_control01.get_ped_face_direction( my_last_target )
	last_movement_vector = movement_vector
	_ped_animation()

## Select next queue stop.
func _set_next_spot() -> void:
	my_last_target = my_curr_target
	if my_target_index + 1 < my_target_list.size():
		my_target_index += 1
		my_curr_target = my_target_list[my_target_index]
	else: print("OOB")

## Return true if all destinetions were reached.
func _is_at_destination() -> bool:
	return my_target_index + 1 >= my_target_list.size()

## This is a mess. Im was working on this for a few days, 15 minutes at a time.
func _physics_process(delta: float) -> void:
	# Do not query when the map has never synchronized and is empty.
	if NavigationServer2D.map_get_iteration_id( ActorNav.get_navigation_map() ) == 0:
		return
	
	match ped_state:
		ON_QUEUE:
			if is_waiting_for_spot_vacancy:
				
				if my_last_target:
					## Avoid situations where the player tries to cut in line.
					global_position = global_position.lerp( my_last_target.global_position, 5.0 * delta )
					
				if my_curr_target and my_curr_target is B2_MiniGame_Mortage_Spot:
					## check if the next spot is occupied.
					if my_curr_target.can_enter():
						if debug: print("target cleared for entry: ", my_curr_target.name)
						is_waiting_for_spot_vacancy = false
						is_moving = true
						_move_to( my_curr_target.global_position )
				else:
					push_error( my_curr_target.name )
					## weird situation.
					breakpoint
			
			# Finish navigation
			if ActorNav.is_target_reached():
				## Check if there is any new target.
				if not _is_at_destination():
					## Check if the ped can move to the next spot
					if my_curr_target.global_position.distance_to( global_position ) < 2.0:
						_set_next_spot()
						
						assert( my_curr_target, "Null target." )
						if debug: print("curr target: ", my_curr_target.name)
						
						## Check if the spot is free.
						if my_curr_target.can_enter():
							_move_to( my_curr_target.global_position ) ## It is, move torward it.
							if debug: print("Move torward ", my_curr_target.name)
							
						else: ## Its not, wait for it to be free.
							is_waiting_for_spot_vacancy = true
							_ped_stopped_moving()
							if debug: print("wait ", is_waiting_for_spot_vacancy)
							
				else: ## Reached final destination. Chillout.
					if is_moving:
						velocity = Vector2.ZERO
						_ped_stopped_moving()
						is_waiting_for_spot_vacancy = false
						ped_state = ON_COUNTER
						destination_reached.emit()
						if debug: print( "Mortgage ped %s reached its target %s." % [name, my_curr_target.name] )
			
		ON_COUNTER:
			global_position = global_position.lerp( my_curr_target.global_position, 10.0 * delta )
			movement_vector = Vector2.UP
			_ped_animation()
			return ## Do nothing beyond the above.
			
		LEAVING:
			# Finish navigation
			if my_curr_target.global_position.distance_to( global_position ) < 5.0:
				if _is_at_destination():
					queue_free()
				else:
					_set_next_spot()
					_move_to( my_curr_target.global_position )
		
	if ActorNav.is_navigation_finished():
		return
		
	## Lets move.
	var next_path_position: Vector2 = ActorNav.get_next_path_position()
	var new_velocity: Vector2 = global_position.direction_to( next_path_position ) * ( speed * speed_multiplier ) 
	
	## Legacy stuff. avoidance should not be anabled.
	if ActorNav.avoidance_enabled:
		ActorNav.set_velocity( new_velocity )
	else:
		_on_velocity_computed( new_velocity )
