extends CanvasLayer

# This autoload replaces o_curs, o_screen and o_pointer objects
# i think...

# THis autoload handles the mouse cursor, along with its trail.

enum TYPE{POINT, HAND, BULLS, GRAB, CURSOR}
var curr_TYPE := TYPE.POINT

@onready var mouse = $mouse
@onready var trail = $trail

var max_trail := 2 # 3 is pretty cool
var mouse_offset := Vector2.ZERO

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	#remove_child(trail)
	set_cursor_type( TYPE.POINT )
	#mouse.play("default")

func set_cursor_type( type : TYPE):
	mouse.stop()
	match type:
		TYPE.POINT:
			mouse.animation = "point"
			mouse.frame = 0
			mouse.centered = true
			mouse_offset = Vector2.ZERO
			if not trail.is_inside_tree():
				add_child(trail)
		TYPE.HAND:
			mouse.animation = "hand"
			mouse.frame = 0
			mouse.centered = false
			mouse_offset = Vector2(-5,-4)
			if trail.is_inside_tree():
				remove_child(trail)
		TYPE.CURSOR:
			mouse.animation = "cursor"
			mouse.frame = 0
			mouse.centered = false
			mouse_offset = Vector2.ZERO
			if trail.is_inside_tree():
				remove_child(trail)
		TYPE.BULLS:
			mouse.animation = "bulls"
			mouse.play("bulls")
			mouse.frame = 0
			mouse.centered = true
			mouse_offset = Vector2.ZERO
			if trail.is_inside_tree():
				remove_child(trail)
		TYPE.GRAB:
			mouse.animation = "grab"
			mouse.frame = 0
			mouse.centered = false
			mouse_offset = Vector2(-5,-4)
			if trail.is_inside_tree():
				remove_child(trail)
			
	curr_TYPE = type
	mouse.modulate.a = 1.0
			

func _process(_delta):
	mouse.position = get_viewport().get_mouse_position().round() + mouse_offset
	
	if curr_TYPE == TYPE.POINT:
		mouse.modulate.a = randf_range(0.55,0.90)
		
	if curr_TYPE == TYPE.GRAB:
		if Input.is_action_pressed("Action"):
			mouse.frame = 1
		else:
			mouse.frame = 0
	
	if trail.is_inside_tree():
		trail.modulate.a = mouse.modulate.a
		trail.add_point( mouse.position )
		if trail.get_point_count() > max_trail:
			trail.remove_point( 0 )
