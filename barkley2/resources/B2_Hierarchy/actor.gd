extends CharacterBody2D
class_name B2_Actor

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

## Godot
signal destination_reached
@export var animatedsprite : AnimatedSprite2D
@export var collisionshape : CollisionShape2D

var speed := 0.8
var is_moving := false

var destination := Vector2.ZERO
var destination_path := PackedVector2Array()
var destination_offset := Vector2(8,8)

# used to define the movement sprite
var movement_vector 		:= Vector2.ZERO
var last_movement_vector 	:= Vector2.ZERO

## Animation
var ANIMATION_STAND 		:= "PLACEHOLDER - %s" % self
var ANIMATION_SOUTH 		:= "PLACEHOLDER - %s" % self
var ANIMATION_SOUTHEAST 	:= "PLACEHOLDER - %s" % self
var ANIMATION_SOUTHWEST 	:= "PLACEHOLDER - %s" % self
var ANIMATION_WEST 			:= "PLACEHOLDER - %s" % self
var ANIMATION_NORTH 		:= "PLACEHOLDER - %s" % self
var ANIMATION_NORTHEAST 	:= "PLACEHOLDER - %s" % self
var ANIMATION_NORTHWEST 	:= "PLACEHOLDER - %s" % self
var ANIMATION_EAST 			:= "PLACEHOLDER - %s" % self

func cinema_set( _sprite_frame : String ):
	if animatedsprite.sprite_frames.has_animation(_sprite_frame):
		flip_sprite()
		animatedsprite.animation = _sprite_frame
	else:
		push_error("Actor " + str(self) + ": cinema_set() " + _sprite_frame + " not found" )

func cinema_playset( _sprite_frame : String, _sprite_frame_2 : String ): ## NOTE Not sure how to deal with this?
	if animatedsprite.sprite_frames.has_animation( _sprite_frame ):
		flip_sprite()
		animatedsprite.sprite_frames.set_animation_loop( _sprite_frame, false )
		animatedsprite.sprite_frames.set_animation_speed( _sprite_frame, 15 )
		animatedsprite.play( _sprite_frame )
		await animatedsprite.animation_finished
		animatedsprite.animation = _sprite_frame_2
		return 
	else:
		push_error("Actor " + str(self) + ": cinema_playset() " + _sprite_frame + " not found" )
		return

func cinema_look( _direction : String ):
	animatedsprite.stop()
	match _direction:
		"NORTHWEST":
			animatedsprite.animation = (ANIMATION_NORTHWEST)
			animatedsprite.flip_h = true
		"NORTHEAST":
			animatedsprite.animation = (ANIMATION_NORTHEAST)
			animatedsprite.flip_h = false
		"SOUTHWEST":
			animatedsprite.animation = (ANIMATION_SOUTHWEST)
			animatedsprite.flip_h = true
		"SOUTHEAST":
			animatedsprite.animation = (ANIMATION_SOUTHEAST)
			animatedsprite.flip_h = false
				
		"NORTH":
			animatedsprite.animation = (ANIMATION_NORTH)
			animatedsprite.flip_h = true
		"WEST":
			animatedsprite.animation = (ANIMATION_WEST)
			animatedsprite.flip_h = true
		"SOUTH":
			animatedsprite.animation = (ANIMATION_SOUTH)
			animatedsprite.flip_h = false
		"EAST":
			animatedsprite.animation = (ANIMATION_EAST)
			animatedsprite.flip_h = false
	
func cinema_moveto( _cinema_spot : Node2D, _speed : String ):
	# Default behaviour
	match _speed:
		"MOVE_FAST":
			speed = 5.0
		"MOVE_SLOW":
			speed = 1.0
		"MOVE_NORMAL":
			speed = 2.0
	
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
			
			collisionshape.disabled = true # Disable collision while moving
			await destination_reached
			collisionshape.disabled = false
		else:
			push_error("Parent does not have the 'get_astar_path' function. It should.")
	return

func flip_sprite():
	if movement_vector.x > 0: # handle sprite mirroring
		animatedsprite.flip_h = false
	else:
		animatedsprite.flip_h = true
	#print("flip ", name, " - ", flip_h)

func cinema_animation(): # Apply animation when the character is moved by a cinema script.
	if movement_vector != last_movement_vector:
		flip_sprite()
			
		match movement_vector:
			Vector2.UP + Vector2.LEFT:
				animatedsprite.play(ANIMATION_NORTHWEST)
			Vector2.UP + Vector2.RIGHT:
				animatedsprite.play(ANIMATION_NORTHEAST)
			Vector2.DOWN + Vector2.LEFT:
				animatedsprite.play(ANIMATION_SOUTHWEST)
			Vector2.DOWN + Vector2.RIGHT:
				animatedsprite.play(ANIMATION_SOUTHEAST)
				
			Vector2.UP:
				animatedsprite.play(ANIMATION_NORTH)
			Vector2.LEFT:
				animatedsprite.play(ANIMATION_WEST)
			Vector2.DOWN:
				animatedsprite.play(ANIMATION_SOUTH)
			Vector2.RIGHT:
				animatedsprite.play(ANIMATION_EAST)
				
			_: # Catch All
				animatedsprite.play(ANIMATION_SOUTH)
				# print("Catch all, ", input)
				
		last_movement_vector = movement_vector

func execute_event_user_0():
	push_warning("Event not set")

func execute_event_user_1():
	push_warning("Event not set")

func execute_event_user_2():
	push_warning("Event not set")

func execute_event_user_10():
	push_warning("Event not set")

func _child_process(_delta) -> void: # used to avoid overwriting the _process func.
	pass

func _process(delta: float) -> void:
	if is_moving:
		cinema_animation()
		_child_process(delta)
		#position = position.move_toward(destination, (speed * 30) * delta)
		
		movement_vector = position.direction_to( destination ).sign()
		
		if position.distance_to( destination_path[-1] + destination_offset ) < 2.0:
			# man, i miss the pop_back() function.
			destination_path.remove_at( destination_path.size() - 1 )
			
			# check if there are any destinations left. if not, finish walking
			if destination_path.is_empty():
				velocity = Vector2.ZERO
				is_moving = false
				destination_reached.emit()
				position = destination.round()
				last_movement_vector = Vector2.ZERO
				animatedsprite.stop()
				animatedsprite.animation = ANIMATION_STAND
				
		else:
			velocity = position.direction_to( destination_path[-1] + destination_offset ) * (speed * 1400) * delta
			move_and_slide()
		
