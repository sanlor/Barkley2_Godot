@abstract
extends Node2D
class_name B2_Prop

## Godot
@export var animatedsprite : AnimatedSprite2D

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
		animatedsprite.animation = _sprite_frame
	else:
		push_error("Actor " + str(self) + ": cinema_set() " + _sprite_frame + " not found" )

func cinema_playset( _sprite_frame : String, _sprite_frame_2 : String ): ## NOTE Not sure how to deal with this?
	if animatedsprite.sprite_frames.has_animation( _sprite_frame ):
		animatedsprite.sprite_frames.set_animation_loop( _sprite_frame, false )
		animatedsprite.sprite_frames.set_animation_speed( _sprite_frame, 15 )
		animatedsprite.play( _sprite_frame )
		await animatedsprite.animation_finished
		animatedsprite.animation = _sprite_frame_2
		return 
	else:
		push_error("Actor " + str(self) + ": cinema_playset() " + _sprite_frame + " not found" )
		return
