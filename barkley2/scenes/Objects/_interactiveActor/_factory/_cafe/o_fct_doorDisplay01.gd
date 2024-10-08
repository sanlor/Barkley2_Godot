extends B2_InteractiveActor

func _ready() -> void:
	var x := global_position.x
	var y := global_position.y
	
	## Which animation to use ##
	if B2_Playerdata.Quest("dynamoeufLeft", null, 0) == 1 and x < 1600: 
		ActorAnim.play("dead")
	if B2_Playerdata.Quest("dynamoeufMiddle", null, 0) == 1 and x > 2000 and x < 2080: 
		ActorAnim.play("dead")
	if B2_Playerdata.Quest("dynamoeufLeft", null, 0) == 1 and B2_Playerdata.Quest("dynamoeufMiddle", null, 0) == 1: 
		ActorAnim.play("dead")
