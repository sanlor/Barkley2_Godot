extends ColorRect

@onready var hud_periodic_amount: ProgressBar = $hud_periodic_amount

# Lazy man. Its aaaaall fake!
## 03/03/25 Fuck you past me. its useful now!
## This will represent the player action meter, used during battles for moving and defending.

const LOW_GAUGE_COLOR 	:= Color("300203")
const HIGH_GAUGE_COLOR 	:= Color("b01a1d")
const FULL_GAUGE_COLOR 	:= Color("fb6b61")

var gauge_amount 	:= 12.0 + randf_range(1.0,6.0)

func _physics_process(_delta: float) -> void:
	gauge_amount  = B2_Playerdata.player_stats.get_curr_action()
	
	## Fun animation
	if gauge_amount < hud_periodic_amount.max_value:
		if randf() > 0.9:
			gauge_amount *= randf_range(0.95, 1.05)
			
		if randf() > 0.7:
			## Smooth color transition.
			hud_periodic_amount.modulate 		= LOW_GAUGE_COLOR.lerp( HIGH_GAUGE_COLOR, gauge_amount / 100.0 ) * randf_range(0.975, 1.15)
			hud_periodic_amount.modulate.a 		= 1.0
	else:
		# Gauge Full! Blink blink
		hud_periodic_amount.modulate = [FULL_GAUGE_COLOR, HIGH_GAUGE_COLOR].pick_random()
	
	hud_periodic_amount.value = gauge_amount
