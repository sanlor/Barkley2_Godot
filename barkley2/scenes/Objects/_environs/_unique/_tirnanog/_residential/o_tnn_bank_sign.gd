extends B2_Environ

var animWait := 0.0
var is_on	:= true

func _ready() -> void:
	
	
	if is_on:
		pass
	else:
		modulate = Color.from_rgba8(64,64,64,255)
		frame = 0

func _physics_process(delta: float) -> void:
	if is_on:
		if animWait > 0.0:
			animWait -= delta
		else:
			if randf() < 0.6:
				frame = 1
				animWait = 2.0 + randf_range(0.0,8.0)
			else:
				frame = 0
				animWait = 1.0 + [ randf_range(0.0,4.0), randf_range(0.0,10.0), randf_range(0.0,20.0) ].pick_random()
		var c : int = [180, 200, 220, 235, 255].pick_random()
		modulate = Color.from_rgba8(c,c,c)
	
