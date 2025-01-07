extends HSlider
class_name B2_Audio_Slider

const S_1X_1 = preload("res://barkley2/assets/b2_original/images/s1x1.png")
const FN2 = preload("res://barkley2/resources/fonts/fn2.tres")

var is_hovering := false

@export var value_color := Color.ORANGE
@export var pick_color := Color.ORANGE
@export var value_transparency := 0.15
@export var pick_transparency := 0.25

@export var linked_label : Label
@export var normal_label_color := Color.DARK_GRAY
@export var highlight_label_color := Color.WHITE

func _ready():
	var grab := Image.create(8, 15, true, Image.FORMAT_RGBA8)
	grab.fill( Color( pick_color, pick_transparency ) )
	
	theme.set_icon( "grabber","HSlider", 			ImageTexture.create_from_image(grab) )
	theme.set_icon( "grabber_highlight","HSlider", 	ImageTexture.create_from_image(grab) )
	
	mouse_entered.connect( 	_on_mouse_entered )
	mouse_exited.connect( 	_on_mouse_exited )
	
	if linked_label != null:
		linked_label.self_modulate = normal_label_color
	
func _on_mouse_entered():
	if linked_label != null:
		linked_label.self_modulate = highlight_label_color
	is_hovering = true
	queue_redraw()

func _on_mouse_exited():
	if linked_label != null:
		linked_label.self_modulate = normal_label_color
	is_hovering = false
	queue_redraw()

func _draw():
	if is_hovering:
		draw_texture_rect(S_1X_1, Rect2(Vector2.ZERO, size), false, Color( 1, 1, 1, value_transparency ) )
		
	draw_string( FN2, (size / 2) - Vector2(5,5), str(value), HORIZONTAL_ALIGNMENT_CENTER, -1, 16 ,value_color )
