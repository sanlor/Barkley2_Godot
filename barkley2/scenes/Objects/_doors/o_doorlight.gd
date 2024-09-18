@tool
extends AnimatedSprite2D
# Base class for doorlight directions.
@export var show_door_light := false

# the original code does a lot of fancy stuff. I think im going to rewrite almost everything.

enum DOOR_TYPE{UP, DOWN, LEFT, RIGHT}
@export var type := DOOR_TYPE.UP
@export var door_size := 32
@export var door_offset := Vector2.ZERO

var wadChk = 2; # To make resist half in wading layer
var zone = "";

var pushTime 		= 0.5; # In seconds how long you need to hold
var pushResist 		= 70; # Pushing resist, higher is more pusback
var light 			= 1; # When 0, it does not show the light
var fix 			= 1; # If 1, adds the top fix
var locked 			= 0;
var door_name 		= "";

var area_change 		= false;
var area 				= "TNN Sewers";
var area_change_audio 	= true;
var enable 				= 1;
var enableDraw 			= 0;

var _fade_timer 			= 0.25;

func _ready() -> void:
	if Engine.is_editor_hint() and not show_door_light:
		animation = "debug_icons"
		frame = type
		return
	
	match type:
		DOOR_TYPE.UP:
			animation = "s_doorlight_ud"
			flip_v = true
			frame = 0
		DOOR_TYPE.DOWN:
			animation = "s_doorlight_ud"
			flip_v = false
			frame = 0
		DOOR_TYPE.LEFT:
			animation = "s_doorlight_lr"
			flip_v = true
			frame = 0
		DOOR_TYPE.RIGHT:
			animation = "s_doorlight_lr"
			flip_v = false
			frame = 0
