@icon("res://barkley2/assets/b2_original/images/merged/sDoorSlab.png")
extends AnimatedSprite2D
class_name B2_DOOR_PARENT

## Setup ##
@export_category("Setup Door")
@export var door_block: 	StaticBody2D
@export var door_sensor: 	Area2D
@export var door_name 		:= "door";
@export var sound_emiter	: AudioStreamPlayer2D

var imgInd = 0;
var imgNum = 0;
var image_speed = 0;

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
@export var opening_speed 	:= 12.0;

@export var sfx_open 		:= "";
@export var sfx_close 		:= "";


## Setup locking ##
@export_category("Setup locking")
@export var locked 				:= false; ## door will not open automatically
@export var stick_open			:= false; ## door will not close automatically
var locked_sound 				:= 1;
var draw_locked 				:= true;
var alpha_lock 					:= 0;
var alpha_lock_goal 			:= 0;
@export var locked_text 		:= "Locked";

func _door_setup():
	speed_scale = opening_speed
	
	assert(door_sensor, "door_sensor not loaded.")
	door_sensor.set_collision_mask_value(7, true) # Player Envirm
	door_sensor.set_collision_mask_value(5, true) # NPCs
	door_sensor.set_collision_mask_value(2, true) # Player

func door_open( _instant := false ):
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
			
			if not sfx_open.is_empty():
				if sound_emiter.playing:
					sound_emiter.stop()
				var audio_track = B2_Sound.get_sound( sfx_open )
				sound_emiter.stream = ResourceLoader.load( audio_track, "AudioStream" )
				sound_emiter.play()
	else:
		push_error( "Door doesnt have the correct animation %s." % door_open_anim_name )
	
func door_close( _instant := false ):
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
			
			if not sfx_close.is_empty():
				if sound_emiter.playing:
					sound_emiter.stop()
				var audio_track = B2_Sound.get_sound( sfx_close )
				sound_emiter.stream = ResourceLoader.load( audio_track, "AudioStream" )
				sound_emiter.play()
	else:
		push_error( "Door doesnt have the correct animation %s." % door_close_anim_name )

func execute_event_user_0():
	pass

func execute_event_user_1():
	pass

func execute_event_user_2():
	pass
