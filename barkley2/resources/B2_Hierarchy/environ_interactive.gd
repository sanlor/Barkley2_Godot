extends B2_Environ
class_name B2_EnvironInteractive

@export_category("Interactive")
@export var is_interactive 								:= true;
@export_file("*.material") var interactive_shader		:= "res://barkley2/resources/shaders/selected_outline.material"

@export_category("Mouse")
@export var mouse_detection_area 		: Area2D

@export_category("Interaction Event")
@export var cutscene_script 			: B2_Script

## Mouse setup
var is_mouse_hovering 	:= false
var is_player_near 		:= false

func _enter_tree() -> void:
	if is_interactive:
		if is_instance_valid( mouse_detection_area ):
			await get_tree().process_frame
			mouse_detection_area.mouse_entered.connect(	mouse_detection_area_entered )
			mouse_detection_area.mouse_exited.connect(	mouse_detection_area_exited )
			
			var shader : ShaderMaterial = ResourceLoader.load( interactive_shader, "ShaderMaterial", ResourceLoader.CACHE_MODE_IGNORE )
			material = shader
			
		else:
			push_warning("Interactive element has no mouse detection area")
			is_interactive = false
		
	if not is_instance_valid( cutscene_script ):
		push_warning("Interactive element %s has no script cutscene" % name)
		is_interactive = false
		
func _input(event: InputEvent) -> void:
	if not B2_Input.cutscene_is_playing: # only handle inputs if there are not cutscenes or dialogs running
		if is_mouse_hovering:
			if event is InputEventMouseMotion:
				_process_mouse_events()
				
			if is_player_near:
				if event is InputEventMouseButton:
					if Input.is_action_just_pressed("Action"):
						interaction()
		
func interaction() -> void:
	if is_interactive:
		if is_instance_valid(cutscene_script):
			B2_CManager.play_cutscene( cutscene_script, self, true )
	
func mouse_detection_area_entered() -> void:
	if not B2_Input.cutscene_is_playing:
		is_mouse_hovering = true
	else:
		is_mouse_hovering = false
		_process_mouse_events()
	
func mouse_detection_area_exited() -> void:
	is_mouse_hovering = false
	_process_mouse_events()
	
func _process_mouse_events() -> void: ## Perform mouse click and position checks
	if not is_interactive:
		return
		
	if is_player_near:
		if is_mouse_hovering:
			#print(name)
			material.set_shader_parameter("enable", true)
			return
	
	material.set_shader_parameter("enable", false)
