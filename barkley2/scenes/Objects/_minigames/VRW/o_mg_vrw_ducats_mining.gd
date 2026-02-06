extends Control

@onready var label: Label = $ColorRect/Label

func _ready() -> void:
	if get_parent() is B2_ROOMS:
		get_parent().remove_child(self)
		B2_Screen.add_child(self, true)
	modulate = Color.TRANSPARENT
	label.text = Text.pr("Mining Heraldo Power Crystal...")
	var t := create_tween()
	t.tween_property(self, "modulate", Color.WHITE, 0.25)
	t.tween_interval( 4.5 )
	t.tween_property(self, "modulate", Color.TRANSPARENT, 0.25)
	t.tween_callback( queue_free )
	
var tt := 0.0
func _physics_process(_delta: float) -> void:
	if label:
		tt += 0.1
		label.modulate.a = (1.0 + sin(tt)) / 2.0
