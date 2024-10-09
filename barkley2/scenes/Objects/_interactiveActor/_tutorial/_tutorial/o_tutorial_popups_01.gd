extends CanvasLayer
# Check the o_tutorial_popups01 object

@onready var tutorial_text: Label = $ColorRect/tutorial_text
@onready var color_rect: ColorRect = $ColorRect

## Skips the original checks
@export var force_index := false
@export var _index		:= 0

var tween : Tween

# SETUP #
var alpha = 0.0;
var alpha_goal = 0.0;
var timer_fade = 5.0; 

var index := 0
var tutorial := PackedStringArray()

func _ready() -> void:
	tutorial.resize(3)
	tutorial[0] = "Use the WASD KEYS to move around.";
	tutorial[1] = "Use the ACTION KEY to interact with NPC's";
	tutorial[2] = "Use the SPACEBAR KEY to execute a roll.";
	
	## WARNING Need a way to organize layer order
	layer = 2000
	
	## Abort the tutorial image if an event starts.
	B2_Cinema.event_started.connect( tutorial_abort )
	
	# Don't repeat #
	if B2_Playerdata.Quest("tutorialPopup", null, 0) >= 1 and get_parent().name == "r_fct_eggRooms01": queue_free()
	if B2_Playerdata.Quest("tutorialPopup", null, 0) >= 2 and get_parent().name == "r_fct_accessHall01": queue_free()
	if B2_Playerdata.Quest("tutorialPopup", null, 0) >= 3 and get_parent().name == "r_fct_tutorialZone01": queue_free()

	# Which one ? #
	index = B2_Playerdata.Quest("tutorialPopup", null, 0);
	if B2_Playerdata.Quest("tutorialPopup", null, 0) == 0 and get_parent().name == "r_fct_eggRooms01": 		B2_Playerdata.Quest("tutorialPopup", 1);
	if B2_Playerdata.Quest("tutorialPopup", null, 0) == 1 and get_parent().name == "r_fct_accessHall01": 	B2_Playerdata.Quest("tutorialPopup", 2);
	if B2_Playerdata.Quest("tutorialPopup", null, 0) == 2 and get_parent().name == "r_fct_tutorialZone01": 	B2_Playerdata.Quest("tutorialPopup", 3);
	if B2_Playerdata.Quest("tutorialPopup", null, 0) == 3 and get_parent().name == "r_fct_eggRooms01": 		B2_Playerdata.Quest("tutorialPopup", 4);
	
	if force_index:
		index = _index
		
	tutorial_display()
	
func tutorial_display():
	var msg : String = tutorial[ index ]
	tutorial_text.text = msg
	color_rect.modulate.a = 0
	tween = create_tween()
	tween.tween_property( color_rect, "modulate:a", 1.0, 1.5 )
	tween.tween_interval( timer_fade )
	tween.tween_property( color_rect, "modulate:a", 0.0, 1.5 )
	tween.tween_callback( queue_free )
	
func tutorial_abort():
	if tween.is_running():
		tween.kill()
		tween = create_tween()
		tween.tween_property( color_rect, "modulate:a", 0.0, 1.0 )
		tween.tween_callback( queue_free )
