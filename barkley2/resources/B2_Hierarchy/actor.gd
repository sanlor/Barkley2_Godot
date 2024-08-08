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

func _enter_tree() -> void:
	add_to_group("actors")
	add_to_group("cinema_spot")

func cinema_set( _sprite_frame : String ):
	pass

func cinema_playset( _sprite_frame : String ): ## NOTE Not sure how to deal with this?
	pass

func cinema_look( _direction : String ):
	pass
	
func cinema_moveto( _cinema_spot : Node2D, _speed : String ):
	# Default behaviour
	var movement_tween := create_tween()
	movement_tween.tween_property(self, "position", _cinema_spot.position, 1.0)
	return await movement_tween.finished
