extends B2_InteractiveActor

@onready var o_door_tech_01: AnimatedSprite2D = $"../P6 - o_door_tech01"

var disabled := false

func _ready() -> void:
	if B2_Playerdata.Quest("tutorialProgress", null, 0) >= 5:
		ActorAnim.play("flipped")
		is_interactive = false
		disabled = true
	else:
		ActorAnim.play("default")

func execute_event_user_0():
	if disabled:
		return
	ActorAnim.play("flipped")
	is_interactive = false
	cutscene_script = null # unload script for safety
	o_door_tech_01._door_open()
	o_door_tech_01.locked = false