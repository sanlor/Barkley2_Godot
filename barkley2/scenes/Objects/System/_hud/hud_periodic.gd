extends ColorRect

@onready var hud_periodic_amount: ColorRect = $hud_periodic_amount

# Lazy man. Its aaaaall fake!

const GAUGE_FULL 	:= 30.0
const GAUGE_COLOR 	:= Color("400405")
var gauge_amount 	:= 12.0 + randf_range(1.0,6.0)

func _physics_process(_delta: float) -> void:
	if randf() > 0.9:
		if is_node_ready(): # avoid some stupid warnings.
			hud_periodic_amount.size.y 		= gauge_amount * randf_range(0.95, 1.05)
		
	if randf() > 0.7:
		hud_periodic_amount.color 		= GAUGE_COLOR * randf_range(0.975, 1.15)
		hud_periodic_amount.color.a 	= 1.0
