@tool
extends B2_Border

@onready var rich_text_label: RichTextLabel = $MarginContainer/VBoxContainer/ColorRect/MarginContainer/RichTextLabel

func _ready():
	set_panel_size( 300, 220 ) # why this keeps reseting to 50x50 using the @export? had to set it manually
	rich_text_label.grab_focus()

func _on_close_pressed():
	get_parent().queue_free()

func _on_rich_text_label_meta_clicked(meta: Variant) -> void:
	OS.shell_open( str(meta) )
