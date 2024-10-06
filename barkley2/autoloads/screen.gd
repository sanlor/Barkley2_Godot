extends CanvasLayer

# This autoload replaces o_curs, o_screen and o_pointer objects
# i think...

# THis autoload handles the mouse cursor, along with its trail.

enum TYPE{POINT, HAND, BULLS, GRAB, CURSOR}
var curr_TYPE := TYPE.POINT

var title_screen_file := "res://barkley2/rooms/r_title.tscn"

@onready var mouse = $mouse
@onready var trail = $trail

@onready var pause_screen: ColorRect = $pause_screen

@onready var button_bg_resume: 	TextureRect = $pause_screen/resume/button_bg_resume
@onready var button_bg_exit: 	TextureRect = $pause_screen/exit/button_bg_exit

@onready var resume: Button 	= $pause_screen/resume
@onready var exit: Button 		= $pause_screen/exit

var can_pause := false # Cant pause during the title screens and certain parts.
var is_paused := false
var time := 0.0

var max_trail := 2 # 3 is pretty cool
var mouse_offset := Vector2.ZERO

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	set_cursor_type( TYPE.POINT )
	
	resume.mouse_entered.connect( 	button_bg_resume.show )
	resume.mouse_exited.connect( 	button_bg_resume.hide )
	exit.mouse_entered.connect( 	button_bg_exit.show )
	exit.mouse_exited.connect( 		button_bg_exit.hide )
	
	exit.pressed.connect( 		get_tree().change_scene_to_file.bind( title_screen_file ) )
	resume.pressed.connect( 	_hide_pause_menu )

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
	## Mouse stuff
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

	## Pause screen stuff
	if is_paused:
		time += 3.5 * _delta
		
		var alpha := ( sin(time) + PI ) / TAU
		button_bg_resume.self_modulate.a 	= alpha
		button_bg_exit.self_modulate.a 		= alpha
	
	if can_pause:
		if Input.is_action_just_pressed("Pause"):
			if is_paused:
				_hide_pause_menu()
			else:
				_show_pause_menu()

func _notification(what: int):
	if what == NOTIFICATION_APPLICATION_FOCUS_OUT:
		if can_pause and not is_paused:
			_show_pause_menu()

# Show pausemenu object
func _show_pause_menu():
	pause_screen.show()
	is_paused = true
	get_tree().paused = true
	
	
func _hide_pause_menu():
	pause_screen.hide()
	is_paused = false
	get_tree().paused = false
	B2_Sound.play_pick("pausemenu_click")
