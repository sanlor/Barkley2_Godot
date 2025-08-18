extends B2_EnvironInteractive
### Man... this game....
# instance_create(x + 43, y, o_rightChair01);
# This object creates the other chair...
# WHY??? WHY??? Why not just add it in the editor?

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if B2_Playerdata.Quest("govTransfer") == 1:
		animation = "governorclamp"
	elif B2_Playerdata.Quest("govQuest") == 4 || B2_Playerdata.Quest("govQuest") == 6:
		animation = "governorclamp"
	else:
		animation = "empty"
