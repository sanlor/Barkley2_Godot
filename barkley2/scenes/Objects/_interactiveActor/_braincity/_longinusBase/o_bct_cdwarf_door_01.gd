extends B2_EnvironInteractive


@onready var static_body_2d: StaticBody2D = $StaticBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if B2_Playerdata.Quest("wiglafMission") >= 4:
		play("open")
		execute_event_user_2()
	else:
		animation = "locked"

func execute_event_user_2():
	static_body_2d.queue_free()
	is_interactive = false
