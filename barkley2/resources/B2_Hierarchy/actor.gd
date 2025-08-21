extends CharacterBody2D
#extends Node2D
class_name B2_Actor

signal sprite_offset_centered
signal sprite_collision_adjusted

const O_SHADOW = preload("res://barkley2/scenes/Objects/System/o_shadow.tscn")

## DEBUG
@export_category("Debug")
@export var debug_move_finish 				:= false ## Print some debug shit.
@export var debug_check_movement_vector 	:= false ## Draw lines to show the current movement vector.

## Godot
signal destination_reached
signal set_played

@export_category("Actor Stuff")
@export var cast_shadow		:= true
@export var ActorAnim 		: AnimatedSprite2D
@export var flip_h			:= false				## Start with the sprite flipped.
@export var has_collision 	:= true
@export var ActorCol 		: CollisionShape2D
@export var can_move_around	:= true
@export var ActorNav		: NavigationAgent2D

# True if the sprite is using automatic animations (like when it is moving), or false otherwise.
@export var _automatic_animation 	:= false; ## Start playing a animation during room load ## CRITICAL ## it overrides any animations set on _ready().
# The animation to use if automatic animation isn't true. 
@export var _current_animation 		:= "default" ## What animation should blay at room load? ## CRITICAL ## it overrides any animations set on _ready().

var my_shadow 		: Sprite2D

var is_moving 		:= false
var is_playingset 	:= false

var destination 			:= Vector2.ZERO
var destination_path 		:= PackedVector2Array()
var destination_offset 		:= Vector2.ZERO # Vector2(8,8)

# used to define the movement sprite
var movement_vector 		:= Vector2.ZERO :
	set(m):
		movement_vector = m
		#print("Movement Vector updated to %s." % m)
var real_movement_vector 	:= Vector2.ZERO
var last_movement_vector 	:= Vector2.ZERO

@export_category("Movement Stuff")
## Speed stuff
var speed_multiplier 	:= 20.0
var speed_slow 			:= 2.0 * speed_multiplier # was 1.5
var speed_normal 		:= 3.0 * speed_multiplier # was 2.5
var speed_fast 			:= 6.0 * speed_multiplier # was 5.0
var speed 				:= speed_normal

@export_category("Pathfinding")
@export var path_desired_distance 	= 4.0
@export var target_desired_distance = 4.0

@export_category("Animation")
@export var animation_speed 	:= 1.5			## Multiplier used on playset animations
@export var disable_auto_flip_h	:= false		## Hoopz actor has 8 different directions, it should not mirror
## Animation
var ANIMATION_STAND 				:= "PLACEHOLDER - %s" % self
var ANIMATION_SOUTH 				:= "PLACEHOLDER - %s" % self
var ANIMATION_SOUTHEAST 			:= "PLACEHOLDER - %s" % self
var ANIMATION_SOUTHWEST 			:= "PLACEHOLDER - %s" % self
var ANIMATION_WEST 					:= "PLACEHOLDER - %s" % self
var ANIMATION_NORTH 				:= "PLACEHOLDER - %s" % self
var ANIMATION_NORTHEAST 			:= "PLACEHOLDER - %s" % self
var ANIMATION_NORTHWEST 			:= "PLACEHOLDER - %s" % self
var ANIMATION_EAST 					:= "PLACEHOLDER - %s" % self

## Which sprite index is used for the standing animation.
var ANIMATION_STAND_SPRITE_INDEX 	:= [ 0, 0, 0, 0, 0, 0, 0, 0 ] # N, NE, E, SE, S, SW, W, NW

## useat map
var useat_map := {
	Vector2.DOWN: 					"PLACEHOLDER - %s" % self,
	Vector2.DOWN + Vector2.LEFT: 	"PLACEHOLDER - %s" % self,
	Vector2.LEFT: 					"PLACEHOLDER - %s" % self,
	Vector2.UP + Vector2.LEFT: 		"PLACEHOLDER - %s" % self,
	Vector2.UP: 					"PLACEHOLDER - %s" % self,
	Vector2.UP + Vector2.RIGHT: 	"PLACEHOLDER - %s" % self,
	Vector2.RIGHT: 					"PLACEHOLDER - %s" % self,
	Vector2.DOWN + Vector2.RIGHT: 	"PLACEHOLDER - %s" % self,
}
var vec_2_dir_map := {
	Vector2.DOWN: 					"SOUTH",
	Vector2.DOWN + Vector2.LEFT: 	"SOUTHWEST",
	Vector2.LEFT: 					"WEST",
	Vector2.UP + Vector2.LEFT: 		"NORTHWEST",
	Vector2.UP: 					"NORTH",
	Vector2.UP + Vector2.RIGHT: 	"NORTHEAST",
	Vector2.RIGHT: 					"EAST",
	Vector2.DOWN + Vector2.RIGHT: 	"SOUTHEAST",
}
var dir_2_vec_map := {
	"SOUTH":			Vector2.DOWN,
	"SOUTHWEST":		Vector2.DOWN + Vector2.LEFT,
	"WEST":				Vector2.LEFT,
	"NORTHWEST":		Vector2.UP + Vector2.LEFT,
	"NORTH":			Vector2.UP,
	"NORTHEAST":		Vector2.UP + Vector2.RIGHT,
	"EAST":				Vector2.RIGHT,
	"SOUTHEAST":		Vector2.DOWN + Vector2.RIGHT,
}
## Action Queue
var cinema_set_queue := []

var playing_animation := ""

func _setup_actor():
	ready.connect( play_animations )
	if not is_instance_valid( ActorAnim ):
		ActorAnim 	= get_node( "ActorAnim" )
	if not is_instance_valid( ActorCol ):
		ActorCol 	= get_node( "ActorCol" )
	if can_move_around:
		if not is_instance_valid( ActorNav):
			ActorNav	= get_node( "ActorNav" )
		if is_instance_valid( ActorNav ): # Setup NavigationAgent2D <- done.
			ActorNav.path_desired_distance 		= path_desired_distance
			ActorNav.target_desired_distance 	= target_desired_distance
			ActorNav.velocity_computed.connect( Callable(_on_velocity_computed) )
			ActorNav.debug_enabled = B2_Debug.PATHFIND_SHOW
		else:
			push_error( "ActorNav is invalid for node %s." % name )
	else:
		## Remove unnecessary nodes.
		if is_instance_valid( ActorNav ):
			ActorNav.queue_free()
	
	if is_instance_valid( ActorAnim ):
		ActorAnim.use_parent_material = true ## Shader stuff
	else:
		push_error( "ActorAnim is invalid for node %s." % name )
		
	if not is_instance_valid( ActorCol ):
		push_error( "ActorCol is invalid for node %s." % name )
		
	## Set collision layers and masks.
	collision_layer 	= 5
	collision_mask 		= 1 + 2 + 3 + 5 + 19 + 20 + 21
		
	if cast_shadow:
		my_shadow = O_SHADOW.instantiate()
		add_child( my_shadow, true)



func play_animations():
	if _automatic_animation:
		if ActorAnim.sprite_frames.has_animation(_current_animation):
			ActorAnim.play(_current_animation, animation_speed)
		else:
			push_warning( "%s has no animation called %s." % [ name, _current_animation ] )
	
	# try to run this as late as possible
	ActorAnim.flip_h = flip_h

# Check if the actor is inside a building. return false if the parent is not B2_ROOMS
func is_inside_room() -> bool:
	if get_parent() is B2_ROOMS:
		return get_parent().is_interior
	else:
		return false
		
# Get the room area. return "unknow" if the parent is not B2_ROOMS
func get_room_area() -> String:
	if get_parent() is B2_ROOMS:
		var room_name : String = get_parent().name
		if room_name.begins_with("r_") and room_name.count("_", 0, 6) >= 2:
			var area := room_name.get_slice( "_", 1 ) # r_tnn_residentialDistrict01 > tnn
			return area
		else:
			push_warning("Room name is not standard. fix this.")
			
	push_warning("Parent is not a B2_ROOMS.")
	return "unknown"
	
# Get the room name. return "unknow" if the parent is not B2_ROOMS
func get_room_name() -> String:
	if get_parent() is B2_ROOMS:
		return get_parent().name
	else:
		push_warning("Parent is not a B2_ROOMS.")
		return "unknown"

# SURPRISEAT()
func cinema_surpriseat( target ):
	cinema_useat( target, "surprise", "surpriseHold", 0.75 )
	
# KNEELAT()
func cinema_kneelat( target ):
	cinema_useat( target, "kneelHold", "kneelHold", 0.75 )

# USEAT()
func cinema_useat( target, force_new_anim := "action_", force_hold_anim := "", force_speed := 1.0 ) -> void:
	# what a mess. target can be a string or a node.
	assert(target != null, "Null? NULL? Why null?")
	var looking_at := movement_vector
	var prefix := ""
	if B2_CManager.curr_BODY == B2_CManager.BODY.DIAPER: prefix = "diaper_" ## What a mess. This is a port of the original code. not really want to change how it works.
	var dir : Vector2
	if target 		is String:
		if not dir_2_vec_map.has(target): push_warning("no target called %s." % target) ## Debug
		dir = dir_2_vec_map.get(target, Vector2.DOWN) as Vector2
	elif target 	is Node2D:
		dir = position.direction_to(target.position).round() # sign()
	else:
		push_warning( "Which USEAT anim is this? ", target )
		breakpoint
		
	movement_vector = dir # Is this needed? Used to help flip the sprite, sometimes.
	#print("USEAT dir: %s." % dir)
	ActorAnim.flip_h = false
	if not disable_auto_flip_h: 
		if dir.x < 0: ActorAnim.flip_h = true # Flip sprite if its looking left. 
		
	if not useat_map.has(dir): push_warning("no dir called %s." % dir) ## Debug
	var old_anim 	:= prefix + force_hold_anim + useat_map.get(dir, "S") as String ## action_S as the catch all.
	var old_frame 	:= 0
	if force_hold_anim.is_empty():
		old_anim 	= ActorAnim.animation
		old_frame 	= ActorAnim.frame # Standing anim fix
		
	var new_anim 	:= prefix + force_new_anim + useat_map.get(dir, "S") as String ## action_S as the catch all.
		
	assert( ActorAnim.sprite_frames.has_animation(new_anim) )
	assert( ActorAnim.sprite_frames.has_animation(old_anim) )
		
	ActorAnim.sprite_frames.set_animation_loop( new_anim, false )
	ActorAnim.sprite_frames.set_animation_loop( old_anim, false )
	
	#print("USEAT anim: %s." % new_anim)
	cinema_playset( new_anim, old_anim, 10.0 * force_speed, disable_auto_flip_h )
	await ActorAnim.animation_finished
	
	## 25-12-24 vvv
	#cinema_look( vec_2_dir_map.get( dir, "SOUTH" ) ) # 24/07/25 disabled this.
	
	#ActorAnim.frame = old_frame # <- is this needed?
	
	return

func cinema_set( _sprite_frame : String ):
	if is_moving:
		push_warning("Warning: Cant change %s´s animation while actor is moving.", name)
		
	# reset movement vector. Is this needed?
	movement_vector 		= Vector2.ZERO
	last_movement_vector 	= Vector2.ZERO
	real_movement_vector	= Vector2.ZERO
	
	if ActorAnim.sprite_frames.has_animation(_sprite_frame):
		ActorAnim.animation = _sprite_frame
		adjust_sprite_offset()
	else:
		push_error("Actor " + str(self) + ": cinema_set() " + _sprite_frame + " not found" )

func cinema_playset( _sprite_frame : String, _sprite_frame_2 : String, _speed := 10.0, _dis_flip := false ): ## NOTE Not sure how to deal with this?
	if ActorAnim.sprite_frames.has_animation( _sprite_frame ):
		is_playingset = true
		ActorAnim.animation = _sprite_frame
		adjust_sprite_offset()
		flip_sprite()
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
		adjust_sprite_offset()
		flip_sprite()
		is_playingset = false
		set_played.emit()
	else:
		push_error("Actor " + str(self) + ": cinema_playset() " + _sprite_frame_2 + " not found" )
		is_playingset = false
		ActorAnim.animation_finished.emit() 	# Emit signals to avoid deadlocking the script.
		set_played.emit() 						# Emit signals to avoid deadlocking the script.
	return

func cinema_lookat( target_node : Node2D ):
	var _direction := position.direction_to( target_node.position ).round()
	var dir_name := vec_2_dir_map.get( _direction, "SOUTH" ) as String
	cinema_look( dir_name )

func cinema_look( _direction : String ):
	ActorAnim.stop()
	
	if not ActorAnim.sprite_frames.has_animation(ANIMATION_STAND):
		push_error("Node %s has no animation called %s for %s. You don goofed." % [name, ANIMATION_STAND, _direction] )
		return
		
	ActorAnim.animation = ANIMATION_STAND
	match _direction:
		"NORTH": 		ActorAnim.frame = ANIMATION_STAND_SPRITE_INDEX[0]
		"NORTHEAST": 	ActorAnim.frame = ANIMATION_STAND_SPRITE_INDEX[1]
		"EAST": 		ActorAnim.frame = ANIMATION_STAND_SPRITE_INDEX[2]
		"SOUTHEAST": 	ActorAnim.frame = ANIMATION_STAND_SPRITE_INDEX[3]
		"SOUTH": 		ActorAnim.frame = ANIMATION_STAND_SPRITE_INDEX[4]
		"SOUTHWEST": 	ActorAnim.frame = ANIMATION_STAND_SPRITE_INDEX[5]
		"WEST": 		ActorAnim.frame = ANIMATION_STAND_SPRITE_INDEX[6]
		"NORTHWEST": 	ActorAnim.frame = ANIMATION_STAND_SPRITE_INDEX[7]
			
	real_movement_vector = dir_2_vec_map.get( _direction, Vector2.DOWN) ## Default is South
	movement_vector =  real_movement_vector.round()
	
	ActorAnim.flip_h = false
	if not disable_auto_flip_h: flip_sprite()
	adjust_sprite_offset()
	
func cinema_moveto( _target_spot, _speed : String ):
	assert( is_instance_valid(ActorNav), "ActorNav not valid for node %s." % name )
	
	# Default behaviour
	match _speed:
		"MOVE_FAST": speed = speed_fast
		"MOVE_SLOW": speed = speed_slow
		"MOVE_NORMAL": speed = speed_normal
	
	if _target_spot == null:
		push_error(name, ": node is invalid. ", _target_spot, ".")
	# _target_spot can be eiher a node (Cinema Spot) or a position. What a mess.
	elif _target_spot is Node2D or _target_spot is Vector2:
		
		if _target_spot is Vector2:	destination 		= _target_spot
		else:						destination 		= _target_spot.position
			
		set_movement_target( destination )
		
		is_moving 				= true
		real_movement_vector 	= position.direction_to( destination )
		movement_vector 		= real_movement_vector.round()
		ActorCol.call_deferred("set_disabled", true) # Disable collision while moving
	return

func force_flip( flip : bool ) -> void:
	ActorAnim.flip_h = flip

func flip_sprite( ):
	if disable_auto_flip_h: ## DEBUG
		return 
	if real_movement_vector.x > 0: # handle sprite mirroring
		ActorAnim.flip_h = false
	elif real_movement_vector.x < 0:
		ActorAnim.flip_h = true
	else:
		pass # movement_vector.x == 0, do nothing

func cinema_animation(): # Apply animation when the character is moved by a cinema script.
	#if movement_vector != last_movement_vector:
	var _dir := ANIMATION_SOUTH
			
	match movement_vector:
		Vector2.UP + Vector2.LEFT: 		_dir = ANIMATION_NORTHWEST
		Vector2.UP + Vector2.RIGHT: 	_dir = ANIMATION_NORTHEAST
		Vector2.DOWN + Vector2.LEFT: 	_dir = ANIMATION_SOUTHWEST
		Vector2.DOWN + Vector2.RIGHT: 	_dir = ANIMATION_SOUTHEAST
			
		Vector2.UP: 		_dir = ANIMATION_NORTH
		Vector2.LEFT: 		_dir = ANIMATION_WEST
		Vector2.DOWN: 		_dir = ANIMATION_SOUTH
		Vector2.RIGHT: 		_dir = ANIMATION_EAST
		
	if playing_animation != _dir:
		if not disable_auto_flip_h:
			flip_sprite()
		else:
			ActorAnim.flip_h = false
				
		ActorAnim.play(_dir, animation_speed)
		last_movement_vector = movement_vector ## Old method
		playing_animation = _dir
		
		adjust_sprite_offset()

func get_curr_sprite_metadata(curr_anim) -> Dictionary:
	var sprite_data := ActorAnim.get_meta( curr_anim, Dictionary() ) as Dictionary
	
	if sprite_data.is_empty():
		#push_error("Ops, %s's AnimatedSprite2D has no metadata. Cant change the sprite offset like this." % ActorAnim.get_parent().name)
		return sprite_data
	if not sprite_data.has("xorig") and not sprite_data.has("yorigin"):
		push_error("Ops, %s's AnimatedSprite2D has invalid metadata info." % ActorAnim.get_parent().name)
		return sprite_data
	return sprite_data

# Get info from the sprite metadata.
func adjust_sprite_offset():
	var curr_anim := ActorAnim.animation
	var sprite_data := get_curr_sprite_metadata(curr_anim)
	if sprite_data.is_empty():
		# no data
		return
		
	ActorAnim.centered = false
	ActorAnim.offset = -Vector2( int( sprite_data["xorig"] ), int( sprite_data["yorigin"] ) )
	# Some sprites arent centered. if you just flipt it, they are displaied incorrectly.
	if ActorAnim.flip_h:
		## CRITICAL I hate math. This may cause issues with animations later. careful.
		ActorAnim.offset.x = int( sprite_data["xorig"] ) - int( sprite_data["width"] )
	sprite_offset_centered.emit()
	
	if has_collision:
		adjust_sprite_collision()
	
# Get info from the sprite metadata.
func adjust_sprite_collision():
	var curr_anim := ActorAnim.animation
	var sprite_data := get_curr_sprite_metadata(curr_anim)
	if sprite_data.is_empty():
		# no data
		return
	# Not being able to un-center the collision shape is terrible. # https://github.com/godotengine/godot-proposals/issues/1170
	## NOTE Disabled bellow. not sure how to use it yet.
	# ActorCol.position = Vector2( int( sprite_data["bbox_left"] ), int( sprite_data["bbox_top"] ) ) + shape.size / 2.0
	var shape := CircleShape2D.new()
	shape.radius = 10 # 10 is arbitrary.
	shape.radius = ( float( sprite_data["bbox_right"] ) - float( sprite_data["bbox_left"] ) ) / PI # ooh look at me, all fancy using PI and such.
	
	## NOTE 2 - Fuck, I have no idea how Collisions are handled on the original game. Its circles now, every actor has a cicle as collision shape. fuck it.
	ActorCol.call_deferred("set_shape", shape )
	sprite_collision_adjusted.emit()
	
func execute_event_user_0(): 	push_warning("%s: Event not set" % name)
func execute_event_user_1(): 	push_warning("%s: Event not set" % name)
func execute_event_user_2(): 	push_warning("%s: Event not set" % name)
func execute_event_user_3(): 	push_warning("%s: Event not set" % name)
func execute_event_user_4(): 	push_warning("%s: Event not set" % name)
func execute_event_user_5(): 	push_warning("%s: Event not set" % name)
func execute_event_user_6(): 	push_warning("%s: Event not set" % name)
func execute_event_user_7(): 	push_warning("%s: Event not set" % name)
func execute_event_user_8(): 	push_warning("%s: Event not set" % name)
func execute_event_user_9(): 	push_warning("%s: Event not set" % name)
func execute_event_user_10(): 	push_warning("%s: Event not set" % name)

func set_movement_target(movement_target: Vector2):
	ActorNav.set_target_position(movement_target)

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

func _draw() -> void:
	if debug_check_movement_vector or B2_Debug.ENABLE_MOVEMENT_VECTOR_VISUALIZE:
		draw_line(Vector2.ZERO, movement_vector * 32, Color.HOT_PINK)

func _physics_process( _delta: float ) -> void:
	if debug_check_movement_vector or B2_Debug.ENABLE_MOVEMENT_VECTOR_VISUALIZE:
		queue_redraw()
		
	if is_moving:
		if not is_playingset: # avoid issues with animations and movement.
			cinema_animation()
			
		# Do not query when the map has never synchronized and is empty.
		if NavigationServer2D.map_get_iteration_id( ActorNav.get_navigation_map() ) == 0:
			return
		# Finish navigation
		if ActorNav.is_target_reached():
			playing_animation = ""
			is_moving = false
			position = destination.round() ## WARNING is this needed? Maybe its whats causing the jittering issue.
			
			ActorCol.call_deferred("set_disabled", false) 	# Reenable the collision.
			if debug_move_finish:	print("%s finished moving." % name)
			
			if not is_playingset: # avoid issues with animations and movement.
				cinema_look( vec_2_dir_map.get( movement_vector, "SOUTH" ) )
				
			destination_reached.emit()
			return
		
		if ActorNav.is_navigation_finished():
			playing_animation = ""
			return
		
		#print( speed * speed_multiplier / Engine.time_scale )
		var next_path_position: Vector2 = ActorNav.get_next_path_position()
		var new_velocity: Vector2 = global_position.direction_to( next_path_position ) * ( speed / lerpf(1.0, Engine.time_scale, 0.25) ) # This "Engine.time_scale" is used when the game is FFWDing. Actors used to have issues reaching the waypoint without this.
		
		## Update movement vector for animation purposes.
		real_movement_vector 	= position.direction_to( next_path_position )
		movement_vector 		= real_movement_vector.round()
		
		if ActorNav.avoidance_enabled:			ActorNav.set_velocity(new_velocity)
		else:									_on_velocity_computed(new_velocity)
			
		
func _on_velocity_computed(safe_velocity: Vector2):
	velocity = safe_velocity
	move_and_slide()
	last_movement_vector = movement_vector
