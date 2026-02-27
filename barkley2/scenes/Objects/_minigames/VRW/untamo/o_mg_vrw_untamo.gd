extends B2_Minigame_VRW_Object
class_name B2_Minigame_VRW_Untamo

## Weird script that controls how untamos as spawned.
# NOTE no idea what a untamo is. maybe the player characters in O.O.? why this name?
## Since the map "r_bct_vrw_town02" infinitelly scrolls on the X axis, each untamos has 3 simultaneous sprites to fool the player.
# Check 'o_mg_vrw_untamo' and 'o_mg_vrw_object' and 'o_mg_vrw_untamo_spawner', bitch.

# Check 'o_mg_vrw_object' draw event.
var o_mg_vrw_untamo_body : Array[Node2D]

@export var messages : B2_Minigame_VRW_Messages

var usrNam := "PLACEHOLDER"
var usrCol := Color.HOT_PINK

var my_identity := 0

func _ready() -> void:
	var index_head 	:= randi_range( 0,7		);
	var index_eyes 	:= randi_range( 0,14	);
	var index_hair 	:= randi_range( 0,14	);
	var index_mouth := randi_range( 0,14	);
	var index_nose 	:= randi_range( 0,14	);
	var bodCol 		:= Color.from_hsv(randf(), 1.0, 1.0);
	var heaCol 		:= Color.from_hsv(randf(), 1.0, 1.0);
	var haiCol 		:= Color.from_hsv(randf(), 1.0, 1.0);
	
	usrCol = Color.from_hsv( randf(), 1.0, 1.0 );
	
	## Clone object
	var child : B2_Minigame_VRW_Untamo_Body = get_children().front()
	assert( child, "More than one child is not expected. Check this shit out, homie." )
	o_mg_vrw_untamo_body = B2_Minigame_VRW_Object.dew_it( child )
	o_mg_vrw_untamo_body.append( child )
	
	## Set username for this ped.
	usrNam = B2_Minigame_VRW_Messages.scr_vrw_username()
		
	await get_tree().process_frame
	for body : B2_Minigame_VRW_Untamo_Body in o_mg_vrw_untamo_body:
		body.set_head( 			index_head )
		body.set_eyes( 			index_eyes )
		body.set_hair( 			index_hair )
		body.set_mouth( 		index_mouth )
		body.set_nose( 			index_nose )
		body.set_body_color( 	bodCol )
		body.set_head_color( 	heaCol )
		body.set_hair_color( 	haiCol )
