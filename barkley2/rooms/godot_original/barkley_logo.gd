@tool
extends TextureRect

## This could have been a shader.

var original_pos := Vector2(41.5, 49)
var time := 0.0

const S_BARKLEY_2_LOGO = preload("res://barkley2/assets/b2_original/images/merged/s_barkley2_logo.png")
const S_BARKLEY_2_LOGO_JP = preload("res://barkley2/assets/b2_original/images/merged/s_barkley2_logo_jp.png")

var logo_eng := true

func _physics_process(delta: float) -> void:
	time += 2.0 * delta
	modulate.a = ( sin( time ) + 1.0 ) / 2.0
	modulate.a += 0.1
	modulate.a += randf_range(-0.08, 0.08)
	modulate.a *= 0.15
	
	if randf() > 0.99 and logo_eng:
		logo_eng = false
		texture = S_BARKLEY_2_LOGO_JP
		
	if randf() > 0.95 and not logo_eng:
		logo_eng = true
		texture = S_BARKLEY_2_LOGO
