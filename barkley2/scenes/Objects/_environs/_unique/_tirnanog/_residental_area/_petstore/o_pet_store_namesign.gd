#@tool
extends B2_Environ

var cl := [170,190,210,230,255]
var is_off := false

func _ready() -> void:
	## DIsabled if quest failed or during curfew.
	if B2_ClockTime.time_gate() > 5 and B2_Playerdata.Quest("ericQuest") <= 6 or B2_Database.time_check("tnnCurfew") == "during":
		is_off = true

func _physics_process(_delta: float) -> void:
	if is_off:
		animation = "off"
		modulate = Color.WHITE
	else:
		var c := cl.pick_random() as int
		modulate = Color8(c, c, c)
