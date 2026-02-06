extends Control

@onready var label: Label = $ColorRect/Label

func _ready() -> void:
	if B2_CManager.camera:
		global_position = B2_CManager.camera.global_position - Vector2(384,240) / 2
	modulate = Color.TRANSPARENT
	label.text = Text.pr("Mining Heraldo Power Crystal...")
	var t := create_tween()
	t.tween_property(self, "modulate", Color.WHITE, 0.25)
	t.tween_interval( 4.5 )
	t.tween_property(self, "modulate", Color.TRANSPARENT, 0.25)
	t.tween_callback( queue_free )
