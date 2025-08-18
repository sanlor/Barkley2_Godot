extends B2_InteractiveActor
## Kelpster, the grape loving motherfucker...

#// VARIABLES //
#/* 
#govKelpster 
	#0 = Nothing 
	#1 = Have talked to Kelpster, aka determined he is riff raff
	#2 = As Governor you've sent Kelpster to the Hoosegow 
	#
#kelpsterState (when talked to as X1, not gov)
	#0 = Never talked to Kelpster before
	#1 = Talked to before, offers the game again
	#2 = Offers game for Money or Fruit
	#3 = Bought the game with money
	#4 = Bought the game with fruits    
	#*/
#// Below GOVERNOR1 used to be used for kelp == 0 or == 1, it's all GOVERNOR2 now

## Made with B2_TOOL_DWARF_CONVERTER
func _ready() -> void:
	B2_Playerdata.Quest( "gamename", B2_Vidcon.get_vidcon_name(5) )
	if B2_Playerdata.Quest("govKelpster") >= 2:
		queue_free()
		
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

func execute_event_user_0():
	B2_Vidcon.give_vidcon(5)
