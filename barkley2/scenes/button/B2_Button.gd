extends Button
class_name B2_Button

@export var linked_label : Label
@export var normal_label_color := Color.DARK_GRAY
@export var highlight_label_color := Color.WHITE

## Custom class for buttons used in B2. Basically allows to move texture inside the button

func _ready():
	mouse_entered.connect( 	_on_mouse_entered )
	mouse_exited.connect( 	_on_mouse_exited )
	_on_mouse_exited()

func _on_mouse_entered():
	if linked_label != null:
		linked_label.self_modulate = highlight_label_color

func _on_mouse_exited():
	if linked_label != null:
		linked_label.self_modulate = normal_label_color

func add_textures(tex : Texture2D, custom_pos := false, pos := Vector2.ZERO ):
	var texture := TextureRect.new()
	texture.texture = tex
	add_child(texture)
	
	if custom_pos:
		texture.position = pos

func add_decorations(node : Node, custom_pos := false, pos := Vector2.ZERO ):
	add_child(node)
	
	if custom_pos:
		node.position = pos
