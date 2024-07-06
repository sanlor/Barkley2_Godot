@tool
extends Control
class_name B2_Confirm

const S_1X_1 = preload("res://barkley2/assets/b2_original/images/s1x1.png")
const BG1 = preload("res://barkley2/assets/Confirm/sButtonPapers_0.png")
const BG2 = preload("res://barkley2/assets/Confirm/sButtonPapers_6.png")
const BG3 = preload("res://barkley2/assets/Confirm/sButtonPapers_1.png")
const GIVE = preload("res://barkley2/assets/Confirm/sButtonPapers_2.png")
const EXIT = preload("res://barkley2/assets/Confirm/sButtonPapers_3.png")
const YES = preload("res://barkley2/assets/Confirm/sButtonPapers_4.png")
const NO = preload("res://barkley2/assets/Confirm/sButtonPapers_5.png")

@onready var full_screen_bg = $full_screen_bg
@onready var dialog = $dialog



## Godot stuff
var dialog_max_size := 65.0

## Create
var soundHoverLight = "sn_debug_one"; ## Hover over buttons
var soundClickExit = "sn_debug_three"; ## Click exit
var givTxt = "Buy Monofilament Jerkin for {5000?";
var givTit = "NULL";
var givPct := 0.0;
var givSpd := 0.5
var spd := givSpd;
var givSel := 0.0;
var givExe := -1.0;
var givExt := 0.0;

var givWid = 384 + 1; ##to be safe add 1
# var givHov[0] = 0;
# var givHov[1] = 0;
# var givX[0] = floor(givWid / 2) + 10 - 3;
# var givX[1] = floor(givWid / 2) - 10 - 81 + 2;

## Text, Option 0, Option 1,
var alpBgn = 0.75; 						## Alpha of grid background
var butSpd = 0.15; 						## Speed at which buttons hilight in seconds

var butHilCol = Color(48, 52, 45);		## Hilight color
var butTxtCol = Color(255, 202, 19);	## Hilight color

var curOvr = -1;
var curHov = 0;

func _ready():
	# draw_sprite_ext(s1x1, 0, view_xview[0], view_yview[0], SCREEN_WIDTH, SCREEN_HEIGHT, 0, c_black, 0.75 * pctBgn);
	full_screen_bg.color = Color(0,0,0,0.75)
	
	var tween := create_tween()
	tween.set_parallel( true )
	tween.tween_property(full_screen_bg, "modulate", Color(0,0,0,0.75), givSpd)
	tween.tween_property(dialog, "size:y", dialog_max_size, givSpd)
	tween.tween_property(dialog, "position:y", (get_viewport_rect().end.y / 2) - (dialog_max_size / 2), givSpd)
	
	
func _expand(): # When its diplayed, the menu opens up.
	pass
	
func collapse():
	pass
