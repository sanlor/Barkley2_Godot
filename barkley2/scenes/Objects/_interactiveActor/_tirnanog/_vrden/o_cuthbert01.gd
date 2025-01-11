extends B2_InteractiveActor

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

	#cuthbertState
		#0 = Never talked to before
		#1 = Talked to once before 
		#
	#ericQuest
		#0 = Eric hasn't been spoken to.
		#1 = Eric's quest has been rejected.
		#2 = Eric's quest has been accepted.
		#3 = you've found the pet store and talked to the owner.
		#4 = you've told Eric about the resume but still need to do it.
		#5 = you've finished the resume.
		#6 = cuthbert hated your resume.
		#7 = cuthbert liked the resume a little.
		#8 = cuthbert liked the resume a lot.
		#9 = you've completed the quest and gotten your reward, eric in petshop
