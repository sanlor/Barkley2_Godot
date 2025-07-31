extends B2_Event_Step_Trigger

func _ready() -> void:
	B2_Playerdata.Quest("curfewCollision", 0);

	## Disable object ## If it's before curfew ##
	if B2_Playerdata.Quest("curfewAnnouncement") == 0:
		if B2_ClockTime.time_get() < 3:
			queue_free()
			
	## Disable object ## If it's during the curfew and this has already been activated before ##  
	elif B2_Playerdata.Quest("curfewAnnouncement") == 1:
		if B2_ClockTime.time_get() >= 3 and B2_ClockTime.time_get() < 5:
			queue_free()

	## Disable object ## Curfew announcment has been made already ##
	elif B2_Playerdata.Quest("curfewAnnouncement") == 2:
		queue_free()
