extends B2_InteractiveActor

# silly stuff for variable´s hand
@export var ActorAnim_hands: AnimatedSprite2D

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
	ANIMATION_STAND_SPRITE_INDEX 	= [ 1, 1, 0, 0, 0, 0, 0, 1 ]
	ActorAnim.animation 	= ANIMATION_STAND

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
	if ActorAnim.sprite_frames.has_animation(_sprite_frame):
		ActorAnim.animation = _sprite_frame
		if _sprite_frame == "spanking" or _sprite_frame == "spankingHold":
			ActorAnim_hands.offset = ActorAnim.offset
			ActorAnim_hands.offset.x = -16 # HAAAAACK
			
			ActorAnim.flip_h = true
			ActorAnim_hands.flip_h = true
			ActorAnim_hands.visible = true
			ActorAnim_hands.animation = _sprite_frame
		else:
			ActorAnim.flip_h = false
			ActorAnim_hands.flip_h = false
			ActorAnim_hands.visible = false
	else:
		print("Actor " + str(self) + ": cinema_set() " + _sprite_frame + " not found" )

func cinema_playset( _sprite_frame : String, _sprite_frame_2 : String ): ## NOTE Not sure how to deal with this?
	if ActorAnim.sprite_frames.has_animation( _sprite_frame ):
		ActorAnim.sprite_frames.set_animation_loop( _sprite_frame, false )
		ActorAnim.sprite_frames.set_animation_speed( _sprite_frame, 15 )
		ActorAnim.play( _sprite_frame )
		
		if _sprite_frame == "spanking" or _sprite_frame == "spankingHold":
			ActorAnim.flip_h = true
			ActorAnim_hands.flip_h = true
			ActorAnim_hands.visible = true
			ActorAnim_hands.sprite_frames.set_animation_loop( _sprite_frame, false )
			ActorAnim_hands.sprite_frames.set_animation_speed( _sprite_frame, 15 )
			ActorAnim_hands.play( _sprite_frame )
		else:
			ActorAnim.flip_h = false
			ActorAnim_hands.flip_h = false
			ActorAnim_hands.visible = false
			
		await ActorAnim.animation_finished
		ActorAnim.animation = _sprite_frame_2
		if _sprite_frame == "spanking" or _sprite_frame == "spankingHold":
			await ActorAnim_hands.animation_finished
			ActorAnim_hands.animation = _sprite_frame_2
		return 
	else:
		print("Actor " + str(self) + ": cinema_playset() " + _sprite_frame + " not found" )
		return

func _child_process(_delta) -> void: # used to avoid overwriting the _process func.
	if movement_vector != last_movement_vector:
		if movement_vector.x > 0: # handle sprite mirroring
			ActorAnim_hands.flip_h = false
		else:
			ActorAnim_hands.flip_h = true
