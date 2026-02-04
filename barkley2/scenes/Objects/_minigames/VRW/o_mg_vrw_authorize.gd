extends Control

signal finished

@onready var texture_rect: TextureRect = $TextureRect

var can_close := false

func _ready() -> void:
	global_position = B2_CManager.camera.global_position - Vector2(0,80)
	
	texture_rect.position.y = 240
	var t := create_tween()
	t.tween_property(texture_rect, "position:y", 0.0, 1.0).set_trans(Tween.TRANS_CUBIC)
	t.tween_interval(1.0) # Read the damn contract!
	t.tween_callback( set.bind("can_close", true) )
	
func _close() -> void:
	texture_rect.position.y = 0.0
	var t := create_tween()
	t.tween_property(texture_rect, "position:y", 240.0, 1.0).set_trans(Tween.TRANS_CUBIC)
	t.tween_callback( finished.emit )
	t.tween_callback( queue_free )
	
func _process(_delta: float) -> void:
	if can_close:
		if Input.is_action_just_pressed("Action"):
			B2_Sound.play("sn_cc_button_accept")
			_close()
			can_close = false
			set_process(false)
			
