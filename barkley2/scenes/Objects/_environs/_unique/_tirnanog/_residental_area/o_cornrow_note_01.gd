extends B2_EnvironInteractive

func execute_event_user_0(): 	
	# Give gun
	#scr_gun_db("juiceboxGun");
	B2_Gun.append_gun_to_bandolier( B2_Gun.get_gun_from_db("juiceboxGun") )
	
func execute_event_user_1(): 	
	is_interactive = false
