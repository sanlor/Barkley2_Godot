extends CanvasLayer
#class_name B2_Debug

const O_CAMERA_DEBUG = preload("uid://dvdkuaawlgfqd")

const ENABLE_FREE_FFWD := false

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

@onready var debug_tools: 		B2_Border 			= $debug_tools

@onready var player_data: 					ScrollContainer 	= $player_data
@onready var player_vars: 					ScrollContainer 	= $player_vars
@onready var quest_checker: 				AcceptDialog 		= $quest_checker
@onready var teleport_window: 				ConfirmationDialog 	= $teleport_window
@onready var gun_stats: 					MarginContainer		= $gun_stats
@onready var input_checker: 				CenterContainer 	= $input_checker
@onready var timed_quest_editor_window: 	AcceptDialog 		= $timed_quest_editor_window


func _ready() -> void:
	layer = B2_Config.DEBUG_LAYER
	
	player_vars.visible = false
	player_data.visible = false
	
	if ENABLE_FREE_FFWD: 					print_rich("[color=red]B2_Debug: ENABLE_FREE_FFWD[/color]")
	if ENABLE_CINEMASPOT: 					print_rich("[color=red]B2_Debug: ENABLE_CINEMASPOT[/color]")
	if PATHFIND_SHOW: 						print_rich("[color=red]B2_Debug: PATHFIND_SHOW[/color]")
	if ENABLE_MOVEMENT_VECTOR_VISUALIZE: 	print_rich("[color=red]B2_Debug: ENABLE_MOVEMENT_VECTOR_VISUALIZE[/color]")
	if WARN_INVALID_CHECKS : 				print_rich("[color=red]B2_Debug: WARN_INVALID_CHECKS [/color]")

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
				
		elif event.is_action_pressed("DEBUG_VARS"):
			show()
			debug_tools.visible = not debug_tools.visible
			
			if not debug_tools.visible:
				Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
				
			if B2_CManager.o_hoopz:
				B2_CManager.o_hoopz.debug_enable_collision( debug_tools.visible )

func _on_quest_checker_btn_pressed() -> void:
	quest_checker.visible = not quest_checker.visible

func _on_player_var_btn_pressed() -> void:
	player_data.visible = not player_data.visible

func _on_var_tools_btn_pressed() -> void:
	player_vars.visible = not player_vars.visible

func _on_teleport_btn_pressed() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE) 
	player_vars.visible = false
	teleport_window.show()

func _on_input_checker_btn_pressed() -> void:
	input_checker.visible = not input_checker.visible

func _on_exit_btn_pressed() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	hide()
	debug_tools.hide()
	if B2_CManager.o_hoopz:
		B2_CManager.o_hoopz.debug_enable_collision( false )

func _on_gun_stats_btn_pressed() -> void:
	gun_stats.visible = not gun_stats.visible

func _on_timed_quests_btn_pressed() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE) 
	timed_quest_editor_window.visible = not timed_quest_editor_window.visible
