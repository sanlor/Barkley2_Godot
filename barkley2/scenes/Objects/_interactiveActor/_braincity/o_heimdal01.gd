extends B2_InteractiveActor

## Heimdal the Warrior Robot

#heimdalState
	#0 - haven't met Heimdal
	#1 - talked to Heimdal once
	#2 - talked to Heimdal twice (repeating)

## Made with B2_TOOL_DWARF_CONVERTER
func _ready() -> void:
	_setup_actor()
	_setup_interactiveactor()
	
	## Old Code from GML
	#/*ANIMATIONS
	#scr_entity_animation_define("heimdalDeath", s_heimdalSplode, 0, 0, 0);
	#if Quest("heimdalState") == 3 {  
		#scr_entity_animation_set(o_heimdal01, "heimdalDeath");
	
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
