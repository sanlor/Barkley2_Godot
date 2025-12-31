extends B2_InteractiveActor
## NOTE This actor has a ton of unused dialog stuff.

@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var timer: Timer = $Timer

## Speaking to Abdul-Gafur before Jinrich or Gumshoe Trigger
## usage: scr_tnn_abdul_gafur01

#variables
	#abdulState
		#0 = not talked
			#if time is before 23:00, he just repeats
		#1 = talked to him before 23:00
		#2 = talked to him after 23:00, repeating Dialogue
		#3 = he's offered you the Cyberspear Piece, go to event 1
		#4 = Scammed, closed down shop 
		#
	#abdulOffer
		#0 = haven't offered the spear
		#1 = turn on the offer
		#2 = have offered the spear for BIG MONEY
		#3 = have offered the spear for LIL MONEY
		#4 = have offered the spear for HALF MONEY
		#5 = purchased the spear fully, waiting for it
		#6 = purchased the first half of the spear, waiting for it
		#7 = spear is available to be picked up
		#8 = arrived too late and now need to go buy it from Zola
		#9 = purchased the spear, upset at it's less than valuable state, repeating

var player_is_near := false

## Made with B2_TOOL_DWARF_CONVERTER
func _ready() -> void:
	## Open the shop only on roomload/create, otherwise you will get to a situation where the place opens up and Abdul talks to Gelasio who isn't there.
	if B2_ClockTime.time_gate() >= 1: B2_Playerdata.Quest("abdulOpen", 2)
	
	_setup_actor()
	_setup_interactiveactor()

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
	
	ActorAnim.play()
	timer.start( randf_range(4,8) )

## Abdul stops cleaning if the player is near.timer.start( randf_range(4,8) )
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is B2_Player_FreeRoam or body is B2_InteractiveActor_Player:
		player_is_near = true

## Abdul stops cleaning if the player is near.
func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is B2_Player_FreeRoam or body is B2_InteractiveActor_Player:
		player_is_near = false
		ActorAnim.play()

func _on_actor_anim_animation_finished() -> void:
	if player_is_near:
		timer.start( randf_range(8,12) )
	else:
		timer.start( randf_range(4,8) )

func _on_actor_anim_frame_changed() -> void:
	if ActorAnim.frame >= 4 and ActorAnim.frame <= 11:
		if audio_stream_player_2d.playing:
			return
		else:
			audio_stream_player_2d.play()

func _on_timer_timeout() -> void:
	ActorAnim.play()
