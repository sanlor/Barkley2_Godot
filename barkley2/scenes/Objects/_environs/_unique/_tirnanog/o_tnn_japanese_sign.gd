extends B2_Environ

var anims 		:= true

func _ready() -> void:
	if B2_Database.time_check("tnnCurfew") == "during":
		anims = false
		frame = 2
		
func _physics_process(_delta: float) -> void:
	if anims:
		if randf() > 0.85:
			frame = 1
		else:
			frame = 0
		
		if randf() > 0.8:
			var c : int = [180,200,220,235,255].pick_random()
			modulate = Color.from_rgba8(c,c,c)
