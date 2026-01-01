@icon("res://barkley2/assets/b2_original/images/merged/s_doorlight.png")
extends AnimatedSprite2D
class_name B2_DoorLight

const O_ENTITY_INDICATOR_GOSSIP = preload("res://barkley2/scenes/Objects/_interactiveActor/_pedestrians/o_entity_indicatorGossip.tscn")

## Debug stuff
var show_destination := false

# Base class for doorlight directions.
@export_category("DoorLight setup")
@export var locked					:= false
@export var locked_msg				:= ["Locked...", "Its locked.", "It won't open...", "...?"]
@export var enabled					:= true
@export var editor_anim				:= "debug_icons"
@export var editor_frame 			:= 0
@export var running_anim 			:= ""
@export var running_frame 			:= 0
@export var flip_h_running_anim 	:= false
@export var flip_v_running_anim 	:= false
@export var show_door_light			:= true		## Show the doorlight during gameplay.
@export var editor_show_door_light 	:= false: 	## Show the real door light sprite in the editor.
	set(b):
		editor_show_door_light = b
		if Engine.is_editor_hint():
			_update_sprite()

# the original code does a lot of fancy stuff. I think im going to rewrite almost everything.

			
enum DOOR_SIZE{S, M, L, XL}
@export var door_size 		:= DOOR_SIZE.S :
	set(_siz):
		door_size  = _siz
		if Engine.is_editor_hint():
			_update_sprite()
			
@export var door_offset 					:= Vector2.ZERO		## Doorlight sprite offset
@export var debug_door_exit_marker 			:= true				## True lazyness. marks where the player should spawn
@export var debug_door_exit_marker_pos 		:= Vector2.ZERO		## True lazyness. marks where the player should spawn
@export var door_exit_marker_global_pos 	:= Vector2.ZERO 	## Copy this for teleport reference
@export var teleport_string					:= "" 				## Trully, I am lazy. 

@export_category("Teleport")
@export var debug_teleport_destination 		:= "" 	## room_name, position.x, position.y -- Check RoomXY(room, x, y, slide_direction [4 args] open_sfx [5 args], close_sfx [5 args])
@export var debug_teleport_create_o_hoopz 	:= true
@export var teleport_destination 			:= "" 	## room_name, position.x, position.y -- Check RoomXY(room, x, y, slide_direction [4 args] open_sfx [5 args], close_sfx [5 args])
@export var teleport_create_o_hoopz 		:= true

var wadChk 									= 2; # To make resist half in wading layer
var zone 									= "";

var pushTime 		= 0.5; # In seconds how long you need to hold
var pushResist 		= 2000000; # Pushing resist, higher is more pusback ## was 70
var light 			= 1; # When 0, it does not show the light
var fix 			= 1; # If 1, adds the top fix
#var locked 			= 0;
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

@onready var light_activation_area: 		Area2D = $light_activation_area
@onready var light_activation_shape: 		CollisionShape2D = $light_activation_area/light_activation_shape
@onready var teleport_activation_area: 		Area2D = $teleport_activation_area
@onready var push_area: 					Area2D = $push_area

var _rot := 0.0

func _ready() -> void:
	#if not enabled and not Engine.is_editor_hint():
		#queue_free()
	
	is_loaded = false
	
	if not Engine.is_editor_hint():
		B2_RoomXY.room_finished_loading.connect( 
			func(): 
				is_loaded = true
				is_warping = false
				)
	_update_sprite()
	
	## Set Collision.
	light_activation_area.set_collision_mask_value( 2, true )
	light_activation_area.set_collision_mask_value( 7, true )
	
	teleport_activation_area.set_collision_mask_value( 2, true )
	teleport_activation_area.set_collision_mask_value( 2, true )
	
	push_area.set_collision_mask_value( 2, true )
	push_area.set_collision_mask_value( 2, true )
	
func _update_sprite():
	if Engine.is_editor_hint() and not editor_show_door_light:
		animation 	= editor_anim
		frame 		= editor_frame
		print("%s frame: " % name, frame)
		z_index = 0
		#return
	else:
		if sprite_frames.has_animation( running_anim ):
			animation = running_anim
			frame = running_frame
			
		else:
			push_error("Invalid Running Anim %s." % running_anim)
		
		flip_h = flip_h_running_anim
		flip_v = flip_v_running_anim
		offset = door_offset
		
	door_exit_marker_global_pos = to_global(debug_door_exit_marker_pos)
	
	if not Engine.is_editor_hint():
		teleport_string = get_parent().name + "," + str(door_exit_marker_global_pos.x) + "," + str(door_exit_marker_global_pos.y)
	
	is_loaded = true

func push_player( _body : B2_PlayerCombatActor, _delta : float ):
	pass
	
func _physics_process(_delta: float) -> void:
	if Engine.is_editor_hint():			return
		
	# player is being warped to the next room.
	if is_warping:						return
		
	modulate.a = 0.0
	
	if light_activation_area.has_overlapping_bodies() and show_door_light:
		var body : Array[Node2D] = light_activation_area.get_overlapping_bodies()
		for b in body:
			if b is B2_PlayerCombatActor: # or b is B2_InteractiveActor:
				var b_distance := global_position.distance_to( b.global_position )
				var alpha : float = b_distance / light_activation_shape.shape.radius
				
				alpha *= ( target_light_alpha * randf_range( 1.05, 0.95 ) )
				modulate.a = ( alpha * -1.0 ) + target_light_alpha
				
	if push_area.has_overlapping_bodies():
		var body : Array[Node2D] = push_area.get_overlapping_bodies()
		for b in body:
			if b is B2_PlayerCombatActor:
				push_player( b, _delta )
	
func _on_teleport_activation_area_body_entered(body: Node2D) -> void:
	if not is_loaded:	return
		
	# avoid double loading the same room
	if is_warping: 		return
		
	if not enabled:		return
		
	if body is B2_PlayerCombatActor:
		# Debug Destination has priority
		if locked:
			B2_Sound.play_pick( "door_locked" )
			var g = O_ENTITY_INDICATOR_GOSSIP.instantiate()
			g.text = Text.pr( locked_msg.pick_random() )
			g.timer = 1.0
			add_sibling( g, true )
			g.position = position
		else:
			if debug_teleport_destination.is_empty():
				if teleport_destination.is_empty():
					push_error("Door has no destination set. Dumbo!")
				else:
					is_warping = true
					B2_Sound.play_pick( "trailing_steps" )
					B2_RoomXY.warp_to( teleport_destination, 0.0 )
					#fade_player(body)
			else:
				push_warning("DEBUG TELEPORT: ", debug_teleport_destination )
				is_warping = true
				B2_Sound.play_pick( "trailing_steps" )
				B2_RoomXY.warp_to( debug_teleport_destination, 0.0 )
				#fade_player(body)
				
## 16/08/25 This is causing issues with the player being invisible after loading.
# This is a bug related to how the player spawns on te level. It triggers the room change as the room loads, causing many issues.
func fade_player( body ) -> void:
	## Fade player
	var t := create_tween()
	t.tween_property( body, "modulate", Color.TRANSPARENT, 0.1 )

func _draw() -> void:
	if debug_door_exit_marker and Engine.is_editor_hint():
		draw_circle( debug_door_exit_marker_pos, 2, Color.RED )
	if show_destination:
		draw_string( preload("uid://cbgm2fhhwo0ld"), Vector2(0, -16), teleport_destination, HORIZONTAL_ALIGNMENT_LEFT, -1, 16, Color.DEEP_SKY_BLUE )
