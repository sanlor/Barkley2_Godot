extends B2_Entity
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

var speed := 1.0
var is_moving := false
var destination := Vector2.ZERO

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
	if sprite_frames.has_animation(_sprite_frame):
		flip_sprite()
		animation = _sprite_frame
	else:
		push_error("Actor " + str(self) + ": cinema_set() " + _sprite_frame + " not found" )

func cinema_playset( _sprite_frame : String, _sprite_frame_2 : String ): ## NOTE Not sure how to deal with this?
	if sprite_frames.has_animation( _sprite_frame ):
		flip_sprite()
		sprite_frames.set_animation_loop( _sprite_frame, false )
		sprite_frames.set_animation_speed( _sprite_frame, 15 )
		play( _sprite_frame )
		await animation_finished
		animation = _sprite_frame_2
		return 
	else:
		push_error("Actor " + str(self) + ": cinema_playset() " + _sprite_frame + " not found" )
		return

func cinema_look( _direction : String ):
	pass
	
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
		is_moving 			= true
		destination 		= _cinema_spot.position
		movement_vector 	= position.direction_to( destination ).sign()
		await destination_reached
	return

func flip_sprite():
	if movement_vector.x > 0: # handle sprite mirroring
		flip_h = false
	else:
		flip_h = true
	#print("flip ", name, " - ", flip_h)

func cinema_animation(): # Apply animation when the character is moved by a cinema script.
	if movement_vector != last_movement_vector:
		flip_sprite()
			
		match movement_vector:
			Vector2.UP + Vector2.LEFT:
				play(ANIMATION_NORTHWEST)
			Vector2.UP + Vector2.RIGHT:
				play(ANIMATION_NORTHEAST)
			Vector2.DOWN + Vector2.LEFT:
				play(ANIMATION_SOUTHWEST)
			Vector2.DOWN + Vector2.RIGHT:
				play(ANIMATION_SOUTHEAST)
				
			Vector2.UP:
				play(ANIMATION_NORTH)
			Vector2.LEFT:
				play(ANIMATION_WEST)
			Vector2.DOWN:
				play(ANIMATION_SOUTH)
			Vector2.RIGHT:
				play(ANIMATION_EAST)
				
			_: # Catch All
				play(ANIMATION_SOUTH)
				# print("Catch all, ", input)
				
		last_movement_vector = movement_vector

func _child_process(_delta) -> void: # used to avoid overwriting the _process func.
	pass

func _process(delta: float) -> void:
	if is_moving:
		cinema_animation()
		_child_process(delta)
		position = position.move_toward(destination, (speed * 30) * delta)
		movement_vector = position.direction_to( destination ).sign()
		
		if position.is_equal_approx(destination):
			is_moving = false
			destination_reached.emit()
			last_movement_vector = Vector2.ZERO
			stop()
			animation = ANIMATION_STAND
		# print(movement_vector)
