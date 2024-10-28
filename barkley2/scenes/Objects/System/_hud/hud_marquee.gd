extends ColorRect

@onready var hud_marquee_text: Label = $hud_marquee_text

const MARQUEE_SIZE := 154.0
const MARQUEE_SPEED := 16.0

func _physics_process(delta: float) -> void:
	hud_marquee_text.position.x = wrapf(hud_marquee_text.position.x - MARQUEE_SPEED * delta, -MARQUEE_SIZE + 222, 222 * 1.75 )
