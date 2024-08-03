extends TextureButton

@onready var text_label = $text

var text_color_normal := Color.GRAY # c_gray; // For text that cannot be interacted with
var text_color_button := Color.LIGHT_GRAY # c_ltgray; // Text that can be clicked
var text_color_hover  := Color.WHITE # c_white;
var text_color_select := Color.ORANGE # c_orange;

func _on_gui_input(event):
	print( event.as_text() )

func _on_mouse_entered():
	text_label.modulate = text_color_select

func _on_mouse_exited():
	text_label.modulate = text_color_hover
