extends B2_EnvironInteractive

@onready var static_body_2d: StaticBody2D = $StaticBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if B2_Playerdata.Quest("wiglafMission") >= 3:
		play("open")
		execute_event_user_1()
	else:
		animation = "locked"

func execute_event_user_1():
	is_interactive = false
	static_body_2d.queue_free()
