extends CanvasLayer
#class_name B2_Debug

const O_CAMERA_DEBUG = preload("uid://dvdkuaawlgfqd")

# vvv dont remember what this does.
const ENABLE_CINEMASPOT := false

# show debug pathfind path
const PATHFIND_SHOW := false

# show the way the actor is facing
const ENABLE_MOVEMENT_VECTOR_VISUALIZE := false

## Save system
const WARN_INVALID_CHECKS := false # Create a warning if the B2_Config.get_user_save_data() returns null

## Camera debug
var show_camera_debug_data := false
var debug_camera_node : B2_Camera_Debug

## player debug
var can_disable_player_col := false

@onready var player_data: ScrollContainer = $player_data
@onready var player_vars: ScrollContainer = $player_vars
@onready var accept_dialog: AcceptDialog = $AcceptDialog
@onready var teleport_window: ConfirmationDialog = $teleport_window

func _ready() -> void:
	layer = B2_Config.DEBUG_LAYER
	
	player_vars.visible = false
	player_data.visible = false

func _unhandled_key_input(event: InputEvent) -> void:
	if event is InputEventKey:
		## Create a free flying camera to check thinks out.
		if Input.is_action_just_pressed("DEBUG_CAMERA"):
			if is_instance_valid(debug_camera_node):
				debug_camera_node.queue_free()
				if B2_CManager.camera:
					B2_CManager.camera.enabled = true
				B2_Input.player_has_control = true
			else:
				debug_camera_node = O_CAMERA_DEBUG.instantiate()
				get_tree().current_scene.add_child( debug_camera_node )
				debug_camera_node.enabled = true
				if B2_CManager.camera:
					B2_CManager.camera.enabled = false
				B2_Input.player_has_control = false
				
		if event.is_action_pressed("DEBUG_DATA"):
			player_data.visible = not player_data.visible
		elif event.is_action_pressed("DEBUG_FF"): ## TODO add some UI fluff
			print_rich("[color=pink]DEBUG can FF.[/color]")
		elif event.is_action_released("DEBUG_FF"):
			pass
		elif event.is_action_pressed("DEBUG_VARS"):
			player_vars.visible = not player_vars.visible
			
		elif event.is_action_pressed("DEBUG_QUESTS"):
			accept_dialog.visible = not accept_dialog.visible
			
		#get_tree().paused = player_data.visible or player_vars.visible or accept_dialog.visible


func _on_button_pressed() -> void:
	teleport_window.show()
