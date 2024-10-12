extends CanvasLayer

# This autoload replaces o_curs, o_screen and o_pointer objects
# i think...

# THis autoload handles the mouse cursor, along with its trail.

enum TYPE{POINT, HAND, BULLS, GRAB, CURSOR}
var curr_TYPE := TYPE.POINT

const PAUSE_SCREEN = preload("res://barkley2/scenes/Objects/System/pause_screen.tscn")
const NOTIFY_ITEM = preload("res://barkley2/scenes/Objects/System/notify_item.tscn")

var title_screen_file := "res://barkley2/rooms/r_title.tscn"

@onready var mouse = $mouse
@onready var trail = $trail



var max_trail := 2 # 3 is pretty cool
var mouse_offset := Vector2.ZERO



var can_pause := false # Cant pause during the title screens and certain parts.
var is_paused := false

var pause_screen: CanvasLayer

func _ready() -> void:
	layer = B2_Config.SHADER_LAYER
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	set_cursor_type( TYPE.POINT )

func set_cursor_type( type : TYPE) -> void:
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
			

func show_notify_screen( text : String ) -> void:
	var notice = NOTIFY_ITEM.instantiate()
	get_tree().current_scene.add_child( notice, true )
	await notice.show_notify_screen( text )
	
			
func _process(_delta) -> void:
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
		
	# Pause stuff
	if can_pause:
		if Input.is_action_just_pressed("Pause"):
			if is_paused:
				hide_pause_menu()
			else:
				show_pause_menu()

func _notification(what: int) -> void:
	if what == NOTIFICATION_APPLICATION_FOCUS_OUT:
		if can_pause and not is_paused:
			show_pause_menu()

# Show pausemenu object
func show_pause_menu() -> void:
	is_paused = true
	pause_screen = PAUSE_SCREEN.instantiate()
	get_tree().current_scene.add_child( pause_screen )
	
func hide_pause_menu() -> void:
	if is_instance_valid(pause_screen): # Debug errors
		pause_screen.queue_free()
	is_paused = false
	get_tree().paused = false
	B2_Sound.play_pick("pausemenu_click")

func return_to_title():
	get_tree().change_scene_to_file( title_screen_file )
	get_tree().paused = false
