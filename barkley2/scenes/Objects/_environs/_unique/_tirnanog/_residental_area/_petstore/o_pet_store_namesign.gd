extends B2_Environ

var cl := [170,190,210,230,255]
var is_off := false

func _ready() -> void:
	#if ClockTime() > 5 and B2_Playerdata.Quest("ericQuest") <= 6:
	#	is_off = true
	pass

func _physics_process(delta: float) -> void:
	if is_off:
		animation = "off"
	else:
		var c := cl.pick_random() as int
		modulate = Color(c, c, c)
