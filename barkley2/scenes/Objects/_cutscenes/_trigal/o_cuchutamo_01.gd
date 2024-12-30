extends B2_InteractiveActor

func _ready() -> void:
	#ActorAnim.play("default")
	_setup_actor()
	_setup_interactiveactor()
	
	var txt := "Sure! I have a map! I don't really need it anymore since I have it perfectly memorized. Do you want it? I'll sell it to you for `w1`ummm._._._`w0` `kw`@money_dubreMap01@ neuroshekels!`rt`"
	print("test @")
	print( txt.count("@") ) 
