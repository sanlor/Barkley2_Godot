extends B2_Environ
class_name B2_EnvironInteractive

@export_category("Interactive")
@export var is_interactive 								:= true
var interactive_shader := "uid://cf0ojjtgkt2y8" # "res://barkley2/shaders/material/selected_outline.material"

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
			mouse_detection_area.area_entered.connect( gamepad_detection_area_entered )
			mouse_detection_area.area_exited.connect( gamepad_detection_area_exited )
			mouse_detection_area.monitorable = true
			mouse_detection_area.monitoring = true
			
			var shader : ShaderMaterial = ResourceLoader.load( interactive_shader, "ShaderMaterial", ResourceLoader.CACHE_MODE_IGNORE )
			material = shader
		else:
			push_warning( "Interactive element %s has no mouse detection area" % name )
			is_interactive = false
		
		if not is_instance_valid( cutscene_script ):
			push_warning("Interactive element %s has no script cutscene" % name)
			is_interactive = false
		
func cinema_set(anim_name : String, force_play := false ):
	if sprite_frames.has_animation( anim_name ):
		animation = anim_name
		if force_play: play()
	else:
		push_warning( "Node %s has no animation called %s" % [name, anim_name] )
	
# Check if the actor is inside a building. return false if the parent is not B2_ROOMS
func is_inside_room() -> bool:
	if get_parent() is B2_ROOMS:
		return get_parent().is_interior
	else:
		return false
		
# Get the room area. return "unknow" if the parent is not B2_ROOMS
func get_room_area() -> String:
	if get_parent() is B2_ROOMS:
		var room_name : String = get_parent().name
		if room_name.begins_with("r_") and room_name.count("_", 0, 6) >= 2:
			var area := room_name.get_slice( "_", 1 ) # r_tnn_residentialDistrict01 > tnn
			return area
		else:
			push_warning("Room name is not standard. fix this.")
			
	push_warning("Parent is not a B2_ROOMS (%s - %s)." % [get_parent().name, str(get_parent())])
	return "unknown"
	
# Get the room name. return "unknow" if the parent is not B2_ROOMS
func get_room_name() -> String:
	if get_parent() is B2_ROOMS:
		return get_parent().name
	else:
		push_warning("Parent is not a B2_ROOMS.")
		return "unknown"
	
func _input(event: InputEvent) -> void:
	if not B2_Input.cutscene_is_playing: # only handle inputs if there are not cutscenes or dialogs running
		if is_mouse_hovering:
			if event is InputEventMouseMotion or event is InputEventJoypadMotion:
				_process_mouse_events()
				
			if is_player_near:
				if B2_Input.is_using_gamepad():
					if event is InputEventJoypadButton:
						if Input.is_action_just_pressed("Action"):
							interaction()
				else:
					if event is InputEventMouseButton:
						if Input.is_action_just_pressed("Action"):
							interaction()
		
func interaction() -> void:
	if is_interactive:
		if is_instance_valid(cutscene_script):
			pre_cutscene()
			B2_CManager.play_cutscene( cutscene_script, self, [] )
			is_mouse_hovering = false

# Sometimes, a script need to be run before the actual cutscene.
func pre_cutscene() -> void:
	pass

func mouse_detection_area_entered() -> void:
	if not B2_Input.cutscene_is_playing:
		is_mouse_hovering = true
	else:
		is_mouse_hovering = false
		_process_mouse_events()
	
func mouse_detection_area_exited() -> void:
	is_mouse_hovering = false
	_process_mouse_events()
	
func gamepad_detection_area_entered( player_interaction_node : Node2D ) -> void: ## Allow for player using a gamepad to interact with stuff.
	if player_interaction_node is B2_Player_Interaction_Node and B2_Input.is_using_gamepad():
		is_mouse_hovering = true
		_process_mouse_events()

func gamepad_detection_area_exited( player_interaction_node : Node2D ) -> void: ## Allow for player using a gamepad to interact with stuff.
	if player_interaction_node is B2_Player_Interaction_Node and B2_Input.is_using_gamepad():
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

## Compatibility layer for Cinema Scripts.
func execute_event_user_0(): 	push_warning("%s: Event not set" % name)
func execute_event_user_1(): 	push_warning("%s: Event not set" % name)
func execute_event_user_2(): 	push_warning("%s: Event not set" % name)
func execute_event_user_3(): 	push_warning("%s: Event not set" % name)
func execute_event_user_4(): 	push_warning("%s: Event not set" % name)
func execute_event_user_5(): 	push_warning("%s: Event not set" % name)
func execute_event_user_6(): 	push_warning("%s: Event not set" % name)
func execute_event_user_7(): 	push_warning("%s: Event not set" % name)
func execute_event_user_8(): 	push_warning("%s: Event not set" % name)
func execute_event_user_9(): 	push_warning("%s: Event not set" % name)
func execute_event_user_10(): 	push_warning("%s: Event not set" % name)

func _process(_delta: float) -> void:
	if is_mouse_hovering:
		# check if the player is near
		if is_instance_valid(B2_CManager.o_hoopz):
			if B2_CManager.o_hoopz.position.distance_to( position ) < interactive_distance:
				is_player_near = true
				return
			
	is_player_near = false
