extends B2_InteractiveActor

# silly stuff for variable´s hand
@onready var o_variable_01_hands: AnimatedSprite2D = $o_variable01_hands

func _ready() -> void:
	## Animation
	ANIMATION_STAND			= "default"
	ANIMATION_SOUTH 		= "s_variableDown01"
	ANIMATION_SOUTHEAST 	= "s_variableDown01"
	ANIMATION_SOUTHWEST 	= "s_variableDown01"
	ANIMATION_WEST 			= "s_variableDown01"
	ANIMATION_NORTH 		= "s_variableDown01"
	ANIMATION_NORTHEAST 	= "s_variableDown01"
	ANIMATION_NORTHWEST 	= "s_variableDown01"
	ANIMATION_EAST 			= "s_variableDown01"
	animation = ANIMATION_STAND

func cinema_set( _sprite_frame : String ):
	if sprite_frames.has_animation(_sprite_frame):
		animation = _sprite_frame
		if _sprite_frame == "spanking" or _sprite_frame == "spankingHold":
			flip_h = true
			o_variable_01_hands.flip_h = true
			o_variable_01_hands.visible = true
			o_variable_01_hands.animation = _sprite_frame
		else:
			flip_h = false
			o_variable_01_hands.flip_h = false
			o_variable_01_hands.visible = false
	else:
		print("Actor " + str(self) + ": cinema_set() " + _sprite_frame + " not found" )

func cinema_playset( _sprite_frame : String, _sprite_frame_2 : String ): ## NOTE Not sure how to deal with this?
	if sprite_frames.has_animation( _sprite_frame ):
		sprite_frames.set_animation_loop( _sprite_frame, false )
		sprite_frames.set_animation_speed( _sprite_frame, 15 )
		play( _sprite_frame )
		
		if _sprite_frame == "spanking" or _sprite_frame == "spankingHold":
			flip_h = true
			o_variable_01_hands.flip_h = true
			o_variable_01_hands.visible = true
			o_variable_01_hands.sprite_frames.set_animation_loop( _sprite_frame, false )
			o_variable_01_hands.sprite_frames.set_animation_speed( _sprite_frame, 15 )
			o_variable_01_hands.play( _sprite_frame )
		else:
			flip_h = false
			o_variable_01_hands.flip_h = false
			o_variable_01_hands.visible = false
			
		await animation_finished
		animation = _sprite_frame_2
		if _sprite_frame == "spanking" or _sprite_frame == "spankingHold":
			await o_variable_01_hands.animation_finished
			o_variable_01_hands.animation = _sprite_frame_2
		return 
	else:
		print("Actor " + str(self) + ": cinema_playset() " + _sprite_frame + " not found" )
		return

func _child_process(_delta) -> void: # used to avoid overwriting the _process func.
	if movement_vector != last_movement_vector:
		if movement_vector.x > 0: # handle sprite mirroring
			o_variable_01_hands.flip_h = false
		else:
			o_variable_01_hands.flip_h = true
