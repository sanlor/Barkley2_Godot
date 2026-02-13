extends Marker2D
## Untamo manager and spawner

const O_MG_VRW_OBJECT 		:= preload("uid://5w6yk4d6sf0j")

@onready var chat_messages: B2_Minigame_VRW_Messages = $"../chat_messages"

var untamo := []

func _ready() -> void:
	var rand_untamos := randi_range(15, 25)
	untamo.resize( rand_untamos )
	
	for i : int in randi_range(15, 25):
		var _untamo := O_MG_VRW_OBJECT.instantiate()
		
		## Starting position ##
		var random_x := randi_range(-32, 1440 + 32);
		var random_y := randi_range(128, 288 - 16);

		## Creation and ID ##
		untamo[i] = O_MG_VRW_OBJECT.instantiate()
		untamo[i].position = Vector2(random_x, random_y)
		untamo[i].my_identity = i;
		
		add_sibling.call_deferred( untamo[i], true )
