extends CanvasLayer
#class_name B2_Debug

# vvv dont remember what this does.
const ENABLE_CINEMASPOT := false

# show debug pathfind path
const PATHFIND_SHOW := false

# show the way the actor is facing
const ENABLE_MOVEMENT_VECTOR_VISUALIZE := false

## Save system
const WARN_INVALID_CHECKS := false # Create a warning if the B2_Config.get_user_save_data() returns null

@onready var player_data: ScrollContainer = $player_data
@onready var player_vars: ScrollContainer = $player_vars

func _ready() -> void:
	layer = B2_Config.DEBUG_LAYER

func _unhandled_key_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.is_action_pressed("DEBUG_DATA"):
			player_data.visible = not player_data.visible
		if event.is_action_pressed("DEBUG_FF"): ## TODO add some UI fluff
			print_rich("[color=pink]DEBUG can FF.[/color]")
		elif event.is_action_released("DEBUG_FF"):
			pass
		if event.is_action_pressed("DEBUG_VARS"):
			player_vars.visible = not player_vars.visible
