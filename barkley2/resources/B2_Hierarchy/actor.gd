extends CharacterBody2D
class_name B2_Actor

#region Original code

# Extend Entity creation with further declarations
# event_inherited()

# uuid = uuid_generate();

# Path initialization
# scr_path_init()

# Actors turn dark in shadows
var in_shadow := false

# Actors can't leave the room usually
var can_leave_room := false

# Actors default to circle moveboxes - better but more processing involved
## NOTE Use Area2D or CharacterBody2D
# scr_entity_setMovementCollisionShape_circle(8)

# Create a sound emitter for each Actor by default
# scr_entity_makeSoundEmitter();

# Storage for variables during pause
var paused_path_speed = 0;

# Flag to indicate if object supports paths - Actor does
var path_support = true;

# Set whether object is Surfaced or not
var surf = null;
var use_surface = false;

# Actors can be rigid. If they are, they can not move
var actor_rigid = false
var actor_rigid_set = false
var actor_rigid_semisolid = true

# This is used by pedestrians and their shadows # Laz added, 17.12.2015
var alpha = 1;

# Facing
var _pedestrian = false;
var flipAuto = 0; #If 1, the sprite can mirror itself
var faceAuto = 0; #Only do facing scripts if we define them
var idleAuto = ""; #If not blank, sets to that animation when a cinema is over
var East = 2; #from obsolete stair code in step
var West = 3; #from obsolete stair code in step
var walkBackwards = 0; #When enabled, reverse animate
var statusImmuneAll = 0;

#endregion

## DEBUG
@export_category("Debug")
@export var debug_move_finish := false

## Godot
signal destination_reached
signal set_played
@export_category("Actor Stuff")
@export var ActorAnim 	: AnimatedSprite2D
@export var ActorCol 	: CollisionShape2D

var speed := 0.8
var is_moving 		:= false
var is_playingset 	:= false

var destination := Vector2.ZERO
var destination_path := PackedVector2Array()
var destination_offset := Vector2.ZERO #Vector2(8,8)

# used to define the movement sprite
var movement_vector 		:= Vector2.ZERO
var last_movement_vector 	:= Vector2.ZERO

@export var speed_slow 		:= 1.5
@export var speed_normal 	:= 2.5
@export var speed_fast 		:= 5.0

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

## Action Queue
var cinema_set_queue := []

func cinema_set( _sprite_frame : String ):
	if is_moving:
		push_warning("Warning: Cant change %s´s animation while actor is moving.", name)
	
	if ActorAnim.sprite_frames.has_animation(_sprite_frame):
		ActorAnim.animation = _sprite_frame
		flip_sprite()
		adjust_sprite_offset()
	else:
		push_error("Actor " + str(self) + ": cinema_set() " + _sprite_frame + " not found" )

func cinema_playset( _sprite_frame : String, _sprite_frame_2 : String ): ## NOTE Not sure how to deal with this?
	if ActorAnim.sprite_frames.has_animation( _sprite_frame ):
		is_playingset = true
		ActorAnim.animation = _sprite_frame
		adjust_sprite_offset()
		flip_sprite()
		ActorAnim.sprite_frames.set_animation_loop( _sprite_frame, false )
		ActorAnim.sprite_frames.set_animation_speed( _sprite_frame, 15 )
		ActorAnim.play( _sprite_frame )
		await ActorAnim.animation_finished
		ActorAnim.animation = _sprite_frame_2
		adjust_sprite_offset()
		is_playingset = false
		set_played.emit()
		return 
	else:
		push_error("Actor " + str(self) + ": cinema_playset() " + _sprite_frame + " not found" )
		return

func cinema_look( _direction : String ):
	ActorAnim.stop()
	match _direction:
		"NORTHWEST":
			ActorAnim.animation = (ANIMATION_NORTHWEST)
			ActorAnim.flip_h = true
		"NORTHEAST":
			ActorAnim.animation = (ANIMATION_NORTHEAST)
			ActorAnim.flip_h = false
		"SOUTHWEST":
			ActorAnim.animation = (ANIMATION_SOUTHWEST)
			ActorAnim.flip_h = true
		"SOUTHEAST":
			ActorAnim.animation = (ANIMATION_SOUTHEAST)
			ActorAnim.flip_h = false
		"NORTH":
			ActorAnim.animation = (ANIMATION_NORTH)
			ActorAnim.flip_h = true
		"WEST":
			ActorAnim.animation = (ANIMATION_WEST)
			ActorAnim.flip_h = true
		"SOUTH":
			ActorAnim.animation = (ANIMATION_SOUTH)
			ActorAnim.flip_h = false
		"EAST":
			ActorAnim.animation = (ANIMATION_EAST)
			ActorAnim.flip_h = false
	adjust_sprite_offset()
	
func cinema_moveto( _cinema_spot : Node2D, _speed : String ):
	# Default behaviour
	match _speed:
		"MOVE_FAST":
			speed = speed_fast
		"MOVE_SLOW":
			speed = speed_slow
		"MOVE_NORMAL":
			speed = speed_normal
	
	if _cinema_spot == null:
		push_error("Camera: node is invalid. ", _cinema_spot, ".")
	else:
		destination 		= _cinema_spot.position
		if get_parent().has_method("get_astar_path"):
			# destination_path[0] is the destination and destination_path[-1] is the source
			destination_path = get_parent().get_astar_path(position, destination)
			if destination_path.is_empty():
				push_error("Path invalid: ", position, " ", destination)
				return
				
			## Override the pathfinding for better movement.
			destination_path[0] 	= destination.round()
			destination_path[-1] 	= position.round()
			
			is_moving 			= true
			movement_vector 	= position.direction_to( destination ).sign()
			
			ActorCol.disabled = true # Disable collision while moving

		else:
			push_error("Parent does not have the 'get_astar_path' function. It should.")
	return

func flip_sprite():
	if movement_vector.x > 0: # handle sprite mirroring
		ActorAnim.flip_h = false
	elif movement_vector.x < 0:
		ActorAnim.flip_h = true

func cinema_animation(): # Apply animation when the character is moved by a cinema script.
	if movement_vector != last_movement_vector:
		flip_sprite()
			
		match movement_vector:
			Vector2.UP + Vector2.LEFT:
				ActorAnim.play(ANIMATION_NORTHWEST)
			Vector2.UP + Vector2.RIGHT:
				ActorAnim.play(ANIMATION_NORTHEAST)
			Vector2.DOWN + Vector2.LEFT:
				ActorAnim.play(ANIMATION_SOUTHWEST)
			Vector2.DOWN + Vector2.RIGHT:
				ActorAnim.play(ANIMATION_SOUTHEAST)
				
			Vector2.UP:
				ActorAnim.play(ANIMATION_NORTH)
			Vector2.LEFT:
				ActorAnim.play(ANIMATION_WEST)
			Vector2.DOWN:
				ActorAnim.play(ANIMATION_SOUTH)
			Vector2.RIGHT:
				ActorAnim.play(ANIMATION_EAST)
				
			_: # Catch All
				ActorAnim.play(ANIMATION_SOUTH)
				# print("Catch all, ", input)
				
		adjust_sprite_offset()
		last_movement_vector = movement_vector

func get_curr_sprite_metadata(curr_anim) -> Dictionary:
	var sprite_data := ActorAnim.get_meta( curr_anim, Dictionary() ) as Dictionary
	
	if sprite_data.is_empty():
		push_error("Ops, %s's AnimatedSprite2D has no metadata. Cant change the sprite offset like this." % ActorAnim.get_parent().name)
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
	adjust_sprite_collision()
	
# Get info from the sprite metadata.
func adjust_sprite_collision():
	var curr_anim := ActorAnim.animation
	var sprite_data := get_curr_sprite_metadata(curr_anim)
	if sprite_data.is_empty():
		# no data
		return
		
	## TODO create col shape and set its colisions.

@warning_ignore("unused_parameter")
func change_costume(costume_name : String) -> void:
	pass
	
func execute_event_user_0():
	push_warning("%s: Event not set" % name)

func execute_event_user_1():
	push_warning("%s: Event not set" % name)

func execute_event_user_2():
	push_warning("%s: Event not set" % name)

func execute_event_user_10():
	push_warning("%s: Event not set" % name)

func _child_process(_delta) -> void: # used to avoid overwriting the _process func.
	pass

## Function checks if the node is doing anything
## Return void right awai if itsd idle. Await for a signal if its busy.
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

func _process(delta: float) -> void:
	if is_moving:
		cinema_animation()
		_child_process(delta)
		#position = position.move_toward(destination, (speed * 30) * delta)
		
		movement_vector = position.direction_to( destination ).sign()
		
		if position.distance_to( destination_path[-1] + destination_offset ) < 1.5:
			# man, i miss the pop_back() function.
			destination_path.remove_at( destination_path.size() - 1 )
			
			# check if there are any destinations left. if not, finish walking
			if destination_path.is_empty():
				is_moving = false
				velocity = Vector2.ZERO
				position = destination.round()
				
				#last_movement_vector = Vector2.ZERO
				
				ActorCol.disabled = false
				ActorAnim.animation = ANIMATION_STAND
				ActorAnim.stop()
				#cinema_animation()
				
				if debug_move_finish:
					print("%s finished moving." % name)
					
				destination_reached.emit()
				
		else:
			velocity = position.direction_to( destination_path[-1] + destination_offset ) * (speed * 1500) * delta
			move_and_slide()
		
