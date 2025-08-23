extends B2_EnvironInteractive
## https://youtu.be/lnpeKS1XoVY?t=10888

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func execute_event_user_0():
	B2_Playerdata.Quest("bctBookpile", 1);

func execute_event_user_1():
	B2_Playerdata.Quest("bctBookpile", 2);
	
func execute_event_user_2():
	B2_Playerdata.Quest("bctBookpile", 3);
	
func execute_event_user_3():
	B2_Playerdata.Quest("bctBookpile", 0);
