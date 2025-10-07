extends B2_EnvironInteractive
## NOTE First time I had to use the "BackBufferCopy" node. Neat.
# Without it, only one shader with "hint_screen_texture" can be active ar a time.

@onready var fuzzyness: ColorRect = $BackBufferCopy/fuzzyness

func _ready() -> void:
	speed_scale = randf_range(0.8,1.2)
	animation = "monitor"
	fuzzyness.visible = false
	if B2_Playerdata.Quest("switchPrison0") == 1:
		animation = "off"
	
func _physics_process(_delta: float) -> void:
	if animation == "monitor":
		if randf() > 0.98:
			fuzzyness.visible = not fuzzyness.visible

func _on_animation_changed() -> void:
	fuzzyness.visible = false
