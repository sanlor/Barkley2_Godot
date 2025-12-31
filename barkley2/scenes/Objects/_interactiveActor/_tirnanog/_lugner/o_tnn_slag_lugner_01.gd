extends B2_Event_Step_Trigger

const O_TNN_SLAG_LUGNER_01_LEAVE 		:= preload("uid://bbkwiuwhl48h4")
const O_TNN_SLAG_LUGNER_01_PLEA 		:= preload("uid://ddpsfprc2ty0i")
const O_TNN_SLAG_LUGNER_01_REGULAR 		:= preload("uid://41o7lnuatrn5")

@export var curr_room := ""

func _ready() -> void:
	curr_room = get_parent().get_room_name()

## What a janky way to do this.
func _physics_process(_delta: float) -> void:
	if curr_room == "r_tnn_warehouse01":
		if B2_Playerdata.Quest("lugnerQuest") == 8:
			# Collision near lugner
			if position.y < 400:
				if B2_Playerdata.Quest("lugnerPlea") == 0:
					is_active = true
					event_0()
				else: is_active = false;
			# Collision to exit
			else:
				if B2_Playerdata.Quest("warehouseExit") == 0:
					is_active = true
					event_1(); ## Set script to unable to leave
				else: is_active = false;
		else: is_active = false;
	else:
		if B2_Playerdata.Quest("slagChase") != 1: is_active = false 
		else: is_active = true
	
func event_0() -> void:
	cutscene_script = O_TNN_SLAG_LUGNER_01_PLEA
	
func event_1() -> void:
	cutscene_script = O_TNN_SLAG_LUGNER_01_LEAVE
