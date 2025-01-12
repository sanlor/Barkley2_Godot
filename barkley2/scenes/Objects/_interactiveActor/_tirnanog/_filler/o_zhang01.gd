extends B2_InteractiveActor

@onready var audio_stream_player_2d: 	AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var gpu_particles_2d: 			GPUParticles2D = $GPUParticles2D
@onready var timer: 					Timer = $Timer

var wait := 0.0

## Made with B2_TOOL_DWARF_CONVERTER
func _ready() -> void:
	_setup_actor()
	_setup_interactiveactor()
	
	#zhangState
		#0 - 11 = Different responses
		
	#govZhang
		#0 = No problem
		#1 = Able to arrest Zhang
		#2 = Zhang is sent to the hoosegow 
	
	if get_room_area() == "tnn":
		if B2_Playerdata.Quest("govZhang") >= 2:
			queue_free()
		else:
			# Confetti
			wait = 15.0
			
	if get_room_area() == "wst":
		if B2_Playerdata.Quest("govZhang") >= 2:
			queue_free()
	
	timer.start( wait )
	
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

func confetti() -> void:
	gpu_particles_2d.emitting = true

func _on_timer_timeout() -> void:
	confetti()
	timer.start( wait * randf_range(0.5, 1.0) )
	
	## Play confetti sounds.
	if is_instance_valid( B2_CManager.o_hoopz ):
		if B2_CManager.o_hoopz.position.distance_to( position ) < 100: # Only play when player is near.
			for i in 8:
				for r in randi_range( 0, 4 ): ## Add delays to the sound.
					await get_tree().physics_frame
				B2_Sound.play_pick( "bubblepop", 0.0, false, 1, randf_range( 0.75, 1.25 ) )
				
	#audio_stream_player_2d.stream = load( B2_Sound.get_sound_pick( "bubblepop" ) )
