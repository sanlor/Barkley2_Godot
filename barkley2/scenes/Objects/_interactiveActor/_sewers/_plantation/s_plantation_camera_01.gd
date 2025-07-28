extends B2_Environ

@onready var timer: Timer = $Timer

var on := true

func _ready() -> void:
	## Cam is fudged up after robbery ##
	if get_parent() is B2_ROOMS:
		var room : B2_ROOMS = get_parent()
		if room.get_room_area() == "r_tnn_businessDistrict01":
			if B2_Playerdata.Quest("gutterhoundQuest") >= 7 or B2_Database.time_check("tnnCurfew") == "during" or B2_Database.time_check("tnnCurfew") == "after":
				on = false

func _on_animation_finished() -> void:
	timer.start( randf_range(1.0, 5.0) )

func _on_timer_timeout() -> void:
	if frame == 0:
		play("default")
	elif frame == 5:
		play_backwards("default")
