extends B2_EnvironInteractive

## The Fishing Pole you can either Buy or Earn
#Variables
	#benedictPoleBuy
		#0 = haven't bought or "earned" the pole yet
		#1 = have earned the pole

func _ready() -> void:
	var keep := 0
	
	if B2_ClockTime.time_get() >= 6.2 && B2_ClockTime.time_get() < 8.5 && B2_Playerdata.Quest("benedictPole") == 0:
		keep = 1
		
	if keep == 0:
		queue_free()
		
func execute_event_user_1():
	queue_free()
