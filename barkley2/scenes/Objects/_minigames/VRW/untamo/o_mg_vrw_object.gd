extends RigidBody2D
## Weird script that controls how untamos as spawned.
# NOTE no idea what a untamo is. maybe the player characters in O.O.? why this name?
## Since the map "r_bct_vrw_town02" infinitelly scrolls on the X axis, each untamos has 3 simultaneous sprites to fool the player.
# Check 'o_mg_vrw_untamo' and 'o_mg_vrw_object' and 'o_mg_vrw_untamo_spawner', bitch.

# Check 'o_mg_vrw_object' draw event.
@onready var o_mg_vrw_untamo_left: 		B2_Minigame_VRW_Untamo = $o_mg_vrw_untamo_left
@onready var o_mg_vrw_untamo_middle: 	B2_Minigame_VRW_Untamo = $o_mg_vrw_untamo_middle
@onready var o_mg_vrw_untamo_right: 	B2_Minigame_VRW_Untamo = $o_mg_vrw_untamo_right

@export var messages : B2_Minigame_VRW_Messages

var usrNam := "PLACEHOLDER"
var usrCol := Color.HOT_PINK

var my_identity := 0

func _ready() -> void:
	var index_head := randi_range(0,7);
	var index_eyes := randi_range(0,14);
	var index_hair := randi_range(0,14);
	var index_mouth := randi_range(0,14);
	var index_nose := randi_range(0,14);
	var bodCol := Color.from_hsv(randf(), 1.0, 1.0);
	var heaCol := Color.from_hsv(randf(), 1.0, 1.0);
	var haiCol := Color.from_hsv(randf(), 1.0, 1.0);
	
	if messages:
		usrNam = messages.scr_vrw_username()
		
	usrCol = Color.from_hsv(randf(), 1.0, 1.0);
	
	o_mg_vrw_untamo_left.set_head( 		index_head )
	o_mg_vrw_untamo_middle.set_head( 	index_head )
	o_mg_vrw_untamo_right.set_head( 	index_head )
	
	o_mg_vrw_untamo_left.set_eyes( 		index_eyes )
	o_mg_vrw_untamo_middle.set_eyes( 	index_eyes )
	o_mg_vrw_untamo_right.set_eyes( 	index_eyes )
	
	o_mg_vrw_untamo_left.set_hair( 		index_hair )
	o_mg_vrw_untamo_middle.set_hair( 	index_hair )
	o_mg_vrw_untamo_right.set_hair( 	index_hair )
	
	o_mg_vrw_untamo_left.set_mouth( 	index_mouth )
	o_mg_vrw_untamo_middle.set_mouth( 	index_mouth )
	o_mg_vrw_untamo_right.set_mouth( 	index_mouth )
	
	o_mg_vrw_untamo_left.set_nose( 		index_nose )
	o_mg_vrw_untamo_middle.set_nose( 	index_nose )
	o_mg_vrw_untamo_right.set_nose( 	index_nose )
	
	o_mg_vrw_untamo_left.set_body_color( 	bodCol )
	o_mg_vrw_untamo_middle.set_body_color( 	bodCol )
	o_mg_vrw_untamo_right.set_body_color( 	bodCol )
	
	o_mg_vrw_untamo_left.set_head_color( 	heaCol )
	o_mg_vrw_untamo_middle.set_head_color( 	heaCol )
	o_mg_vrw_untamo_right.set_head_color( 	heaCol )
	
	o_mg_vrw_untamo_left.set_hair_color( 	haiCol )
	o_mg_vrw_untamo_middle.set_hair_color( 	haiCol )
	o_mg_vrw_untamo_right.set_hair_color( 	haiCol )
