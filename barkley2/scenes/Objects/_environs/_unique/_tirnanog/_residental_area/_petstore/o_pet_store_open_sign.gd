extends B2_Environ

var cl := [150,190,210,230,255]
var flicker := true

func _ready() -> void:
	## during curfew
	#if (scr_time_db("tnnCurfew") == "during") <- unused
	## Turn sign off during curfew
	
	## failed pet store quest
	if B2_ClockTime.time_gate() > 5 and B2_Playerdata.Quest("ericQuest") <= 6:
		frame = 1
		flicker = false
		
func _physics_process(_delta: float) -> void:
	if flicker:
		var c := cl.pick_random() as int
		modulate = Color(c, c, c)
