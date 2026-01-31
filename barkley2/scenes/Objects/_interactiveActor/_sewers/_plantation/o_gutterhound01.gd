extends B2_InteractiveActor
## 16/08/25 Bank breaking is probably broken. still need to figure a way to inject data into cutscene scripts.

## Intial Meeting with Gutterhound

#Variable
	#gutterhoundQuest 
		#0 = Gutterhound hasn't been spoken to.
		#1 = You talked to him but haven't listened to Gutterhound's scheme.
		#2 = You refuse Gutterhound's offer.
		#3 = You've refused Gutterhound's offer twice. Can't get it again.
		#4 = Gutterhound's quest has been accepted.  Gutterhound and Marquee will remind Hoopz to get back to talk to Gutterhound
		#5 = You've nominated to hide in the safe house
		#6 = You've nominated to forgoe the safehouse
		#7 = Gutterhound has robbed the bank with you
		#8 = Gutterhound robbed the bank without you
		
const O_GUTTERHOUND_01_INITIAL = preload("uid://degbu30jeb7dm")

@export var o_tnn_BankSign : Node2D
@export var s_plantation_camera01 : Node2D
@export var bank_door : B2_DOOR_PARENT

## Made with B2_TOOL_DWARF_CONVERTER
func _ready() -> void:
	## Gone when curfew starts, since he is the one who causes it // // Gone if you rob the bank with him //
	if get_room_name() == "r_tnn_businessDistrict01":
		if B2_Database.time_check("tnnCurfew") == "during" or B2_Database.time_check("tnnCurfew") == "after": queue_free()
		if B2_Playerdata.Quest("gutterhoundQuest") >= 7: queue_free()
	
	if B2_Playerdata.Quest("gutterEscape") >= 1:
		ActorAnim.animation = "gone"
		
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
	
	execute_event_user_0()

func execute_event_user_0():
	cutscene_script = O_GUTTERHOUND_01_INITIAL

## This is most likelly broken
func execute_event_user_9():
	B2_Playerdata.Quest("timeRobbery", B2_Database.time_check("tnnCurfew")) ## This is probably wrong.
	B2_Playerdata.Quest("timeRobberyString", B2_Database.time_check("tnnCurfew")) ## This is probably wrong.
	# Disabled below. Clock display doesnt exist yet.
	## B2_Playerdata.Quest("timeRobberyDifferenceString", ClockTime("display", (scr_time_db("get", "tnnCurfew") - ClockTime("get")) * 3600));

# Shut down camera and bank sign
func execute_event_user_10():
	o_tnn_BankSign.is_on 			= false
	s_plantation_camera01.is_on 	= false
	## ^^ will probably cause a crash. lol.
	
# unset rigid (not used).
func execute_event_user_11():
	pass

# alpha fade (TODO)
func execute_event_user_12():
	pass
	
# alpha fade (TODO)
func execute_event_user_13():
	pass
	
# ///Is this used? Set quest
func execute_event_user_14():
	B2_Playerdata.Quest("gutterEscape", 1);
	
# Open the bank door
func execute_event_user_15():
	bank_door.stick_open = true
	bank_door.locked = false
	bank_door.door_open()
