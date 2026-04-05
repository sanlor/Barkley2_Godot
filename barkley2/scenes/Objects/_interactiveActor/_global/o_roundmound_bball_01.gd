extends AnimatedSprite2D

const O_ROUNDMOUND_HEAD_01 	= preload("uid://ccfvitkene6qv")
const THUNDER_STRIKE 		= preload("uid://bkoryvjnbck40")
const ANIM_TIMER 		:= 6.0

@onready var o_effect_pdt_candle: GPUParticles2D = $o_effect_pdt_candle
@onready var o_effect_pdt_candle_sub: GPUParticles2D = $o_effect_pdt_candle_sub

var direction	:= 0.0
var distance 	:= 0.0

func _ready() -> void:
	# Disable #
	if B2_Playerdata.Quest("roundmoundInitiate") >= 1:
		o_effect_pdt_candle.emitting = false
		o_effect_pdt_candle_sub.emitting = false
	else:
	# Light #
		o_effect_pdt_candle.emitting = true
		o_effect_pdt_candle_sub.emitting = true

func _make_lighting() -> void:
	var thunder := THUNDER_STRIKE.instantiate()
	add_sibling( thunder, true )
	thunder.position = position
	thunder.position += Vector2.from_angle(direction) * ( distance )
	
	direction 	-= 0.85 * 1
	distance 	+= 3.00 * 2
	#print( direction, distance )

func _spawn_round() -> void:
	var round_m : AnimatedSprite2D = O_ROUNDMOUND_HEAD_01.instantiate()
	add_sibling( round_m, true )
	round_m.position = position

func lighting_animation() -> void:
	var t := create_tween() ## Anim tween
	t.tween_callback( _make_lighting )
	t.tween_interval(2.0)
	for i in 16:
		t.tween_callback( _make_lighting )
		t.tween_interval(0.30)

# Lightning 
func execute_event_user_0():
	lighting_animation()
	
	## Replace itself with a new object, for some reason.
	var t := create_tween()
	t.tween_property(self, "self_modulate", Color.TRANSPARENT, 2.0)
	#push_error("TODO add o_roundmound_head01.")
	t.tween_callback( _spawn_round )
	
# Waves and sparkles gone 
func execute_event_user_1():
	o_effect_pdt_candle.emitting = false
	o_effect_pdt_candle_sub.emitting = false
