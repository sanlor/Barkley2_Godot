extends B2_EnvironInteractive

func _ready() -> void:
	B2_Playerdata.Quest( "gamename", B2_Vidcon.get_vidcon_name(5) )

	# Don't appear if game has been picked up //
	if B2_Playerdata.Quest("kelpsterGame") == 1: queue_free()

	# ... Kelpster is NOT sent to the Hoosegow
	if B2_Playerdata.Quest("govKelpster") < 2: queue_free()

	# Don't appear if game has been bought //
	if B2_Playerdata.Quest("kelpsterState") >= 3: queue_free()
	
func execute_event_user_0():
	B2_Vidcon.give_vidcon(5)
