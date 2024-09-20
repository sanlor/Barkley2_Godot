extends B2_InteractiveActor

# silly stuff for variable´s hand
@export var o_variable_01_hands: AnimatedSprite2D

func _ready() -> void:
	## Animation
	ANIMATION_STAND				= "default"
	ANIMATION_SOUTH 			= "s_variableDown01"
	ANIMATION_SOUTHEAST 		= "s_variableDown01"
	ANIMATION_SOUTHWEST 		= "s_variableDown01"
	ANIMATION_WEST 				= "s_variableDown01"
	ANIMATION_NORTH 			= "s_variableDown01"
	ANIMATION_NORTHEAST 		= "s_variableDown01"
	ANIMATION_NORTHWEST 		= "s_variableDown01"
	ANIMATION_EAST 				= "s_variableDown01"
	animatedsprite.animation 	= ANIMATION_STAND

func execute_event_user_0():
	#/// Weapon brandish stuff
	#// This is called after he brandishes his weapon!
	#// Variable Walking (currently all using the down direction only!)
	pass

func execute_event_user_2():
	# ///Destroy Variable in DSL Events
	queue_free()

func execute_event_user_10():
	# /// DSL - Talk
	push_warning("Event not set")

func cinema_set( _sprite_frame : String ):
	if animatedsprite.sprite_frames.has_animation(_sprite_frame):
		animatedsprite.animation = _sprite_frame
		if _sprite_frame == "spanking" or _sprite_frame == "spankingHold":
			animatedsprite.flip_h = true
			o_variable_01_hands.flip_h = true
			o_variable_01_hands.visible = true
			o_variable_01_hands.animation = _sprite_frame
		else:
			animatedsprite.flip_h = false
			o_variable_01_hands.flip_h = false
			o_variable_01_hands.visible = false
	else:
		print("Actor " + str(self) + ": cinema_set() " + _sprite_frame + " not found" )

func cinema_playset( _sprite_frame : String, _sprite_frame_2 : String ): ## NOTE Not sure how to deal with this?
	if animatedsprite.sprite_frames.has_animation( _sprite_frame ):
		animatedsprite.sprite_frames.set_animation_loop( _sprite_frame, false )
		animatedsprite.sprite_frames.set_animation_speed( _sprite_frame, 15 )
		animatedsprite.play( _sprite_frame )
		
		if _sprite_frame == "spanking" or _sprite_frame == "spankingHold":
			animatedsprite.flip_h = true
			o_variable_01_hands.flip_h = true
			o_variable_01_hands.visible = true
			o_variable_01_hands.sprite_frames.set_animation_loop( _sprite_frame, false )
			o_variable_01_hands.sprite_frames.set_animation_speed( _sprite_frame, 15 )
			o_variable_01_hands.play( _sprite_frame )
		else:
			animatedsprite.flip_h = false
			o_variable_01_hands.flip_h = false
			o_variable_01_hands.visible = false
			
		await animatedsprite.animation_finished
		animatedsprite.animation = _sprite_frame_2
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
