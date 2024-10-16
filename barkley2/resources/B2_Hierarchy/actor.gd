extends CharacterBody2D
class_name B2_Actor

signal sprite_offset_centered
signal sprite_collision_adjusted

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
@export var ActorAnim 		: AnimatedSprite2D
@export var flip_h			:= false
@export var has_collision 	:= true
@export var ActorCol 		: CollisionShape2D

# True if the sprite is using automatic animations (like when it is moving), or false otherwise.
@export var _automatic_animation 	:= false; ## Start playing a animation during room load ## CRITICAL ## it overrides any animations set on _ready().
# The animation to use if automatic animation isn't true. 
@export var _current_animation 		:= "default" ## What animation should blay at room load? ## CRITICAL ## it overrides any animations set on _ready().

var is_moving 		:= false
var is_playingset 	:= false

var destination 			:= Vector2.ZERO
var destination_path 		:= PackedVector2Array()
var destination_offset 		:= Vector2.ZERO #Vector2(8,8)

# used to define the movement sprite
var movement_vector 		:= Vector2.ZERO
var last_movement_vector 	:= Vector2.ZERO

@export_category("Movement Stuff")
## Speed stuff
var speed_multiplier 		:= 900.0
@export var speed_slow 		:= 2.0 * speed_multiplier # was 1.5
@export var speed_normal 	:= 3.0 * speed_multiplier # was 2.5
@export var speed_fast 		:= 5.0 * speed_multiplier # was 5.0
var speed 					:= speed_normal

@export_category("Animation")
@export var animation_speed := 1.5
@export var disable_auto_flip_h	:= false	# Hoopz actor has 8 different directions, it should not mirror
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

func _init() -> void:
	ready.connect( play_animations )
	
func play_animations():
	if _automatic_animation:
		if ActorAnim.sprite_frames.has_animation(_current_animation):
			ActorAnim.play(_current_animation, animation_speed)
		else:
			push_warning( "%s has no animation called %s." % [ name, _current_animation ] )
	
	# try to run this as late as possible
	#await ActorAnim.ready
	ActorAnim.flip_h = flip_h

func cinema_surpriseat( target ):
	cinema_useat( target, "surprise", "surpriseHold", 1.25 )

func cinema_useat( target, force_new_anim := "", force_hold_anim := "", force_speed := 1.0 ) -> void:
	# what a mess. target can be a string or a node.
	var dir : Vector2
	if target 		is String:
		dir = dir_2_vec_map.get(target, Vector2.DOWN) as Vector2
	elif target 	is Node2D:
		dir = position.direction_to(target.position).sign()
	else:
		push_warning( "Which USEAT anim is this? ", target )
		
	if dir.x < 0: ActorAnim.flip_h = true
	else: ActorAnim.flip_h = false
	
	var old_anim 	:= force_hold_anim
	var old_frame 	:= 0
	if force_hold_anim.is_empty():
		old_anim 	= ActorAnim.animation
		old_frame 	= ActorAnim.frame # Standing anim fix
		
	var new_anim 	:= force_new_anim # used for SURPRISEAT
	if force_new_anim.is_empty():
		new_anim = useat_map.get(dir, "") as String
		
	ActorAnim.sprite_frames.set_animation_loop( new_anim, false )
	
	cinema_playset( new_anim, old_anim, 10.0 * force_speed )
	await ActorAnim.animation_finished
	ActorAnim.frame = old_frame
	
	return

func cinema_set( _sprite_frame : String ):
	if is_moving:
		push_warning("Warning: Cant change %s´s animation while actor is moving.", name)
	
	if ActorAnim.sprite_frames.has_animation(_sprite_frame):
		ActorAnim.animation = _sprite_frame
		flip_sprite()
		adjust_sprite_offset()
	else:
		push_error("Actor " + str(self) + ": cinema_set() " + _sprite_frame + " not found" )

func cinema_playset( _sprite_frame : String, _sprite_frame_2 : String, _speed := 15 ): ## NOTE Not sure how to deal with this?
	if ActorAnim.sprite_frames.has_animation( _sprite_frame ):
		is_playingset = true
		ActorAnim.animation = _sprite_frame
		adjust_sprite_offset()
		flip_sprite()
		ActorAnim.sprite_frames.set_animation_loop( _sprite_frame, false )
		ActorAnim.sprite_frames.set_animation_speed( _sprite_frame, _speed )
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
	ActorAnim.animation = ANIMATION_STAND
	match _direction:
		"NORTH":
			#ActorAnim.animation = (ANIMATION_NORTH)
			ActorAnim.frame = ANIMATION_STAND_SPRITE_INDEX[0]
			ActorAnim.flip_h = false
		"NORTHEAST":
			#ActorAnim.animation = (ANIMATION_NORTHEAST)
			ActorAnim.frame = ANIMATION_STAND_SPRITE_INDEX[1]
			ActorAnim.flip_h = false
		"EAST":
			#ActorAnim.animation = (ANIMATION_EAST)
			ActorAnim.frame = ANIMATION_STAND_SPRITE_INDEX[2]
			ActorAnim.flip_h = false
		"SOUTHEAST":
			#ActorAnim.animation = (ANIMATION_SOUTHEAST)
			ActorAnim.frame = ANIMATION_STAND_SPRITE_INDEX[3]
			ActorAnim.flip_h = false
		"SOUTH":
			#ActorAnim.animation = (ANIMATION_SOUTH)
			ActorAnim.frame = ANIMATION_STAND_SPRITE_INDEX[4]
			ActorAnim.flip_h = false
		"SOUTHWEST":
			#ActorAnim.animation = (ANIMATION_SOUTHWEST)
			ActorAnim.frame = ANIMATION_STAND_SPRITE_INDEX[5]
			ActorAnim.flip_h = true
		"WEST":
			#ActorAnim.animation = (ANIMATION_WEST)
			ActorAnim.frame = ANIMATION_STAND_SPRITE_INDEX[6]
			ActorAnim.flip_h = true
		"NORTHWEST":
			#ActorAnim.animation = (ANIMATION_NORTHWEST)
			ActorAnim.frame = ANIMATION_STAND_SPRITE_INDEX[7]
			ActorAnim.flip_h = true
	adjust_sprite_offset()
	
func cinema_lookat( target_node : Node2D ):
	var _direction := position.direction_to( target_node.position ).round()
	var dir_name := vec_2_dir_map.get( _direction, "SOUTH" ) as String
			
	cinema_look( dir_name )
	
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
			
			ActorCol.call_deferred("set_disabled", true) # Disable collision while moving

		else:
			push_error("Parent does not have the 'get_astar_path' function. It should.")
	return

func flip_sprite( ):
	if movement_vector.x > 0: # handle sprite mirroring
		ActorAnim.flip_h = false
	elif movement_vector.x < 0:
		ActorAnim.flip_h = true
	else:
		# movement_vector.x == 0, do nothing
		pass

func cinema_animation(): # Apply animation when the character is moved by a cinema script.
	if movement_vector != last_movement_vector:
		if not disable_auto_flip_h:
			flip_sprite()
		else:
			ActorAnim.flip_h = false
			
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
				
		ActorAnim.play(_dir, animation_speed)
			
		adjust_sprite_offset()
		last_movement_vector = movement_vector

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
	## TODO create col shape and set its colisions.
	# var shape := RectangleShape2D.new()
	# shape.size.x = int( sprite_data["bbox_right"] ) 	- int( sprite_data["bbox_left"] )
	# shape.size.y = int( sprite_data["bbox_bottom"] ) 	- int( sprite_data["bbox_top"] )
	# Not being able to un-center the collision shape is terrible. # https://github.com/godotengine/godot-proposals/issues/1170
	## NOTE Disabled bellow. not sure how to use it yet.
	# ActorCol.position = Vector2( int( sprite_data["bbox_left"] ), int( sprite_data["bbox_top"] ) ) + shape.size / 2.0
	var shape := CircleShape2D.new()
	shape.radius = 10 # 10 is arbitrary.
	shape.radius = ( float( sprite_data["bbox_right"] ) - float( sprite_data["bbox_left"] ) ) / PI # ooh look at me, all fancy using PI and such.
	
	## NOTE 2 - Fuck, I have no idea how Collisions are handled on the original game. Its circles now, every actor has a cicle as collision shape. fuck it.
	ActorCol.shape = shape
	sprite_collision_adjusted.emit()

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

func _physics_process(delta: float) -> void:
	if is_moving:
		cinema_animation()
		_child_process(delta)
		
		#movement_vector = position.direction_to( destination ).sign()
		movement_vector = position.direction_to( destination_path[-1] + destination_offset ).sign()
		
		if position.distance_to( destination_path[-1] + destination_offset ) < 1.5:
			# man, i miss the pop_back() function.
			destination_path.remove_at( destination_path.size() - 1 )
			
			# check if there are any destinations left. if not, finish walking
			if destination_path.is_empty():
				is_moving = false
				velocity = Vector2.ZERO
				position = destination.round() ## WARNING is this needed? Maybe its whats causing the jittering issue.
				
				#ActorCol.disabled = false 						# Reenable the collision.
				ActorCol.call_deferred("set_disabled", false) 	# Reenable the collision.
				ActorAnim.animation = ANIMATION_STAND
				ActorAnim.stop()
				
				if debug_move_finish:
					print("%s finished moving." % name)
					
				destination_reached.emit()
				
		else:
			var target : Vector2 = destination_path[-1] + destination_offset
			var next_hop := position.direction_to( target ) * speed * delta
			
			## Fix for time scale bullshit
			if B2_Input.is_fastforwarding:
				var hop_dist := position.distance_to( next_hop )
				var tar_dist := position.distance_to( target )
				
				if hop_dist >= tar_dist:
					# If the next hop is longer than the distance to the next target, just warp it to the position.
					# Its jittery, but its not important. it doesnt always work.
					position = target
				else:
					# if not, just proceed normally.
					velocity = next_hop
			else:
				velocity = next_hop
			move_and_slide()
		
