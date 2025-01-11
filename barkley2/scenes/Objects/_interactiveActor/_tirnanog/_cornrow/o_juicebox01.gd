extends B2_InteractiveActor

@onready var juice_coin_toss: AudioStreamPlayer2D = $JuiceCoinToss
@onready var juice_timer: Timer = $JuiceTimer


## TODO Time based stuff

## Made with B2_TOOL_DWARF_CONVERTER
func _ready() -> void:
	_setup_actor()
	_setup_interactiveactor()
	
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
	
	if B2_Playerdata.Quest("comServ") >= 7:
		queue_free()
		
	# Curfew stuff
	if B2_Database.time_check("tnnCurfew") != "before":
		queue_free()
	
	juice_timer.start( 3.0 * randf_range(0.70, 1.30) )
	
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


func _on_juice_timer_timeout() -> void:
	var rand := randi_range(0,99)
	
	if rand < 30:
		if randi_range(0,2) == 0:
			flip_coin()
		else:
			blink()
	elif rand >= 30 and rand < 70:
		blink()
		blink()
	else:
		flip_coin()
		flip_coin()
	juice_timer.start( 3.0 * randf_range(0.70, 1.30) )

func blink():
	ActorAnim.frame = 11
	await get_tree().create_timer(0.5).timeout
	ActorAnim.frame = 0
	
func flip_coin():
	var t := create_tween()
	t.set_parallel(true)
	t.tween_callback( juice_coin_toss.play )
	t.tween_method( ActorAnim.set_frame, 0, 10, 1.0 )
	await t.finished
