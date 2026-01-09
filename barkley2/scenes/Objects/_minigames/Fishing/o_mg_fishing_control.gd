extends CanvasLayer
# Controls the fishing minigame

## Lure stats ##
#    weight          - governs the maximum distance the lure can be cast
#    aerodynamics    - governs the speed at which you can control the lure both while its in midair and when its submerged
#    catch           - governs the strength of the lure in the catching minigame, aka the size of the circle inside which the fish icon must be kept
enum {LURE_NAME,LURE_WEIGHT,LURE_AERO,LURE_CATCH,LURE_DESCRIPTION,LURE_SPRITE}
const LURE_DATA := {
	"F-Lure Bayou Goopster":		["Bayou Goopster",6,3,2,"A basic lure, a beginners lure."													,0],
	"F-Lure Devil's Drifter":		["Devil's Drifter",10,1,7,"A heavy and clumsy stalker, powerful beyond it's humble appearance."				,1],
	"F-Lure Tiger Tom":				["Tiger Tom",4,2,5,"A fast but otherwise average lure."														,2],
	"F-Lure Ladybug":				["Ladybug",2,10,2,"A lure that is almost weightless."														,3],
	"F-Lure Daverdale":				["Daverdale",4,4,4,"Incredibly powerful but clumsy lure."													,4],
	"F-Lure Dread Wonthy":			["Dread Wonthy",3,1,8,"Incredible catch."																	,5],
}
var selected_lure := "F-Lure Bayou Goopster"

# Go into setup mode, aka prepare to cast your lure 
enum MODE{SETUP}
var curr_MODE := MODE.SETUP

## Lure Stuff
@onready var lure_sprite_texture: 	TextureRect = $lure_data_border/MarginContainer/VBoxContainer/HBoxContainer/lure_sprite_texture
@onready var lure_name_lbl: 		Label = $lure_data_border/MarginContainer/VBoxContainer/HBoxContainer/lure_name_lbl
@onready var weight_title_lbl: 		Label = $lure_data_border/MarginContainer/VBoxContainer/weight_cont/weight_title_lbl
@onready var weight_value_lbl: 		Label = $lure_data_border/MarginContainer/VBoxContainer/weight_cont/weight_value_lbl
@onready var aero_title_lbl: 		Label = $lure_data_border/MarginContainer/VBoxContainer/aero_cont/aero_title_lbl
@onready var aero_value_lbl: 		Label = $lure_data_border/MarginContainer/VBoxContainer/aero_cont/aero_value_lbl
@onready var potential_title_lbl: 	Label = $lure_data_border/MarginContainer/VBoxContainer/potential_cont/potential_title_lbl
@onready var potential_value_lbl: 	Label = $lure_data_border/MarginContainer/VBoxContainer/potential_cont/potential_value_lbl

## Angle and power stuff
@onready var power_lbl: 			Label = $power_angle_border/MarginContainer/HBoxContainer/power_lbl
@onready var angle_lbl: 			Label = $power_angle_border/MarginContainer/HBoxContainer/angle_lbl

## Gunbag stuff
@onready var gunbag_capacity_lbl: 	Label = $gunbag_capacity_border/MarginContainer/gunbag_capacity_lbl


# Strength and angle of your cast #
var strengthMinimum 	: float = 25; # You must cast this %
var strength 			: float = 10;
var angle 				: float = 45;

var fishingRoom 		:= "r_wst_wadingRace01"
var fishingX 			: float = 100;
var fishingY 			: float = 100;

func _ready() -> void:
	_set_room_return()
	_update_power_angle_data()
	_update_gunbag_data()
	_update_lure_data()
			
func _set_room_return() -> void:
	if get_parent() is not B2_ROOMS:
		push_error("Fishing minigame is the child or the wrong node: %s." % get_parent().name)
		return
		
	var my_room : B2_ROOMS = get_parent()
	
	match my_room.get_room_name():
		"r_fis_sewers01":
			fishingRoom = "r_sw1_utility01";
			fishingX = 256;
			fishingY = 256;
		"r_fis_sewers02":
			fishingRoom = "r_sw2_hermitPass01";
			fishingX = 264;
			fishingY = 464;
		"r_fis_swamps01":
			fishingRoom = "r_swp_beach01";
			fishingX = 752;
			fishingY = 280;
		"r_fis_wasteland01":
			fishingRoom = "r_wst_wadingRace01";
			fishingX = 184;
			fishingY = 304;
		"r_fis_nexus01":
			fishingRoom = "r_far_nexus01";
			fishingX = 1080;
			fishingY = 832;
		"r_fis_ice01":
			fishingRoom = "r_ice_dojoOutdoors01";
			fishingX = 608;
			fishingY = 368;
		"r_fis_cuchu01":
			fishingRoom = "r_chu_pool01";
			fishingX = 304;
			fishingY = 208;
		"r_fis_mines01":
			fishingRoom = "r_min_entrance01";
			fishingX = 752;
			fishingY = 248;

func _update_lure_data() -> void:
	if LURE_DATA.has(selected_lure):
		var lure_data : Array = LURE_DATA[selected_lure]
		lure_sprite_texture.texture.region.position.x = lure_data[LURE_SPRITE] * 16
		lure_name_lbl.text 			= Text.pr( lure_data[LURE_NAME] )
		weight_value_lbl.text 		= str(lure_data[LURE_WEIGHT])
		aero_value_lbl.text 		= str(lure_data[LURE_AERO])
		potential_value_lbl.text 	= str(lure_data[LURE_CATCH])
	
func _update_gunbag_data() -> void:
	gunbag_capacity_lbl.text = Text.pr( "Gun'sbag capacity: %s/%s" % [ B2_Gun.get_gunbag().size(), B2_Gun.GUNBAG_SIZE] )
	
func _update_power_angle_data() -> void:
	power_lbl.text = Text.pr("Power: %s" % roundi(strength))
	if strength < strengthMinimum: power_lbl.modulate = Color.RED
	else: power_lbl.modulate = Color.WHITE
	
	angle_lbl.text = Text.pr("Angle: %s" % roundi(angle))
