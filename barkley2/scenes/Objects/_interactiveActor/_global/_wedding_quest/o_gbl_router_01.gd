extends B2_EnvironInteractive

@onready var timer_reboot: Timer = $timer_reboot

# Area check #
var routerId := 0;

# The state the routers can be in.
# 0 = Broken
# 1 = Off
# 2 = Working

func _ready() -> void:
	if get_parent() is B2_ROOMS:
		match get_parent().get_room_area():
			"air": 
				routerId = 0
				if B2_Playerdata.Quest("routerAir") == 0:	play("routerYellow"); 
				elif B2_Playerdata.Quest("routerAir") == 1:	play("routerOff");
				elif B2_Playerdata.Quest("routerAir") == 2:	play("routerGreen");
			"bct": 
				routerId = 1
				if B2_Playerdata.Quest("routerBct") == 0:	play("routerYellow"); 
				elif B2_Playerdata.Quest("routerBct") == 1:	play("routerOff");
				elif B2_Playerdata.Quest("routerBct") == 2:	play("routerGreen");
			"est": 
				routerId = 2
				if B2_Playerdata.Quest("routerEst") == 0:	play("routerYellow"); 
				elif B2_Playerdata.Quest("routerEst") == 1:	play("routerOff");
				elif B2_Playerdata.Quest("routerEst") == 2:	play("routerGreen");
			"wst": 
				routerId = 3
				if B2_Playerdata.Quest("routerWst") == 0:	play("routerYellow"); 
				elif B2_Playerdata.Quest("routerWst") == 1:	play("routerOff");
				elif B2_Playerdata.Quest("routerWst") == 2:	play("routerGreen");
			"swp": 
				routerId = 4
				if B2_Playerdata.Quest("routerSwp") == 0:	play("routerYellow"); 
				elif B2_Playerdata.Quest("routerSwp") == 1:	play("routerOff");
				elif B2_Playerdata.Quest("routerSwp") == 2:	play("routerGreen");
			"usw": 
				routerId = 5
				if B2_Playerdata.Quest("routerUsw") == 0:	play("routerYellow"); 
				elif B2_Playerdata.Quest("routerUsw") == 1:	play("routerOff");
				elif B2_Playerdata.Quest("routerUsw") == 2:	play("routerGreen");
			_: push_error(name, ": Invalid location for router ID.")

func execute_event_user_0():
	B2_Sound.play("hoopz_click")
	## Break
	match routerId:
		0: B2_Playerdata.Quest("routerAir", 0);
		1: B2_Playerdata.Quest("routerBct", 0);
		2: B2_Playerdata.Quest("routerEst", 0);
		3: B2_Playerdata.Quest("routerWst", 0);
		4: B2_Playerdata.Quest("routerSwp", 0);
		5: B2_Playerdata.Quest("routerUsw", 0);
		_: push_error(name, ": Invalid router ID.")
		
func execute_event_user_1(): 
	B2_Sound.play("hoopz_click")
	## OFF
	match routerId:
		0: B2_Playerdata.Quest("routerAir", 1); B2_Playerdata.Quest("routerAirReady", 1);
		1: B2_Playerdata.Quest("routerBct", 1); B2_Playerdata.Quest("routerBctReady", 1);
		2: B2_Playerdata.Quest("routerEst", 1); B2_Playerdata.Quest("routerEstReady", 1);
		3: B2_Playerdata.Quest("routerWst", 1); B2_Playerdata.Quest("routerWstReady", 1);
		4: B2_Playerdata.Quest("routerSwp", 1); B2_Playerdata.Quest("routerSwpReady", 1);
		5: B2_Playerdata.Quest("routerUsw", 1); B2_Playerdata.Quest("routerUswReady", 1);
		_: push_error(name, ": Invalid router ID.")
	_ready()

func execute_event_user_2():
	B2_Sound.play("hoopz_click")
	## Working
	match routerId:
		0: if B2_Playerdata.Quest("routerAirReady") == 2: B2_Playerdata.Quest("routerAir", 2)
		1: if B2_Playerdata.Quest("routerBctReady") == 2: B2_Playerdata.Quest("routerBct", 2)
		2: if B2_Playerdata.Quest("routerEstReady") == 2: B2_Playerdata.Quest("routerEst", 2)
		3: if B2_Playerdata.Quest("routerWstReady") == 2: B2_Playerdata.Quest("routerWst", 2)
		4: if B2_Playerdata.Quest("routerSwpReady") == 2: B2_Playerdata.Quest("routerSwp", 2)
		5: if B2_Playerdata.Quest("routerUswReady") == 2: B2_Playerdata.Quest("routerUsw", 2)

	## Working for realz
	match routerId:
		0: if B2_Playerdata.Quest("routerAirReady") == 2: B2_Playerdata.Quest("routerAirReady", 3)
		1: if B2_Playerdata.Quest("routerBctReady") == 2: B2_Playerdata.Quest("routerBctReady", 3)
		2: if B2_Playerdata.Quest("routerEstReady") == 2: B2_Playerdata.Quest("routerEstReady", 3)
		3: if B2_Playerdata.Quest("routerWstReady") == 2: B2_Playerdata.Quest("routerWstReady", 3)
		4: if B2_Playerdata.Quest("routerSwpReady") == 2: B2_Playerdata.Quest("routerSwpReady", 3)
		5: if B2_Playerdata.Quest("routerUswReady") == 2: B2_Playerdata.Quest("routerUswReady", 3)

	## Too early, it doesn't work ##
	match routerId:
		0: if B2_Playerdata.Quest("routerAirReady") <= 1: B2_Playerdata.Quest("routerAir", 0)
		1: if B2_Playerdata.Quest("routerBctReady") <= 1: B2_Playerdata.Quest("routerBct", 0)
		2: if B2_Playerdata.Quest("routerEstReady") <= 1: B2_Playerdata.Quest("routerEst", 0)
		3: if B2_Playerdata.Quest("routerWstReady") <= 1: B2_Playerdata.Quest("routerWst", 0)
		4: if B2_Playerdata.Quest("routerSwpReady") <= 1: B2_Playerdata.Quest("routerSwp", 0)
		5: if B2_Playerdata.Quest("routerUswReady") <= 1: B2_Playerdata.Quest("routerUsw", 0)
	
	_ready()
	
func execute_event_user_15():
	B2_Sound.play("hoopz_click")
	timer_reboot.start()

func _on_timer_reboot_timeout() -> void:
	match routerId:
		0: B2_Playerdata.Quest("routerAirReady", 2);
		1: B2_Playerdata.Quest("routerBctReady", 2);
		2: B2_Playerdata.Quest("routerEstReady", 2);
		3: B2_Playerdata.Quest("routerWstReady", 2);
		4: B2_Playerdata.Quest("routerSwpReady", 2);
		5: B2_Playerdata.Quest("routerUswReady", 2);
		_: push_error(name, ": Invalid router ID.")
	print("o_gbl_router01: Reset timer finished.")
