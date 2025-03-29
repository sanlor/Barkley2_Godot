extends AnimatedSprite2D
## Explosion VFX. its simple, but it works.
# check o_effect_explosion, scr_fx_explosion_createFromType and o_FX

@onready var explosion_sfx: AudioStreamPlayer2D = $explosion_sfx

var explosion_sfx_name 		:= "explosion_generic_0"

var delay					:= 0.0

## Most of these are usused.
# check o_effect_explosion step event.
var init_RadiusMin 			:= 0;
var init_Radius 			:= 0;
var init_Pow 				:= 0;
var init_Interval 			:= 0;
var init_Shake 				:= 0;
var init_Height 			:= 0;

var att_Time 				:= 0;
var att_TimeRand 			:= 0;
var att_RadiusMinGain 		:= 0;
var att_RadiusGain 			:= 0;
var att_PowGain 			:= 0;
var att_PowRand 			:= 0;
var att_IntervalGain 		:= 0;
var att_IntervalRand 		:= 0;
var att_HeightGain 			:= 0;
var att_HeightRand 			:= 0;
var att_AccelX 				:= 0;
var att_AccelY 				:= 0;
var att_AccelZ 				:= 0;

func _ready() -> void:
	var _pow = init_Pow + randi_range(0, att_PowRand);
	if _pow<=16:
		animation = "s_effect_explo_16"
	elif _pow<=24:
		animation = "s_effect_explo_24"
	elif _pow<=32:
		animation = "s_effect_explo_32"
	elif _pow<=48: 
		animation = "s_effect_explo_48"
	else:
		animation = "s_effect_explo_96"
		
	sprite_frames.set_animation_loop( animation, false )
	scale *= 16.0 / float(init_Radius)
	
	explosion_sfx.stream 	= load( B2_Sound.get_sound( explosion_sfx_name ) )
	
	if delay > 0.0: ## add a delay before playing the animation and sfx.
		hide()
		await get_tree().create_timer(delay).timeout
		show()
	
	speed_scale 		= 4.0
	speed_scale 		*= randf_range( 0.75, 1.25)
	self_modulate.a 	= randf_range( 0.05,0.55 )
	
	play()
	explosion_sfx.play()
	
func _on_animation_finished() -> void:
	self_modulate.a = 0.0
	peace_out()

func _on_explosion_sfx_finished() -> void:
	peace_out()

func peace_out() -> void: ## only delete itself when animation and sound is done playing.
	if not is_playing() and not explosion_sfx.playing:
		#print("explosion remove") ## DEBUG
		queue_free()
