extends ColorRect
## Scale range Y -203.0, -3.0

@onready var hud_weight_number: 	TextureRect = $hud_weight_number
@onready var texture_rect: 			TextureRect = $TextureRect
@onready var hud_weight_frame: 		TextureRect = $hud_weight_frame

var weight_tween : Tween

func _ready() -> void:
	B2_SignalBus.gun_changed.connect( set_weight )
	set_weight()

func set_weight() -> void:
	_set_weight( B2_Playerdata.player_stats.get_effective_stat( B2_HoopzStats.STAT_BASE_WEIGHT ) )
		
# Set the scale's weight display.
func _set_weight( weight : float ) -> void:
	#assert( weight >= 0.0 and weight <= 1.0, "value out of range") ## DEPRECATED
	if weight_tween:
		weight_tween.kill()
	weight_tween = create_tween()
	var value := -203.0 + (weight * 2) ## -203 is the size of the scale.
	## NOTE i just noticed that I usually just add a bunch of operations / offsets until things line up. Took about 20 minutes for me to come up with "-203.0 + (weight * 2)".
	
	weight_tween.tween_property( hud_weight_number, "position:y", value, 0.75 ).set_trans( Tween.TRANS_CUBIC )
	
