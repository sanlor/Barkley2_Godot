extends B2_InteractiveActor
## The Influence Ovum Charger
## TODO Fix the smoke effect.

var smkCol : Array[Color]

func _ready() -> void:
	match B2_Playerdata.Quest("dynamoeufHoopz", null, 0):
		0:
			play("broken_egg")
		1:
			play("broken_empty")
	
	smkCol.resize(3)
	# Smoke #
	smkCol[0] = Color8(80, 50, 50);
	smkCol[1] = Color8(90, 40, 40);
	smkCol[2] = Color8(100, 60, 20);
