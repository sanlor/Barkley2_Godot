extends B2_EnvironInteractive

## TODO Add Candies

func execute_event_user_0(): 	
	push_warning("Candy system is not implemented.")
	B2_Sound.play("sn_tubercular01")
	## Candy make ##
	# Drop("candy", x, y - 6, 5);

	## Eternal candy... ##
	# with oPickUpCandy 
		# timer = 99999;
		# z = 10;
		
func execute_event_user_1(): 	
	## Not used in the godot port.
	pass
