@icon("res://barkley2/assets/b2_original/images/merged/icon_parent_4.png")
extends B2_Actor
class_name B2_InteractiveActor

## Class for all actors that can be interacted with.
# sets the mouse hove area, shaders, interactions and such

@export_category("Interactive")
var _selectedOutline = false;
var _disableOutline = false;
var _active = true;

# True if you can interact with this event.
@export var is_interactive 								:= true;
@export var interactive_timer 							:= 0.0;
@export_file("*.material") var interactive_shader		:= "uid://cf0ojjtgkt2y8" # <- selected_outline.material

@export_category("Mouse")
@export var mouse_detection_area 		: Area2D
@export var interactive_distance 		:= 64 # B2_Config.settingInteractiveDistance # GZ: The max distance you can be to click this

# The last direction this actor was in.
var _last_direction = null # RIGHT;
var _last_frame = 0; # For draw event

# Used for camera following.
var camera_target_x = null # x;
var camera_target_y = null # y;
var camera_speed = 32;

## Mouse setup
var is_mouse_hovering := false
var is_player_near 		:= false

@export_category("Interaction Event")
@export var player_can_pause			:= true
@export var cutscene_script 			: B2_Script ## Used for cutscenes and dialog.
@export var cutscene_script2 			: B2_Script ## Used for cutscenes and dialog. ## NOTE This is only used for 2 or 3 objects on the whole game.
@export var cutscene_script_mask		: Array[B2_Script_Mask] ## Mask allows you to replace variables in the B2_Script

## Used to overide the cutscene script (and inject variables).
func set_new_cinemascript( script_text : String ) -> void:
	var scr := B2_Script_Legacy.new()
	var my_script := script_text
	scr.original_script = my_script
	cutscene_script = scr

func _setup_interactiveactor():
	if is_interactive:
		if not is_instance_valid(mouse_detection_area):
			mouse_detection_area = get_node("ActorInteract")
		
		await get_tree().process_frame
		if is_instance_valid(mouse_detection_area):
			mouse_detection_area.mouse_entered.connect(	mouse_detection_area_entered )
			mouse_detection_area.mouse_exited.connect(	mouse_detection_area_exited )
			mouse_detection_area.area_entered.connect( gamepad_detection_area_entered )
			mouse_detection_area.area_exited.connect( gamepad_detection_area_exited )
		else:
			push_error("%s has no node named 'mouse_detection_area' used for interaction." % name)
		
		# Cant use load() in this situation. because of the cache usage, all B2_InteractiveActors were using the sabe shaders. Enabling it on one caused all to enable too.
		var shader : ShaderMaterial = ResourceLoader.load( interactive_shader, "ShaderMaterial", ResourceLoader.CACHE_MODE_IGNORE )
		material = shader
	else:
		## Remove unnecessary nodes.
		#if is_instance_valid( get_node("ActorInteract") ):
		#	get_node("ActorInteract").queue_free()
		pass
			
	adjust_sprite_offset()
	
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
			B2_CManager.play_cutscene( cutscene_script, self, cutscene_script_mask )
		else:
			push_warning( "Player is interacting with actor %s but no script is attached." % name )
	
func gamepad_detection_area_entered( player_interaction_node : Node2D ) -> void: ## Allow for player using a gamepad to interact with stuff.
	if player_interaction_node is B2_Player_Interaction_Node and B2_Input.is_using_gamepad():
		is_mouse_hovering = true

func gamepad_detection_area_exited( player_interaction_node : Node2D ) -> void: ## Allow for player using a gamepad to interact with stuff.
	if player_interaction_node is B2_Player_Interaction_Node and B2_Input.is_using_gamepad():
		is_mouse_hovering = false
		_process_mouse_events()
	
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
			if B2_CManager.o_hoopz.curr_STATE == B2_Player_FreeRoam.STATE.NORMAL:
				if B2_CManager.o_hoopz.position.distance_to( position ) < interactive_distance:
					is_player_near = true
					return
			
	is_player_near = false
