# This triggers when you try to walk to the Terlet... you are unable to get there unless you talk to D'archimedes first
extends B2_Event_Step_Trigger

##VARIABLES
	#darchimedesLineState
		#0 = first time you've checked tried to walk into the terlet area
		#1 = you've collided again... and talked to D'archimedes a second time
		#2 = a third time... you just peep at the terlet and then go on your way
	#prisonQuest
		#0 = have not advanced the quest at all
		#1 = starts when the cell doors close after the Bolthios Scene (must "restpause")
		#2 = on room load after restpausing in bed, initiate 20 minutes until state = 3
		#3 = Hoopz can now restpause to next hour
		#4 = Hoopz has restpaused, initiate 20 minutes until state = 5
		#5 = Hoopz can now restpause to next hour
		#6 = Hoopz has restpaused, initiate 20 minutes until state = 7
		#7 = Hoopz is at the end of his (gut) rope
		#8 = you've escaped one way or another (this deactivates all collisions)

@export var o_darchimedesPrison01 : B2_InteractiveActor
var enable_hook := false

func _ready() -> void:
	assert( o_darchimedesPrison01 )
	# Deactivate if prison is liberated
	if B2_Playerdata.Quest("prisonLiberated") == 3:
		queue_free()

func _physics_process(_delta: float) -> void:
	# Disable if the Shank Event isn't active
	is_active = B2_Playerdata.Quest("prisonQuest") == 8

func execute_event_user_0():
	enable_hook = true
