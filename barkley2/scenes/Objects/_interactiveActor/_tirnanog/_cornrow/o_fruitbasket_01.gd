extends B2_EnvironInteractive

const O_ERICFLY = preload("uid://o7tybmqditvd")

func _ready() -> void:
	if B2_Playerdata.Quest("fruitbasketTake") != 0: queue_free()
	B2_Playerdata.Quest("fruitbasketRotten", 0)
	
	## Took too long, its rotten.
	if B2_Database.time_check("tnnCurfew") != "before":
		modulate = Color.SADDLE_BROWN
		B2_Playerdata.Quest("fruitbasketRotten", 1);
		for i in randi_range( 4, 7 ):
			var f = O_ERICFLY.instantiate()
			add_child( f, true )

func execute_event_user_0():
	is_interactive = false
	hide()
