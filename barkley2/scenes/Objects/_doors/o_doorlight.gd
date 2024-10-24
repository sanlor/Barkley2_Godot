@tool
@icon("res://barkley2/assets/b2_original/images/merged/s_doorlight.png")
extends AnimatedSprite2D
class_name B2_DoorLight
# Base class for doorlight directions.
@export var enabled			:= true
@export var show_door_light := false:
	set(b):
		show_door_light = b
		if Engine.is_editor_hint():
			_update_sprite()

# the original code does a lot of fancy stuff. I think im going to rewrite almost everything.

## TODO Door size doesnt work .

enum DOOR_TYPE{DOWN, UP, LEFT, RIGHT}
@export var type := DOOR_TYPE.UP :
	set(_dir):
		type = _dir
		if Engine.is_editor_hint():
			_update_sprite()
			
enum DOOR_SIZE{S, M, L, XL}
@export var door_size 		:= DOOR_SIZE.S :
	set(_siz):
		door_size  = _siz
		if Engine.is_editor_hint():
			_update_sprite()
			
@export var door_offset 	:= Vector2.ZERO

@export var debug_door_exit_marker 		:= true
@export var debug_door_exit_marker_pos 	:= Vector2.ZERO
@export var door_exit_marker_global_pos 	:= Vector2.ZERO ## Copy this for teleport reference
@export var teleport_string	:= "" ## Trully, I am lazy.

@export_category("Teleport")
@export var debug_teleport_destination 		:= "" 	## room_name, position.x, position.y -- Check RoomXY(room, x, y, slide_direction [4 args] open_sfx [5 args], close_sfx [5 args])
@export var debug_teleport_create_o_hoopz 	:= true
@export var teleport_destination 			:= "" 		## room_name, position.x, position.y -- Check RoomXY(room, x, y, slide_direction [4 args] open_sfx [5 args], close_sfx [5 args])
@export var teleport_create_o_hoopz 		:= true

var wadChk = 2; # To make resist half in wading layer
var zone = "";

var pushTime 		= 0.5; # In seconds how long you need to hold
var pushResist 		= 65000; # Pushing resist, higher is more pusback ## was 70
var light 			= 1; # When 0, it does not show the light
var fix 			= 1; # If 1, adds the top fix
var locked 			= 0;
var door_name 		= "";

var area_change 		= false;
var area 				= "TNN Sewers";
var area_change_audio 	= true;
var enable 				= 1;
var enableDraw 			= 0;


## Door
var _fade_timer 			= 0.25;

var target_light_alpha := 0.25
var light_alpha := target_light_alpha

var is_warping := false
var is_loaded	:= false

const light_activation_offset := {
	DOOR_TYPE.UP:		Vector2( 16,	8 ),
	DOOR_TYPE.DOWN:		Vector2( 16,	8 ),
	DOOR_TYPE.LEFT:		Vector2( 8,		16 ),
	DOOR_TYPE.RIGHT:	Vector2( 8,		16 ),
}
const teleport_activation_offset := {
	DOOR_TYPE.UP:		Vector2( 16,	24 ),
	DOOR_TYPE.DOWN:		Vector2( 16,	-8 ),
	DOOR_TYPE.LEFT:		Vector2( 24,	16 ),
	DOOR_TYPE.RIGHT:	Vector2( -8,	16 ),
}
const push_area_offset := {
	DOOR_TYPE.UP:		Vector2( 16,	8 ),
	DOOR_TYPE.DOWN:		Vector2( 16,	8 ),
	DOOR_TYPE.LEFT:		Vector2( 8,		16 ),
	DOOR_TYPE.RIGHT:	Vector2( 8,		16 ),
}

@onready var light_activation_area: 		Area2D = $light_activation_area
@onready var light_activation_shape: 		CollisionShape2D = $light_activation_area/light_activation_shape
@onready var teleport_activation_area: 		Area2D = $teleport_activation_area
@onready var push_area: 					Area2D = $push_area

var _rot := 0.0

func _ready() -> void:
	#if not enabled and not Engine.is_editor_hint():
		#queue_free()
		
	if not Engine.is_editor_hint():
		B2_RoomXY.room_finished_loading.connect( func(): is_loaded = true )
		
	_update_sprite()
	
func _update_sprite():
	if Engine.is_editor_hint() and not show_door_light:
		animation = "debug_icons"
		frame = type
		return
	
	match type:
		DOOR_TYPE.UP:
			animation = "s_doorlight_ud"
			flip_v = true
			flip_h = false
			offset = Vector2( 0, 0 )
			frame = door_size
			_rot = 0
			debug_door_exit_marker_pos = Vector2(16, -12)
			
		DOOR_TYPE.DOWN:
			animation = "s_doorlight_ud"
			flip_v = false
			flip_h = false
			offset = Vector2( 0, -44 )
			frame = door_size
			_rot = 0
			debug_door_exit_marker_pos = Vector2(16, 22)
			
		DOOR_TYPE.LEFT:
			animation = "s_doorlight_lr"
			flip_v = false
			flip_h = false
			offset = Vector2( 0, 0 )
			frame = door_size
			_rot = deg_to_rad(90)
			debug_door_exit_marker_pos = Vector2(-8, 16)
			
		DOOR_TYPE.RIGHT:
			animation = "s_doorlight_lr"
			flip_v = false
			flip_h = true
			offset = Vector2( 0, 0 )
			frame = door_size
			_rot = deg_to_rad(90)
			debug_door_exit_marker_pos = Vector2(22, 16)
				
	#if not Engine.is_editor_hint():
	door_exit_marker_global_pos = to_global(debug_door_exit_marker_pos)
	#if get_parent() is B2_ROOMS:
	teleport_string = get_parent().name + "," + str(door_exit_marker_global_pos.x) + "," + str(door_exit_marker_global_pos.y)
	teleport_activation_area.rotation 	= _rot
	push_area.rotation 					= _rot
	light_activation_area.position 		= light_activation_offset[type]
	teleport_activation_area.position 	= teleport_activation_offset[type]
	push_area.position 					= push_area_offset[type]
	
	is_loaded = true

func push_player( body : B2_Player, delta : float ):
	var push_vector := Vector2.ZERO
	match type:
		DOOR_TYPE.UP: 		push_vector = Vector2.UP
		DOOR_TYPE.DOWN: 	push_vector = Vector2.DOWN
		DOOR_TYPE.LEFT: 	push_vector = Vector2.LEFT
		DOOR_TYPE.RIGHT: 	push_vector = Vector2.RIGHT
	body.external_velocity = push_vector * pushResist * delta
	
func _physics_process(_delta: float) -> void:
	if Engine.is_editor_hint():
		return
		
	# player is being warped to the next room.
	if is_warping:
		return
		
	modulate.a = 0.0
	
	if light_activation_area.has_overlapping_bodies():
		var body : Array[Node2D] = light_activation_area.get_overlapping_bodies()
		for b in body:
			if b is B2_Player or b is B2_InteractiveActor:
				var b_distance := global_position.distance_to( b.global_position )
				var alpha : float = b_distance / light_activation_shape.shape.radius
				
				alpha *= ( target_light_alpha * randf_range( 1.05, 0.95 ) )
				modulate.a = ( alpha * -1.0 ) + target_light_alpha
				
	if push_area.has_overlapping_bodies():
		var body : Array[Node2D] = push_area.get_overlapping_bodies()
		for b in body:
			if b is B2_Player:
				push_player( b, _delta )
	
func _on_teleport_activation_area_body_entered(body: Node2D) -> void:
	if not is_loaded:
		return
		
	if is_warping: # avoid double loading the same room
		return
		
	if not enabled:
		return
		
	if body is B2_Player:
		# Debug Destination has priority
		if debug_teleport_destination.is_empty():
			if teleport_destination.is_empty():
				push_error("Door has no destination set. dumbo!")
			else:
				is_warping = true
				print(self)
				B2_RoomXY.warp_to( teleport_destination, 0.0 )
		else:
			push_warning("DEBUG TELEPORT: ", debug_teleport_destination )
			is_warping = true
			B2_RoomXY.warp_to( debug_teleport_destination, 0.0 )
			
func _draw() -> void:
	if debug_door_exit_marker and Engine.is_editor_hint():
		draw_circle( debug_door_exit_marker_pos, 2, Color.RED )
