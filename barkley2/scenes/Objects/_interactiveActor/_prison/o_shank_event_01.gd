extends B2_Event_Step_Trigger

@export var o_kunigundePrison01 	: B2_InteractiveActor
@export var o_sureshPrison01 		: B2_InteractiveActor
@export var o_moriarty_prison 		: B2_InteractiveActor
@export var o_pelekrytePrison01 	: B2_InteractiveActor

func _ready() -> void:
	if B2_Playerdata.Quest("prisonLiberated") == 3:
		queue_free()
	assert(o_kunigundePrison01)
	assert(o_sureshPrison01)
	assert(o_moriarty_prison)
	assert(o_pelekrytePrison01)

func _physics_process(_delta: float) -> void:
	is_active = B2_Playerdata.Quest("shankExecute") == 1
	if is_active:
		o_kunigundePrison01.hide()
		o_sureshPrison01.hide()
		o_moriarty_prison.hide()
		o_pelekrytePrison01.hide()
	
# Junklord invoke
func execute_event_user_0():
	B2_Screen.show_defeat_screen()
