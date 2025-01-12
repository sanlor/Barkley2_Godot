extends B2_InteractiveActor

## TODO Add Item functions - ITEM | Dragon Lord Gemstone | 1

@onready var audio_stream_player_2d: 	AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var timer: 					Timer = $Timer


## Made with B2_TOOL_DWARF_CONVERTER
func _ready() -> void:
	_setup_actor()
	_setup_interactiveactor()
	#The Crossword Guys Quest.
	#
	#crosswordQuest
		#0 - haven't talked to them
		#1 - declined the game
		#2 - accepted and won the game
		#3 - accepted and lost the game 
	## NOTE: You cannot try again if you win or lose.
	
	if not is_inside_room():
		if B2_Database.time_check("tnnCurfew") == "during":
			queue_free()
	else:
		if B2_Database.time_check("tnnCurfew") != "during":
			queue_free()
	
	timer.wait_time = 5
	timer.start()
	
	ActorAnim.play()
	
	ANIMATION_STAND 						= "default"
	ANIMATION_SOUTH 						= ""
	ANIMATION_SOUTHEAST 					= ""
	ANIMATION_SOUTHWEST 					= ""
	ANIMATION_WEST 							= ""
	ANIMATION_NORTH 						= ""
	ANIMATION_NORTHEAST 					= ""
	ANIMATION_NORTHWEST 					= ""
	ANIMATION_EAST 							= ""
	ANIMATION_STAND_SPRITE_INDEX 			= [0, 0, 0, 0, 0, 0, 0, 0]
	ActorAnim.animation 					= "default"

func execute_event_user_0():
	# not used in this port
	pass
	
func execute_event_user_5():
	pass

func _on_actor_anim_frame_changed() -> void:
	match ActorAnim.frame:
		1: ## right guy has an idea
			ActorAnim.frame = 2 + randi_range( 0, 12 )
		9: ## put down pencil in thought
			ActorAnim.frame = 4 + randi_range( 0, 8 )
		18: ## write
			var r := randi_range(0,99)
			if r <= 50:
				ActorAnim.frame = 11
			elif r <= 70:
				ActorAnim.frame = 9
		19:
			ActorAnim.frame = 8 + randi_range( 0, 30 )
			
	if randi_range(0,99) <= 10 and ActorAnim.frame >= 7 and ActorAnim.frame <= 17:
		audio_stream_player_2d.play()
