extends B2_InteractiveActor

const O_ERICFLY = preload("res://barkley2/scenes/Objects/_interactiveActor/_tirnanog/_vrden/o_ericfly.tscn")

@onready var audio_emitter: B2_AudioEmitter = $B2_AudioEmitter
@onready var flies: Node = $flies


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
	
	## Add stinky flies!
	
	## See if Eric should be in the room...
	if get_room_name() == "r_tnn_petshop02":
		if B2_Playerdata.Quest("ericQuest") < 9: # or (script_execute(scr_inside) == false) 
			queue_free()
	else:
		## Eric's in the market or at home / blockhouse
		if B2_Playerdata.Quest("ericQuest") >= 9:
			## Should be in Pet Shop
			queue_free()
			
		## If I'm outdoors
		elif not is_inside_room() and B2_Database.time_check("tnnCurfew") == "during":
			queue_free()
		## If I'm indoors
		elif is_inside_room() and B2_Database.time_check("tnnCurfew") != "during":
			queue_free()
		
		## Clocktime deactivation ##
		if B2_ClockTime.time_get() >= 6:
			queue_free()
		
	## Make flies
	if get_room_name() == "r_tnn_marketDistrict01" and B2_Database.time_check("tnnCurfew") != "during" or \
		get_room_name() == "r_tnn_boardinghouse01" and B2_Database.time_check("tnnCurfew") == "during":
			for i in randi_range( 4, 7 ):
				var f = O_ERICFLY.instantiate()
				flies.add_child( f, true )
	else:
		## Not stinky anymore.
		audio_emitter.queue_free()
		flies.queue_free()
