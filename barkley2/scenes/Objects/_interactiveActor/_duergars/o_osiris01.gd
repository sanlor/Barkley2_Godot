## Osiris, Member of Dungarees
extends B2_Duergar

#VARIABLES
	#osirisState
		#0 = haven't talked to Osiris
		#1 = have talked to Osiris (you have a chance to aggro him)
		#2 = repeating dialogue until a certain ClockTime

## Made with B2_TOOL_DWARF_CONVERTER
func _ready() -> void:
	duergar_name 							= "osiris"
	_setup_actor()
	_setup_interactiveactor()
	
	# Patrol #
	if B2_Playerdata.Quest("osirisState") == 3:
		execute_event_user_10()
		queue_free()

	ANIMATION_STAND 						= "s_osiris01"
	ANIMATION_SOUTH 						= "s_osirisSE"
	ANIMATION_SOUTHEAST 					= "s_osirisSE"
	ANIMATION_SOUTHWEST 					= "s_osirisSE"
	ANIMATION_WEST 							= "s_osirisSE"
	ANIMATION_NORTH 						= "s_osirisNE"
	ANIMATION_NORTHEAST 					= "s_osirisNE"
	ANIMATION_NORTHWEST 					= "s_osirisNE"
	ANIMATION_EAST 							= "s_osirisSE"
	ANIMATION_STAND_SPRITE_INDEX 			= [1, 1, 0, 0, 0, 0, 0, 1]
	ActorAnim.animation 					= "s_osiris01"

## Osiris attacks
func execute_event_user_1():
	#with o_osiris01 scr_event_interactive_deactivate();
	#Duergar("spawn", "osiris", o_osiris01.x, o_osiris01.y);
	breakpoint
	
## Patroller
func execute_event_user_10():
	#instance_create(x, y, o_osiris_patrol);
	breakpoint
