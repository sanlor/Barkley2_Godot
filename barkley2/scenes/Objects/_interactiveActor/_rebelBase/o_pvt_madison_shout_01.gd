extends B2_Event_Step_Trigger

const O_PVT_MADISON_SHOUT_01_BOMB 	:= preload("uid://brbpjgfq1ic8i")
const O_PVT_MADISON_SHOUT_01_GOV 	:= preload("uid://bfyfbrm1wvgqx")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if B2_Playerdata.Quest("duergarInfoLonginus") >= 1:
		queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if B2_Playerdata.Quest("govQuest") == 2 && B2_Playerdata.Quest("pvtMadisonShout") == 0 && B2_Playerdata.Quest("govBomb") == 0:
		if not is_active:
			is_active = true
			cutscene_script = O_PVT_MADISON_SHOUT_01_BOMB
	elif B2_CManager.curr_BODY == B2_CManager.BODY.GOVERNOR && B2_Playerdata.Quest("governorRebelLeave") == 0:
		if not is_active:
			is_active = true
			cutscene_script = O_PVT_MADISON_SHOUT_01_GOV
	else:
		is_active = false
		cutscene_script = null
