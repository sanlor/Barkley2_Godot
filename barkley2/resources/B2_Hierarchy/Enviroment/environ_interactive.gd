extends B2_Environ
class_name B2_EnvironInteractive

@export_category("Interactive")
@export var is_interactive 								:= true;
@export_file("*.material") var interactive_shader		:= "res://barkley2/resources/shaders/selected_outline.material"

@export_category("Mouse")
@export var mouse_detection_area 		: Area2D
@export var interactive_distance 		:= 64 # B2_Config.settingInteractiveDistance # GZ: The max distance you can be to click this

@export_category("Interaction Event")
@export var cutscene_script 			: B2_Script ## Used for cutscenes and dialog.
@export var cutscene_script2 			: B2_Script ## Used for cutscenes and dialog. ## NOTE This is only used for 2 or 3 objects on the whole game.
@export var cutscene_script_mask		: Array[B2_Script_Mask] ## Mask allows you to replace variables in the B2_Script

## Mouse setup
var is_mouse_hovering 	:= false
var is_player_near 		:= false

func _enter_tree() -> void:
	if is_interactive:
		await get_tree().process_frame
		if is_instance_valid( mouse_detection_area ):
			await get_tree().process_frame
			mouse_detection_area.mouse_entered.connect(	mouse_detection_area_entered )
			mouse_detection_area.mouse_exited.connect(	mouse_detection_area_exited )
			
			var shader : ShaderMaterial = ResourceLoader.load( interactive_shader, "ShaderMaterial", ResourceLoader.CACHE_MODE_IGNORE )
			material = shader
		else:
			push_warning( "Interactive element %s has no mouse detection area" % name )
			is_interactive = false
		
		if not is_instance_valid( cutscene_script ):
			push_warning("Interactive element %s has no script cutscene" % name)
			is_interactive = false
		
func cinema_set(anim_name : String):
	if sprite_frames.has_animation( anim_name ):
		animation = anim_name
	else:
		push_warning( "Node %s has no animation called %s" % [name, anim_name] )
	
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
			B2_CManager.play_cutscene( cutscene_script, self, [] )
			is_mouse_hovering = false
	
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

func _process(_delta: float) -> void:
	if is_mouse_hovering:
		# check if the player is near
		if is_instance_valid(B2_CManager.o_hoopz):
			if B2_CManager.o_hoopz.position.distance_to( position ) < interactive_distance:
				is_player_near = true
				return
			
	is_player_near = false
