extends Control
class_name B2_UtilityPanel

var fade_tween : Tween

func show_panel() -> void:
	if fade_tween:			fade_tween.kill()
	show()
	modulate = Color.TRANSPARENT
	fade_tween = create_tween()
	# fade_tween.tween_property( self, "modulate", Color.BLACK, 		0.2 )
	fade_tween.tween_property( self, "modulate", Color.WHITE, 			0.2 ).set_ease(Tween.EASE_IN_OUT)
	await fade_tween.finished

func hide_panel() -> void:
	if fade_tween:			fade_tween.kill()
	modulate = Color.WHITE
	fade_tween = create_tween()
	# fade_tween.tween_property( self, "modulate", Color.BLACK, 		0.2 )
	fade_tween.tween_property( self, "modulate", Color.TRANSPARENT, 	0.2 ).set_ease(Tween.EASE_OUT_IN)
	fade_tween.tween_callback( hide )
	await fade_tween.finished
