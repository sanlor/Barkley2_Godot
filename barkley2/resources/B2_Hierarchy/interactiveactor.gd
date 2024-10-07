extends B2_Actor
class_name B2_InteractiveActor

@export_category("Interactive")
var _selectedOutline = false;
var _disableOutline = false;
var _active = true;

# True if you can interact with this event.
@export var is_interactive 								:= true;
@export var interactive_timer 							:= 0.0;
@export_file("*.material") var interactive_shader		:= "res://barkley2/resources/shaders/selected_outline.material"

@export_category("Mouse")
@export var mouse_detection_area 	: Area2D
@export var interactive_distance 	:= B2_Config.settingInteractiveDistance # GZ: The max distance you can be to click this

# The last direction this actor was in.
var _last_direction = null # RIGHT;
var _last_frame = 0; # For draw event

# Used for camera following.
var camera_target_x = null # x;
var camera_target_y = null # y;
var camera_speed = 32;

## Mouse setup
var is_mouse_hovering := false

func _enter_tree() -> void:
	mouse_detection_area.mouse_entered.connect(	mouse_detection_area_entered)
	mouse_detection_area.mouse_exited.connect(	mouse_detection_area_exited)
	
	if is_interactive:
		var shader : ShaderMaterial = load( interactive_shader )
		material = shader
	
func mouse_detection_area_entered():
	is_mouse_hovering = true
	_process_mouse_events()
	
func mouse_detection_area_exited():
	is_mouse_hovering = false
	_process_mouse_events()
	
func _process_mouse_events(): ## Perform mouse click and position checks
	if is_mouse_hovering:
		material.set_shader_parameter("enable", true)
	else:
		material.set_shader_parameter("enable", false)
