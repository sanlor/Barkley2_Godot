#@tool
extends B2_Environ

var cl := [150,190,210,230,255]
var flicker := true

func _ready() -> void:
	## failed pet store quest ## during curfew
	if (B2_ClockTime.time_gate() > 5 and B2_Playerdata.Quest("ericQuest") <= 6) or B2_Database.time_check("tnnCurfew") == "during":
		frame = 1
		flicker = false
	else:
		frame = 0
		
func _physics_process(_delta: float) -> void:
	if flicker:
		var c := cl.pick_random() as int
		modulate = Color8(c, c, c)
