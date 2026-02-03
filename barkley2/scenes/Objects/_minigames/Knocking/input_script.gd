extends Control

@onready var right_arrow_text: 	TextureRect = $right_arrow_text
@onready var up_arrow_text: 	TextureRect = $up_arrow_text
@onready var left_arrow_text: 	TextureRect = $left_arrow_text
@onready var down_arrow_text: 	TextureRect = $down_arrow_text

func _ready() -> void:
	right_arrow_text.self_modulate 	= Color.TRANSPARENT
	up_arrow_text.self_modulate 	= Color.TRANSPARENT
	left_arrow_text.self_modulate 	= Color.TRANSPARENT
	down_arrow_text.self_modulate 	= Color.TRANSPARENT
	
func pulse_arrow( id : int ) -> void:
	var t := create_tween()
	var text : TextureRect
	match id:
		0:	text = right_arrow_text
		1:	text = up_arrow_text
		2:	text = left_arrow_text
		3:	text = down_arrow_text
		_:	breakpoint
	text.scale = Vector2.ZERO
	t.tween_property(text, "scale", Vector2.ONE, 0.25)
	
func set_note( id : int, correct : bool) -> void:
	match id:
		0:	right_arrow_text.self_modulate 	= Color.WHITE
		1:	up_arrow_text.self_modulate 	= Color.WHITE
		2:	left_arrow_text.self_modulate 	= Color.WHITE
		3:	down_arrow_text.self_modulate 	= Color.WHITE
		
	if correct:	B2_Sound.play("sn_knocknote0" + str(id + 1))
	else:		B2_Sound.play("sn_utilitycursor_buttondisabled01")
	
	pulse_arrow(id)
	
	var c := Color.WHITE
	modulate = c * 5
	## Flash Input
	var t := create_tween()
	t.tween_property(self, "modulate", Color.WHITE, 0.5)
	
	print( "%s - %s" % [id, correct])
