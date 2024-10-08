extends AnimatedSprite2D
class_name B2_DOOR_PARENT

## Setup ##
@export_category("Setup Door")
@export var door_block: 	StaticBody2D
@export var door_sensor: 	Area2D

var imgInd = 0;
var imgNum = 0;
var image_speed = 0;
var door_name = "door";
var timer_door_lock = 0;
var timer_door_unlock = 0;
var timer_door_lock_instant = 0;
var text_x = 0;
var text_y = 0;
var check_for = "PlayerCombatActor";
@export var door_open_anim_name 	:= "door_open"
@export var door_close_anim_name 	:= "door_close"

@export var draw_door 		:= true;

@export var opening_range 	:= 24.0;
@export var opening_speed 	:= 6.0;

@export var sfx_open 		:= "";
@export var sfx_close 		:= "";


## Setup locking ##
@export_category("Setup locking")
@export var locked 				:= false;
var locked_sound 		:= 1;
var draw_locked 		:= true;
var alpha_lock 			:= 0;
var alpha_lock_goal 	:= 0;
@export var locked_text 		:= "Locked";

func _door_setup():
	speed_scale = opening_speed

func _door_open( _instant := false ):
	if sprite_frames.has_animation(door_open_anim_name):
		if _instant:
			stop()
			animation = door_open_anim_name
			frame = sprite_frames.get_frame_count(door_open_anim_name) - 1
			door_block.get_child( 0 ).disabled = true
		else:
			play( door_open_anim_name )
			await animation_finished
			door_block.get_child( 0 ).disabled = true
			stop()
			animation = door_open_anim_name
			frame = sprite_frames.get_frame_count(door_open_anim_name) - 1
	else:
		push_error( "Door doesnt have the correct animation %s." % door_open_anim_name )
	
func _door_close( _instant := false ):
	if sprite_frames.has_animation(door_close_anim_name):
		if _instant:
			stop()
			animation = door_close_anim_name
			frame = sprite_frames.get_frame_count(door_close_anim_name) - 1
			door_block.get_child( 0 ).disabled = false
		else:
			play( door_close_anim_name )
			await animation_finished
			door_block.get_child( 0 ).disabled = false
			stop()
			animation = door_close_anim_name
			frame = sprite_frames.get_frame_count(door_close_anim_name) -1 
	else:
		push_error( "Door doesnt have the correct animation %s." % door_close_anim_name )

func execute_event_user_0():
	pass

func execute_event_user_1():
	pass

func execute_event_user_2():
	pass
