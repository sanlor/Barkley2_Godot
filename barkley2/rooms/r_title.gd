extends Control

## NOTE This room loads the oTitle object.
# This also forces the resolution to 384 x 240.
# This scene tries to recreate the room r_title, with the object oTitle.

## Godot Specific:
# Load necessary Images
#region Images

@onready var bg = $bg
const O_TITLE_STARPASS = preload("res://barkley2/scenes/sTitle/oTitleStarpass.tscn")

# Menu Panels
var title_box
var game_slot_1
var game_slot_2
var game_slot_3
var game_slot_4
var back_box
var obliterate_box
var settings_box
var settings_return_box
var settings_general_box
var settings_control_box
var settings_gamepad_box # formely "dicks"
var settings_get_key_box # for the key remap

#endregion

func _ready():
	for n in bg.get_children():
		if n is AnimatedSprite2D:
			n.play("default")
	
	## Debug
	var w_scale := 2
	get_window().position /= w_scale
	get_window().size *= w_scale
	
	for i in 40:
		var star = O_TITLE_STARPASS.instantiate()
		star.position = Vector2( randf_range(0, get_viewport_rect().end.x), randf_range(0, get_viewport_rect().end.y) )
		star.name = "star" + str(i)
		add_child(star)

	## Create Panels / Borders
	# Border("generate", 0, 100 + 16, 60 + 16 - 1); // Title Box
	title_box = Border.generate(100 + 16, 60 + 16 - 1)

	# for (i = 1; i &lt; 4; i += 1) Border("generate", i, 344, 66); // Game Slot
	game_slot_1 = Border.generate( 344, 66 )
	game_slot_2 = Border.generate( 344, 66 )
	game_slot_3 = Border.generate( 344, 66 )
	game_slot_4 = Border.generate( 344, 66 )
	
	# Border("generate", 4, 100, 32); // Back
	back_box = Border.generate(100, 32)

	# Border("generate", 5, 100, 32); // Obliterate
	obliterate_box = Border.generate(100, 32)

	# Border("generate", 6, 320 + 8, 176 - 22); // Settings
	settings_box = Border.generate(320 + 8, 176 - 22)

	# Border("generate", 7, 320 + 8, 32); // Settings - Return
	settings_return_box = Border.generate(320 + 8, 32)

	# for (i = 8; i &lt; 11; i += 1) Border("generate", i, 106, 32); // 8, 9, 10 = General, Controls, Dicks
	settings_general_box = Border.generate(106, 32)
	settings_control_box = Border.generate(106, 32)
	settings_gamepad_box = Border.generate(106, 32)

	# Border("generate", 11, 256, 64); // Get key
	settings_get_key_box = Border.generate(256, 64)

func _input(event):
	if event is InputEventMouseMotion:
		pass

func _process(delta):
	#for n in bg.get_children():
		#if n.has_method("move_left"):
			#n.move_left( 80 * delta )
	pass
