extends Button

@export var rename_bts : Control

func _ready() -> void:
	if rename_bts:
		pressed.connect( rename_bts.write_letter.bind( text.to_upper() ) )
