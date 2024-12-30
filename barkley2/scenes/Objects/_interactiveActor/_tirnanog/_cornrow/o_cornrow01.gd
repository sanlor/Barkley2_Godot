extends B2_InteractiveActor

## NOTE This character has a very complex animation based on random chance.
# fuck that, its just random now.
# what a mess.

@onready var eye_timer: Timer = $EyeTimer

## Made with B2_TOOL_DWARF_CONVERTER
func _ready() -> void:
	_setup_actor()
	_setup_interactiveactor()
	
	if B2_Playerdata.Quest("comServ") >= 7:
		queue_free()
		
	#if (scr_time_db("tnnCurfew") != "before") then scr_event_interactive_deactivate();
	
	ANIMATION_STAND 						= "default"
	ANIMATION_SOUTH 						= "s_constantineSE"
	ANIMATION_SOUTHEAST 					= "s_constantineSE"
	ANIMATION_SOUTHWEST 					= "s_constantineSE"
	ANIMATION_WEST 							= "s_constantineSE"
	ANIMATION_NORTH 						= "s_constantineNE"
	ANIMATION_NORTHEAST 					= "s_constantineNE"
	ANIMATION_NORTHWEST 					= "s_constantineNE"
	ANIMATION_EAST 							= "s_constantineSE"
	ANIMATION_STAND_SPRITE_INDEX 			= [1, 1, 0, 0, 0, 0, 0, 1]
	ActorAnim.animation 					= "default"
	
	eye_timer.start( 3.0 * randf_range(0.5, 1.30) )
	
	#cornrowState
		#0 - haven't talked to Cornrow
		#1 - have talked to Cornrow, triggered by a collision event
#
	#comServ - determines your current position in the Community Service quest
		#0 = not active
		#1 = rejected
		#2 = need to break into house
		#3 = break-in complete
		#4 = need to rob store
		#5 = robbery complete
		#6 = need to kill vivian
		#7 = vivian dead
		#8 = mission complete
		
func execute_event_user_3():
	## Get cornrows gun
	#scr_gun_db("cornrowGun");
	pass

func _on_eye_timer_timeout() -> void:
	
	var rand := randi_range(0,9)
	
	if rand < 3:
		blink()
	else:
		shift_eye()
	eye_timer.start( 3.0 * randf_range(0.5, 1.30) )

func blink():
	ActorAnim.frame = 5
	await get_tree().create_timer(0.5).timeout
	ActorAnim.frame = 0
	
func shift_eye():
	var rand := randi_range(0,9)
	
	if rand < 3:
		ActorAnim.frame = 2
		await get_tree().create_timer(0.5).timeout
		ActorAnim.frame = 1
	elif rand >= 3 and rand < 7:
		ActorAnim.frame = 4
		await get_tree().create_timer(0.5).timeout
		ActorAnim.frame = 3
	else:
		ActorAnim.frame = 5
		await get_tree().create_timer(0.5).timeout
		ActorAnim.frame = 0
		
