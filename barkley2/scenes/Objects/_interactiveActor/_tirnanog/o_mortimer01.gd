extends B2_InteractiveActor

@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

## Made with B2_TOOL_DWARF_CONVERTER
func _ready() -> void:
	if B2_Database.time_check("tnnCurfew") == "during": queue_free()
	
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


func _on_actor_anim_frame_changed() -> void:
	if ActorAnim.animation == "default":
		if ActorAnim.frame == 0 or ActorAnim.frame == 17:
			audio_stream_player_2d.play()

# Checks if Hoopz has Mallows
func execute_event_user_9():
	B2_Playerdata.Quest("chocomallowsRecipeHas", int( B2_Candy.has_recipe("Choco-mallows") ) )
	
# Update count of vidcons for sale
func execute_event_user_10():
	if B2_Shop.check_stock("Mortimer's Candy Shop") == 0: 	B2_Playerdata.Quest("shopEmpty", 1)
	else: 												B2_Playerdata.Quest("shopEmpty", 0)
