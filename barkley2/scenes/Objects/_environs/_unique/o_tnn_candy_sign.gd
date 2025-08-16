extends B2_Environ

var anims 		:= true
var flashoff 	:= false

var flash_tween : Tween

func _ready() -> void:
	if B2_Database.time_check("tnnCurfew") == "during":
		anims = false
		frame = 2
	else:
		frame = 0
		
	if not anims:
		modulate = Color.GRAY
		
func _physics_process(_delta: float) -> void:
	if anims:
		if randf() > 0.90:
			var c : int = [180,200,220,235,255].pick_random()
			modulate = Color.from_rgba8(c,c,c)
		if randf() > 0.99: # Sometimes, flash the sign
			self_modulate = Color.WHITE * randf_range(0.6,5.0)
			if flash_tween: flash_tween.kill()
			flash_tween = create_tween()
			flash_tween.tween_property( self, "self_modulate", Color.WHITE, 1.0 )
