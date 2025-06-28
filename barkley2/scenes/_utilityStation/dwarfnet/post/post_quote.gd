extends VBoxContainer

@onready var quote_text: Label = $quote_window/quote_margin/quote_text

func set_text( text : String ) -> void:
	quote_text.text = text.replace("#", "\n")
