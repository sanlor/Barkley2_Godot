@icon("res://barkley2/assets/b2_original/images/merged/s_pedestrianIcon.png")
extends RigidBody2D
class_name B2_Pedestrian_Mortgage
## Special version of a pedestrian, used in the Mortgage minigame.
# 31-08-25 - OK, this sucks. I keep overcomplicating this. My main issue is that this object is quite different from the original game.
# I cant just port the code from GML to godot. Right now, im trying to simplify this.

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

enum {ON_QUEUE, LEAVING}
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
# var my_target_index			:= 0												# 31-09-25 Disabled this.
var my_curr_target			: Node2D	# <- Where the ped wants to go
# var my_last_target			: Node2D	# <- Where the ped is currently at. 	# 31-09-25 Disabled this.

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
	# o_mg_wait_control01.line_move_requested.connect( _move_line ) # 31-09-25 Disabled this.
	
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
	#is_moving = true
	my_curr_target = target
	_move_to( my_curr_target.global_position )
		
func set_target_list( target_list : Array ) -> void:
	ped_state = LEAVING
	my_target_list = target_list
	my_curr_target = my_target_list.pop_front()
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
	is_moving = true
	apply_central_force( velocity )
	_ped_animation()

func _move_to( _position : Vector2 ) -> void:
	ActorNav.set_target_position( _position )

func _ped_stopped_moving() -> void:
#	velocity = Vector2.ZERO
	is_moving = false
#	last_movement_vector = movement_vector
	_ped_animation()

## This is a mess. Im was working on this for a few days, 15 minutes at a time.
func _physics_process(delta: float) -> void:
	# Do not query when the map has never synchronized and is empty.
	if NavigationServer2D.map_get_iteration_id( ActorNav.get_navigation_map() ) == 0:
		return
	
	match ped_state:
		ON_QUEUE:
			## Check if the ped can move to the next spot
			if not my_curr_target.can_enter( self ):
				#_ped_stopped_moving()
				return
				
			# Finish navigation
			if my_curr_target.global_position.distance_to( global_position ) < 5.0:
				_ped_stopped_moving()
				global_position = global_position.lerp( my_curr_target.global_position, 5.0 * delta )
				movement_vector = o_mg_wait_control01.get_ped_face_direction( my_curr_target )
			
		LEAVING:
			# Finish navigation
			if my_curr_target.global_position.distance_to( global_position ) < 5.0:
				if my_target_list.is_empty():
					o_mg_wait_control01.unregister_ped(self)
					queue_free()
				else:
					my_curr_target = my_target_list.pop_front()
					_move_to( my_curr_target.global_position )
		
	if ActorNav.is_target_reached():
		return
		
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
