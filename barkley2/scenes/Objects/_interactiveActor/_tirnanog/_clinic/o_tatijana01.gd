extends B2_InteractiveActor

@onready var timer: Timer = $Timer
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

## Tatijana the Doctor
#Variables
	#tatijanaState
		#0 - never talked
		#1 - talked, haven't told her your Amnesia
		#2 - talked, told her your amnesia, now wait 55 minutes until you can advance
		#3 - the time period is over, you can talk to her, advances if you've drank grape
		#4 - repeating dialog after you've been told about the Transhumanism procedure
		#5 - prepping the table, will tell you to leave and come back later
		#6 - ready to perform the surgery

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

## Transhumanism value
func execute_event_user_2():
	## TODO WARNING CRITICAL This is wrong.
	B2_Playerdata.Quest("transhumanism", B2_Playerdata.player_stats.get_base_stat(B2_HoopzStats.STAT_BASE_RESISTANCE_CYBER) );
	
## Transhumanism change
func execute_event_user_3():
	pass
	#/// Transhumanism change
	#var humBio = scr_savedata_get("player.humanism.bio");
	#var humCyb = scr_savedata_get("player.humanism.cyber");
	#if (humBio > 20) 
	#{ 
	#humCyb += 20;
	#humBio -= 20;
	#}
	#else
	#{
	#humCyb += humBio;
	#humBio = 0;
	#}
	#scr_savedata_put("player.humanism.bio", humBio);
	#scr_savedata_put("player.humanism.cyber", humCyb);


func _on_timer_timeout() -> void:
	ActorAnim.speed_scale = randf_range(0.85,1.50)
	ActorAnim.play()

func _on_actor_anim_frame_changed() -> void:
	if ActorAnim.frame == 5:
		audio_stream_player_2d.play()

func _on_actor_anim_animation_finished() -> void:
	timer.start( randf_range(2.0,10.0) )
