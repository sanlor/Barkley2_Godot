## Deveraux in the Industrial Park
extends B2_Duergar

#VARIABLES
	#deverauxState
		#0 = haven't talked to Deveraux
		#1 = have talked to Deveraux
		#2 = get attacked if you talk to him

## Made with B2_TOOL_DWARF_CONVERTER
func _ready() -> void:
	duergar_name 							= "deveraux"
	_setup_actor()
	_setup_interactiveactor()
	
	# Patrol #
	if B2_Playerdata.Quest("deverauxState") == 3:
		execute_event_user_10()
		queue_free()
	
	ANIMATION_STAND 						= "s_deveraux01"
	ANIMATION_SOUTH 						= "s_deverauxSE"
	ANIMATION_SOUTHEAST 					= "s_deverauxSE"
	ANIMATION_SOUTHWEST 					= "s_deverauxSE"
	ANIMATION_WEST 							= "s_deverauxSE"
	ANIMATION_NORTH 						= "s_deverauxNE"
	ANIMATION_NORTHEAST 					= "s_deverauxNE"
	ANIMATION_NORTHWEST 					= "s_deverauxNE"
	ANIMATION_EAST 							= "s_deverauxSE"
	ANIMATION_STAND_SPRITE_INDEX 			= [1, 1, 0, 0, 0, 0, 0, 1]
	ActorAnim.animation 					= "s_deveraux01"

## Deveraux attacks
func execute_event_user_1():
	#with o_deveraux01 scr_event_interactive_deactivate();
	#Duergar("spawn", "deveraux", o_deveraux01.x, o_deveraux01.y);
	breakpoint

## Patroller
func execute_event_user_10():
	# instance_create(x, y, o_deveraux_patrol);
	breakpoint
