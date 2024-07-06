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

@onready var full_screen_bg 	: ColorRect= $full_screen_bg
@onready var dialog 			: TextureRect = $dialog

@onready var confirm_text 		: Label = $confirm_text

@onready var option_1 : B2_Button = $option_1
@onready var option_2 : B2_Button = $option_2


## Godot stuff
var dialog_max_size := 65.0

signal option1_pressed
signal option2_pressed

## Create
var soundHoverLight = "sn_debug_one"; ## Hover over buttons
var soundClickExit = "sn_debug_three"; ## Click exit
var givTxt = "Buy Monofilament Jerkin for {5000?";
var givTit = "NULL";
var givPct := 0.0;
var givSpd := 0.25 ## NOTE was 0.5
var spd := givSpd;
var givSel := 0.0;
var givExe := -1.0;
var givExt := 0.0;

var givWid = 384 + 1; ##to be safe add 1
var givHov_0 = 0;
var givHov_1 = 0;
@warning_ignore("integer_division")
var givX_0 = floor(givWid / 2) + 10 - 3;
@warning_ignore("integer_division")
var givX_1 = floor(givWid / 2) - 10 - 81 + 2;

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
	dialog.position.y = get_viewport_rect().end.y / 2
	
	full_screen_bg.modulate 	= Color.TRANSPARENT
	dialog.modulate 			= Color.TRANSPARENT
	
	option_1.add_textures(YES)
	option_2.add_textures(NO)
	
	option_1.pressed.connect( func(): option1_pressed.emit(); B2_Sound.play(soundClickExit); collapse() )
	option_2.pressed.connect( func(): option2_pressed.emit(); B2_Sound.play(soundClickExit); collapse() )
	
	option_1.mouse_entered.connect( func(): B2_Sound.play(soundHoverLight) )
	option_2.mouse_entered.connect( func(): B2_Sound.play(soundHoverLight) )
	
	option_1.size = Vector2(81, 17)
	option_2.size = Vector2(81, 17)
	
	## Holy shit.
	var y := get_viewport_rect().size.y / 2
	var givHei = (2 * 12) + 44;
	givHei -= 3
	givHei = round(givHei)
	y -= givHei / 2
	y = floor(y)
	var fuck_this_y := 93.0
	
	confirm_text.size.x = 340.0
	confirm_text.text = givTxt
	confirm_text.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	confirm_text.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	confirm_text.position = (get_viewport_rect().size / 2) - (confirm_text.size / 2)
	#confirm_text.position.y = y + round(givHei * 0.34)
	confirm_text.position.y = fuck_this_y
	
	var fuck_this_y_also := 128.0
	option_1.global_position = Vector2(givX_1, fuck_this_y_also)
	option_2.global_position = Vector2(givX_0, fuck_this_y_also)
	
	_expand()
	
	
func _expand(): # When its diplayed, the menu opens up.
	var tween := create_tween()
	
	tween.tween_property(full_screen_bg, 	"modulate", Color.WHITE, givSpd)
	tween.parallel().tween_property(dialog, 			"modulate", Color.WHITE, givSpd)
	
	tween.parallel().tween_property(dialog, "size:y", dialog_max_size, givSpd)
	tween.parallel().tween_property(dialog, "position:y", (get_viewport_rect().end.y / 2) - (dialog_max_size / 2), givSpd)
	
	tween.tween_property(confirm_text, 	"modulate", Color.WHITE, givSpd)
	tween.parallel().tween_property(option_1,		"modulate", Color.WHITE, givSpd)
	tween.parallel().tween_property(option_2,		"modulate", Color.WHITE, givSpd)
	
func collapse():
	var tween := create_tween()
	
	tween.tween_property(confirm_text, 	"modulate", Color.TRANSPARENT, givSpd)
	tween.parallel().tween_property(option_1,		"modulate", Color.TRANSPARENT, givSpd)
	tween.parallel().tween_property(option_2,		"modulate", Color.TRANSPARENT, givSpd)
	
	tween.tween_property(full_screen_bg, 	"modulate", Color.TRANSPARENT, givSpd)
	tween.parallel().tween_property(dialog, 			"modulate", Color.TRANSPARENT, givSpd)
	
	tween.parallel().tween_property(dialog, "size:y", 0.0, 									givSpd)
	tween.parallel().tween_property(dialog, "position:y", (get_viewport_rect().end.y / 2), 	givSpd)
	
	tween.tween_callback( queue_free )
