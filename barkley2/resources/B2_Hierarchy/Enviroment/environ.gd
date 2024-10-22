extends AnimatedSprite2D
class_name B2_Environ

signal set_played

enum SHAPES{ CIRCLE, SQUARE }

var is_playingset 	:= false

func cinema_set(anim_name : String):
	if sprite_frames.has_animation( anim_name ):
		animation = anim_name
	else:
		push_warning( "Node %s has no animation called %s" % [name, anim_name] )
		
func cinema_playset( _sprite_frame : String, _sprite_frame_2 : String, _speed := 15.0 ): ## NOTE Not sure how to deal with this?
	if sprite_frames.has_animation( _sprite_frame ):
		is_playingset = true
		animation = _sprite_frame
		sprite_frames.set_animation_loop( _sprite_frame, false )
		sprite_frames.set_animation_speed( _sprite_frame, _speed )
		play( _sprite_frame )
		await animation_finished
		animation = _sprite_frame_2
		is_playingset = false
		set_played.emit()
		return 
	else:
		push_error("Actor " + str(self) + ": cinema_playset() " + _sprite_frame + " not found" )
		return

## Function checks if the node is doing anything
## Return void right awai if itsd idle. Await for a signal if its busy.
func check_actor_activity() -> void:
	if is_playingset:
		# is playing some animation.
		await set_played
		return
	else:
		# not doing anything important
		return
