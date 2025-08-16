extends B2_InteractiveActor
## NOTE This actor animation is a bit janky. Cant replicate the original one easily.

## BIO Magician Ooze
#/* Variables
	#oozeState
		#0 = not talked
		#1 = talked
		#2 = talked to Ooze enough that you know he's a baller
	#oozeBall
		#0 = haven't offered to play
		#1 = haven't agreed to pay his fee
		#2 = agreed to pay his fee
		#3 = Reported back to Uschi about Ooze playing 
		#4 = Played with Ooze, game is over in TNN
	#uschiBall
		#2 = you are looking for a Baller to play with Uschi and yourself
		#3 = you have a baller

var timerfrm 	= 0;
var animfrm 	= 0;
var animInterv 	= 6;
var curImg 		= 0;

var frame_target := 0.0

## Made with B2_TOOL_DWARF_CONVERTER
func _ready() -> void:
	
	if get_room_name() == "r_tnn_businessDistrict01":
		if B2_Playerdata.Quest("oozeBall") >= 2: 		queue_free()
		elif B2_ClockTime.time_gate() >= 2.5: 			queue_free()
	elif get_room_name() == "r_tnn_bballcourt02":
		if B2_Playerdata.Quest("oozeBall") <= 1 : 		queue_free()

	_setup_actor()
	_setup_interactiveactor()

	ANIMATION_STAND 						= "default"
	ANIMATION_SOUTH 						= "s_puannumSE"
	ANIMATION_SOUTHEAST 					= "s_puannumSE"
	ANIMATION_SOUTHWEST 					= "s_puannumSE"
	ANIMATION_WEST 							= "s_puannumSE"
	ANIMATION_NORTH 						= "s_puannumNE"
	ANIMATION_NORTHEAST 					= "s_puannumNE"
	ANIMATION_NORTHWEST 					= "s_puannumNE"
	ANIMATION_EAST 							= "s_puannumSE"
	ANIMATION_STAND_SPRITE_INDEX 			= [0, 0, 1, 1, 2, 2, 2, 3]
	ActorAnim.animation 					= "default"
	
# Animations for Ooze
func execute_event_user_5():
	match ActorAnim.frame:
		14:
			if randf() < 0.5:
				ActorAnim.frame = 5
		24:
			if randf() < 0.4:
				frame_target = 29
		26:
			frame_target = 1 + randi_range(0,6)
		27:
			if randf() < 0.4:
				frame_target = 33
		30:
			frame_target = 1 + randi_range(0,6)

func _physics_process( delta: float ) -> void:
	if timerfrm < animInterv:
		timerfrm += 100.0 * delta
	else:
		timerfrm -= animInterv
		
		if ActorAnim.frame > frame_target:
			ActorAnim.frame -= 1
		elif ActorAnim.frame < frame_target:
			ActorAnim.frame += 1
		else:
			frame_target += 1

func _on_actor_anim_frame_changed() -> void:
	execute_event_user_5()
