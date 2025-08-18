extends B2_InteractiveActor
## Absalom, the L.O.N.G.I.N.U.S. Cryptodog

@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

#Variables
#absalomState
	#0 = never talked
	#1 = talked
#govQuest
	#0 = no quest
	#1 = rejected the quest for now
	#2 = accepted the quest, looking for Urine
	#3 = have urine
	#4 = ready to become governor
	#5 = am the governor, attempting to do speech
	#6 = finished speech
#absalomLetter
	#0 = haven't heard about letters
	#1 = he mentions letters but you need one more to get it done
	#2 = you know that Absalom is a Cryptodog and you can give him letters
#absalomJoad
	#0 = haven't given Absalom a Joad NOTE
	#1 = given him the Tattered Paper
	#2 = given him the Dead Soldier's Note
	#3 = given him the Joad's Note

## Made with B2_TOOL_DWARF_CONVERTER
func _ready() -> void:
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
	
	ActorAnim.play("typing")


func _on_actor_anim_frame_changed() -> void:
	if ActorAnim.animation == "typing":
		if not audio_stream_player_2d.playing:
			audio_stream_player_2d.play()
