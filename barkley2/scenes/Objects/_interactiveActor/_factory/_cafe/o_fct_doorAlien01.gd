extends AnimatedSprite2D

func _ready() -> void:
	if B2_Playerdata.Quest("tutorialGunking") == 1:
		lock()

func lock():
	animation = "busted"

func cinema_set(anim_name : String):
	if sprite_frames.has_animation( anim_name ):
		animation = anim_name
	else:
		push_warning( "Node %s has no animation called %s" % [name, anim_name] )
		
func cinema_playset( _sprite_frame : String, _sprite_frame_2 : String, _speed := 15.0 ): ## NOTE Not sure how to deal with this?
	if sprite_frames.has_animation( _sprite_frame ):
		animation = _sprite_frame
		sprite_frames.set_animation_loop( _sprite_frame, false )
		sprite_frames.set_animation_speed( _sprite_frame, _speed )
		play( _sprite_frame )
		await animation_finished
		animation = _sprite_frame_2
		return 
	else:
		push_error("Actor " + str(self) + ": cinema_playset() " + _sprite_frame + " not found" )
		return

func _on_animation_changed() -> void:
	if animation == "busted":
		lock()
