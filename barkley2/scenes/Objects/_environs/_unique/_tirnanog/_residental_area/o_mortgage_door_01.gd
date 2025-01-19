extends B2_Event_Step_Trigger

func _process( _delta: float) -> void:
	## Hate this, but need to check this every time.
	
	## Disable
	if B2_Config.get_user_save_data( "player.body", "butt" ) == "governor":
		queue_free()
	elif B2_Playerdata.Quest("wilmerPaymentFailure") >= 1 and B2_Playerdata.Quest("wilmerPaymentFailure") <= 3:
		queue_free()
	elif B2_Playerdata.Quest("duergarInfoWilmer") >= 2:
		queue_free()
	elif B2_Playerdata.Quest("wilmerEvict") == 3:
		queue_free()
	elif B2_Playerdata.Quest("wilmerEvict") == 8:
		queue_free()
	elif B2_Playerdata.Quest("wilmerEvict") == 9:
		queue_free()
	elif B2_Playerdata.Quest("wilmerEvict") == 10:
		queue_free()
	elif B2_Playerdata.Quest("wilmerEvict") == 11:
		queue_free()
	#elif instance_exists(o_mg_stealth_control):
	#	queue_free()
	elif B2_Playerdata.Quest("mortgageDoorCollided") == 0 and B2_Playerdata.Quest("mortgageOver") == 2:
		## Do not disable this.
		return 
	else:
		queue_free()
