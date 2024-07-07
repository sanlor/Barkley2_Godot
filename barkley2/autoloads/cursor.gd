extends CanvasLayer

# This autoload replaces o_curs and o_pointer objects
# i think...

# THis autoload handles the mouse cursor, along with its trail.

@onready var mouse = $mouse
@onready var trail = $trail

var max_trail := 3

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	#mouse.play("default")

func _process(_delta):
	mouse.position = get_viewport().get_mouse_position().round()
	#mouse.visible = not mouse.visible
	mouse.modulate.a = randf_range(0.55,0.90)
	
	#trail.visible = mouse.visible
	trail.modulate.a = mouse.modulate.a
	trail.add_point( mouse.position )
	if trail.get_point_count() > max_trail:
		trail.remove_point( 0 )
	
