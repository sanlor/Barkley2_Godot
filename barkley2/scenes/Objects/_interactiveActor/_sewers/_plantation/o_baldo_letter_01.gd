extends B2_EnvironInteractive

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@export var o_baldomero01 : B2_InteractiveActor

func _ready() -> void:
	if B2_Playerdata.Quest("baldoSeen") == 0 or B2_Playerdata.Quest("baldoTimerAllow") == 1:
		queue_free()

	B2_Playerdata.Quest("baldoLetterDropped", 1);

	## Picked up the suicide note ##
	if B2_Playerdata.Quest("baldoSuicideNote") >= 1:
		queue_free()
		
	##TODO: TURN this on when entering this room with baldoState == 1, and baldoBlank != 1
	##TODO: remove this from the game when @baldoSuicideNote@ == 2
	
	if o_baldomero01 and B2_Playerdata.Quest("baldoSeen") == 0:
		B2_Playerdata.Quest("baldoSeen", 1)
	elif B2_Playerdata.Quest("baldoSeen") == 1:
		B2_Playerdata.Quest("baldoSeen", 2)
	
	animation_player.play("float")
