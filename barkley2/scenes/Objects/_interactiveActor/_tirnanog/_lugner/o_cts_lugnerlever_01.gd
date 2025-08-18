extends B2_EnvironInteractive

@export var o_cts_container01 : B2_EnvironInteractive
@export var o_cts_container02 : B2_EnvironInteractive

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	execute_event_user_0()
	
	## Do stuff with containers
	# Lever interactive
	if B2_Playerdata.Quest("lugnerQuest") == 6:
		if B2_Playerdata.Quest("dwarfCustody") == 0:
			o_cts_container01.cinema_set("containerEmpty")
		else:
			o_cts_container01.cinema_set("containerDwarfed")
	elif B2_Playerdata.Quest("lugnerQuest") == 7 || B2_Playerdata.Quest("lugnerQuest") == 9:
		o_cts_container01.cinema_set("containerDestroyed");
	else:
		o_cts_container01.cinema_set("containerEmpty");

	## Slags container
	if B2_Playerdata.Quest("lugnerQuest") == 5:
		if B2_Playerdata.Quest("dwarfCustody") == 0:
			o_cts_container02.cinema_set("containerEmpty");
		else:
			o_cts_container02.cinema_set("containerDwarfed");

func execute_event_user_0():
	is_interactive = false
	
func execute_event_user_1():
	is_interactive = true
