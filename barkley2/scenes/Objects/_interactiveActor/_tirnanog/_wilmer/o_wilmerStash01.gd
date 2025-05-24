extends B2_EnvironInteractive

func _ready() -> void:
	if B2_Playerdata.Quest("wilmerItemsTaken") != 0:
		animation = "taken6"

func execute_event_user_0() -> void:
	## Get GUNS and BUTTERSCOTCH filled up
	B2_Gun
	#scr_gun_db("wilmerGun");
	#scr_gun_db("estherGun");
	#//scr_gun_db("wilmerPax1");
	#//scr_gun_db("wilmerPax2");
	B2_Candy.add_candy_recipe("Butterscotch")
	B2_Candy.gain_candy("Butterscotch")
	#repeat (99) scr_items_add(scr_items_db_getCopyOfItem("Butterscotch"));
	pass
