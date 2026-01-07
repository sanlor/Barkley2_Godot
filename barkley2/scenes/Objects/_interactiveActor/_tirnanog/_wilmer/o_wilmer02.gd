extends B2_InteractiveActor

## Made with B2_TOOL_DWARF_CONVERTER
func _ready() -> void:
	if 	B2_Playerdata.Quest("wilmerEvict") != 2 and \
		B2_Playerdata.Quest("wilmerEvict") != 3 and \
		B2_Playerdata.Quest("wilmerEvict") != 8 and \
		B2_Playerdata.Quest("wilmerEvict") != 9:
		queue_free()
		
	_setup_actor()
	_setup_interactiveactor()
	
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

## New function -> hide Wilmer.
func execute_event_user_0():
	var t := create_tween()
	self_modulate.a = 1.0
	t.tween_property(self, "self_modulate:a", 0.0, 1.0)
