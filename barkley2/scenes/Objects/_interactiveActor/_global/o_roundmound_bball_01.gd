extends AnimatedSprite2D

@onready var o_effect_pdt_candle: GPUParticles2D = $o_effect_pdt_candle
@onready var o_effect_pdt_candle_sub: GPUParticles2D = $o_effect_pdt_candle_sub

func _ready() -> void:
	# Disable #
	if B2_Playerdata.Quest("roundmoundInitiate") >= 1:
		o_effect_pdt_candle.emitting = false
		o_effect_pdt_candle_sub.emitting = false
	else:
	# Light #
		o_effect_pdt_candle.emitting = true
		o_effect_pdt_candle_sub.emitting = true
