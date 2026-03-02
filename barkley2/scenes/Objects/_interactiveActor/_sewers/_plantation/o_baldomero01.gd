extends B2_InteractiveActor

const O_BALDOMERO_01_PLAYING_DEAD = preload("uid://4yjmngl512ex")
const O_BALDOMERO_01_WAIT_HIM_OUT = preload("uid://t8h8gljhk4l7")

#Variables
	#baldoState
		#0 = never talked to 
		#1 = talked to, repeating choice to rummage through him (this activated the Suicide Note when you walk back in)
		#2 = rummaged through him, taking the paper or not
		#3 = end of states, he just "..."
		#4 = You grabbed the blank note or suicide note, traded it for Aug's note, and he's back to playing dead
		#5 = You got him to stand up, but did not find out he's Augustine
		#
	#baldoEscape
		#1 = ClockTime timer passed, he escaped
	#
	#baldoTimerAllow
		#1 = Allows the "fakeout" timer to occur, resets every time you touch baldo
		#2 = You faked Baldomero out, and the reveal cinema played
		#
	#baldoSeen
		#0 = Never seen Baldomero
		#1 = Seen him once
		#2 = Seen him twice
		#
	#baldoBlank
		#0 = you haven't taken the Blank Paper
		#1 = you have taken the Blank Paper
		#
	#baldoSuicide
		#0 = haven't picked up the suicide note
		#1 = picked up the suicide note

@onready var fake_dead_timer: Timer = $fake_dead_timer

## Made with B2_TOOL_DWARF_CONVERTER
func _ready() -> void:
	##TODO: how do we do time now with DSL? any different?
	if B2_Playerdata.Quest("baldoEscape") == 1 or B2_ClockTime.time_gate() >= 5 or B2_Playerdata.Quest("gelasioState") == 5:
		queue_free()
		
	if B2_Playerdata.Quest("baldoTimerAllow") != 1:
		fake_dead_timer.stop()
	else:
		fake_dead_timer.start()
		
	#TODO: add in animate for Baldomero to "fall flat" as you enter the room"
	#TODO: with @baldomeroState@ >= 1, set a timer of 60 seconds, if you stay in the room for 
	#    that long Baldo gets up and runs event_user(1)
	#TODO: when you walk back into this room from the room above, set baldomero to "fall flat" 
	#    again but drop a NOTE
		
	_setup_actor()
	_setup_interactiveactor()
	
	execute_event_user_0()

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

func _on_fake_dead_timer_timeout() -> void:
	fake_dead_timer.stop()
	ActorAnim.animation = "standing"
	execute_event_user_1()
	interaction()

# Encountering Baldomero ... playing dead
func execute_event_user_0():
	cutscene_script = O_BALDOMERO_01_PLAYING_DEAD
	
# Baldomero gets up after you "wait him out"
func execute_event_user_1() -> void:
	cutscene_script = O_BALDOMERO_01_WAIT_HIM_OUT
	
# Reset the "fake death" timer
func execute_event_user_10():
	fake_dead_timer.start()
