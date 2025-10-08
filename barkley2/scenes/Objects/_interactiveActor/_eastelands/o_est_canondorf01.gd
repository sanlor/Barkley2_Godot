extends B2_InteractiveActor

# MAIN QUEST aka mainQuest
	#0 = Game begun
	#1 = Tutorial over
	#2 = Escaped TNN, one way or another
	#3 = Reached BCT, one way or another
	#4 = Found BCT Longinus
	#5 = Visited Cuchu's Lair
	#6 = Met Cyberdwarf
	#7 = Identity chosen
	#8 = Reached Cuchu's Lair with Cdwarf
	#9 = Beyond the point of no return
#
	#canondorfState
		#0 = Not spoken to before
		#1 = Spoken to before 
		#2 = Recouping from a reading
		#3 = Devastated by the beaast 666
		#
	#canondorfReadings = counts the times you have purchased a reading, get a free token with your third reading

## Made with B2_TOOL_DWARF_CONVERTER
func _ready() -> void:
	# Vidcon reward #
	B2_Playerdata.Quest( "gamename", B2_Vidcon.get_vidcon_name( 34 ) );
	
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

# Get vidcon # Macrosoft Pen Buddy
func execute_event_user_0():
	B2_Vidcon.give_vidcon( 34 )
