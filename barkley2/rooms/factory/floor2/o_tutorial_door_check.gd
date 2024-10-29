extends B2_Event_Step_Trigger

@onready var o_door_tech_01: AnimatedSprite2D = $"../P6 - o_door_tech01"


func event_trigger( _node ):
	if B2_Playerdata.Quest("tutorialCollision", null, 0) == 2:
		if is_instance_valid(cutscene_script):
			B2_CManager.play_cutscene( cutscene_script, self, [] )

func execute_event_user_0():
	o_door_tech_01.locked = true
