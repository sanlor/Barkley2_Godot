extends B2_EnvironInteractive

var vidconIndex := 42;

func _ready() -> void:
	B2_Playerdata.Quest( "gamename", B2_Vidcon.get_vidcon_name(vidconIndex) )

	# Don't appear if game has been picked up #
	if B2_Playerdata.Quest("governorGame") == 1:
		queue_free()

# VIDCON: GET VIDCON
func execute_event_user_0():
	B2_Vidcon.give_vidcon(vidconIndex)
	queue_free()
