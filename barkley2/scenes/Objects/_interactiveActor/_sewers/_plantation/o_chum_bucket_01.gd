extends B2_EnvironInteractive

func _ready() -> void:
	## Clocktime ##
	if B2_ClockTime.time_gate() >= 10:
		B2_Playerdata.Quest("chumBucket", 1);
	else:
		B2_Playerdata.Quest("chumBucket", 0);

	## Animation ##
	if B2_Playerdata.Quest("chumBucket") == 1:
		frame = 1
	else:
		frame = 0
