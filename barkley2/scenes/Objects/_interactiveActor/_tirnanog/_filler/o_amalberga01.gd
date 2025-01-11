extends B2_InteractiveActor

## TODO Add time based events and curfew.

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

	### Hildeburge Sleeping
	#scr_entity_animation_define("hildeSleeping", s_hildeberga02, 0, 15, ANIMATION_DEFAULT_SPEED * 0.6);
	#
	## Activation & Deactivation for Curfew
	if B2_Database.time_check("tnnCurfew") == "during" and not is_inside_room():
		queue_free()
	if B2_Database.time_check("tnnCurfew") != "during" and is_inside_room():
		queue_free()
		
	if is_inside_room():
		ActorAnim.animation = "inside"
