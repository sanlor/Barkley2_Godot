extends B2_InteractiveActor

##Turald's Fishgut's Quest
##turaldState
	#0 - Not talked to
	#1 - Talked to, haven't helped (repeating)
	#2 - Declined to help, turald will disappear in 2 hours
	#3 - Agreed to help
	#4 - Turald dissappears
##turaldFailSafe
	#0 - failsafe off
	#1 - if you agree to help Turald AFTER declining once, this turns on to keep the turaldState = 4 from deactivaing
	#
##fishgutQuest 
	#0 - Quest not active
	#1 - Get fishgut's'
	#2 - Thrown down 5, need 10
	#3 - Thrown down 10, need 20
	#4 - Thrown down 20, need 40
	#5 - Thrown down 40, Turald has died    

## Made with B2_TOOL_DWARF_CONVERTER
func _ready() -> void:
	if B2_ClockTime.time_get() >= 7:
		queue_free()
	if B2_Playerdata.Quest("turaldState") == 4:
		queue_free()
	if B2_Playerdata.Quest("turaldState") == 5:
		ActorAnim.animation = "pulledLast"
		is_interactive = false
	else:
		_setup_actor()
		_setup_interactiveactor()
		ActorAnim.play("default")

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
