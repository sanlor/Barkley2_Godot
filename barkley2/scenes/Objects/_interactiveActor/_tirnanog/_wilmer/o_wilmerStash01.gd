extends B2_EnvironInteractive

func _ready() -> void:
	if B2_Playerdata.Quest("wilmerItemsTaken") != 0:
		animation = "taken6"

func execute_event_user_0() -> void:
	## Get GUNS and BUTTERSCOTCH filled up
	B2_Gun.append_gun_to_bandolier( B2_Gun.get_gun_from_db("wilmerGun", "WILM") )
	B2_Gun.append_gun_to_bandolier( B2_Gun.get_gun_from_db("estherGun", "ESTR") )
	B2_Candy.add_candy_recipe("Butterscotch")
	B2_Candy.gain_candy("Butterscotch")
