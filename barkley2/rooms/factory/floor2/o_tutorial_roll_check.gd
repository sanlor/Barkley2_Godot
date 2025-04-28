@tool
extends B2_Event_Step_Trigger

# used to check if all the light bulbs were broken.

@onready var o_door_tech_01: AnimatedSprite2D = $"../P5 - o_door_tech01"


func _ready() -> void:
	if B2_Playerdata.Quest("tutorialCollision", null, 0) >= 1:
		queue_free()
		
func event_trigger( _node ):
	
	if B2_Playerdata.Quest("tutorialCollision", null, 0) == 0:
		B2_Playerdata.Quest("tutorialCollision", 1)
		B2_Playerdata.Quest("zaneState", 3)
		o_door_tech_01.locked = true
		print("o_tutorial_rollCheck activated!")
		queue_free()
