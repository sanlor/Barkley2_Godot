extends B2_InteractiveActor

## Made with B2_TOOL_DWARF_CONVERTER
func _ready() -> void:
	## Only exists post curfew ##
	if get_room_area() == "tnn":
		if B2_Database.time_check("tnnCurfew") == "before" or B2_Database.time_check("tnnCurfew") == "during": queue_free()
	elif B2_Playerdata.Quest("griegState") >= 2: queue_free()

	# Event for Grieg, random dwarf waiting for the train, not knowing there isn't one.
	# From my design document: "Just a random dwarf hanging around Tir na nog. He can't get his mind around the fact that he's imprisoned there."
	## NOTE: See also the event_tnn_kojima01 script. Kojima sells fake train tickets which you can buy and sell to Grieg for a loss. You can only do this once.

	## NOTE2: ^^ very cool. would like to see thos design documents.
	
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
