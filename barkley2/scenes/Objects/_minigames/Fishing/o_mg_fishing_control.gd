extends CanvasLayer
# Controls the fishing minigame

## Lure stats ##
#    weight          - governs the maximum distance the lure can be cast
#    aerodynamics    - governs the speed at which you can control the lure both while its in midair and when its submerged
#    catch           - governs the strength of the lure in the catching minigame, aka the size of the circle inside which the fish icon must be kept
enum {LURE_NAME,LURE_WEIGHT,LURE_AERO,LURE_CATCH,LURE_DESCRIPTION,LURE_SPRITE}
const LURE_DATA := {
#									LURE_NAME,			LURE_WEIGHT,LURE_AERO,	LURE_CATCH,	LURE_DESCRIPTION,															LURE_SPRITE
	"F-Lure Bayou Goopster":		["Bayou Goopster",	6,			3,			2,			"A basic lure, a beginners lure."													,0],
	"F-Lure Devil's Drifter":		["Devil's Drifter",	10,			1,			7,			"A heavy and clumsy stalker, powerful beyond it's humble appearance."				,1],
	"F-Lure Tiger Tom":				["Tiger Tom",		4,			2,			5,			"A fast but otherwise average lure."												,2],
	"F-Lure Ladybug":				["Ladybug",			2,			10,			2,			"A lure that is almost weightless."													,3],
	"F-Lure Daverdale":				["Daverdale",		4,			4,			4,			"Incredibly powerful but clumsy lure."												,4],
	"F-Lure Dread Wonthy":			["Dread Wonthy",	3,			1,			8,			"Incredible catch."																	,5],
}
var selected_lure := "F-Lure Bayou Goopster"

# Go into setup mode, aka prepare to cast your lure 
enum MODE{SETUP,THROW_BAIT,FISHING,REELING,CAUGHT}
# SETUP - Choose bait and whete to throw
# THROW - Bait is thrown and is in the air
# FISHING - Bait is in the water, look for fishes
# REELING - Something bit the bait, reeling it in
# CAUGHT - Fish Caught
var curr_MODE := MODE.SETUP :
	set(c):
		curr_MODE = c
		print("%s: curr_MODE changed to %s." % [ name, MODE.keys()[c] ] )

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

@export var minigame_camera 		:	Camera2D
@export var minigame_lure_reticle 	: 	Node2D
@export var minigame_lure_pivot 	: 	Node2D
@export var minigame_player 		:	B2_InteractiveActor
@export var minigame_lure			:	Marker2D


# Strength and angle of your cast #
var strengthMinimum 	: float = 25; # You must cast this %
var strength 			: float = 10;
var angle 				: float = 45;

var fishingRoom 		:= "r_wst_wadingRace01"
var fishingX 			: float = 100;
var fishingY 			: float = 100;

## Camera limits
@export var limit_width			:= Vector2(0,800)
@export var limit_height		:= Vector2(0,640)

func _ready() -> void:
	_set_room_return()
	_update_power_angle_data()
	_update_gunbag_data()
	_update_lure_data()
	_reset_bait()
	
	#minigame_lure_reticle.updated_position.connect( player_look_at_lure )
	_change_mode.call_deferred()
			
func _change_mode() -> void:
	match curr_MODE:
		MODE.SETUP:
			minigame_player.cinema_set("fishingIdle")
			
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

func player_look_at_lure() -> void:
	minigame_player.cinema_lookat( minigame_lure_reticle )

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
	angle = roundi( abs(rad_to_deg( minigame_player.global_position.angle_to_point(minigame_lure_reticle.global_position) ) ) )
	strength = roundi( minigame_player.global_position.distance_to(minigame_lure_reticle.global_position) )
	if strength < strengthMinimum: power_lbl.modulate = Color.RED
	else: power_lbl.modulate = Color.WHITE
	
	angle_lbl.text = Text.pr( "Angle: %s" % int(angle) )
	power_lbl.text = Text.pr( "Power: " + str( int(strength) ) + "%" )

func _reset_bait() -> void:
	minigame_lure.hide()
	minigame_lure.global_position = minigame_player.global_position

func _throw_bait() -> void:
	var bait_offset := func( ti : float ):
		minigame_lure.set_y_offset( sin(ti) * 100.0 )
		#minigame_lure.scale = Vector2.ONE * ( 1 + sin( abs(ti) ) )
		if absf(ti) < PI/2:
			minigame_lure.set_lure_rot( Vector2.UP.angle() )
		else:
			minigame_lure.set_lure_rot( Vector2.DOWN.angle() )
		
	_reset_bait()
	var t := create_tween()
	#t.tween_property( minigame_camera, "global_position", minigame_player.global_position, 0.5 ).set_trans(Tween.TRANS_CUBIC)
	t.tween_interval( 0.5 )
	t.tween_callback( minigame_player.cinema_playset.bind("fishingCast", "fishingIdle") )
	t.tween_interval( 0.8 )
	t.tween_callback( minigame_lure.show )
	t.tween_callback( minigame_lure.enable_shadow.bind(true) )
	t.tween_method( bait_offset, 0.0, -PI, 2.0 )
	t.parallel().tween_property( minigame_lure, "global_position", minigame_lure_reticle.global_position, 2.0 )
	t.tween_callback( minigame_lure.enable_shadow.bind(false) )
	t.tween_callback( set.bind("curr_MODE", MODE.REELING) )

func _focus_camera( minigame_focus : Node2D ) -> void:
	if minigame_camera:
		minigame_camera.global_position = lerp( minigame_camera.global_position, minigame_focus.global_position, 1.5 )
		#print( minigame_camera.global_position )
		
		## Avoid seeing outside the map.
		# Taken from B2_Camera
		minigame_camera.offset.x = clamp( offset.x, limit_width.x + (384.0/2.0 - minigame_camera.global_position.x), limit_width.y - (384.0/2.0 + minigame_camera.global_position.x) )
		minigame_camera.offset.y = clamp( offset.y, limit_height.x + (240.0/2.0 - minigame_camera.global_position.y), limit_height.y - (240.0/2.0 + minigame_camera.global_position.y) )
	else:
		push_warning("Nodes not loaded.")

func _physics_process(_delta: float) -> void:
	match curr_MODE:
		MODE.SETUP:
			if Input.is_action_just_pressed("Action"):
				## TODO check before casting
				curr_MODE = MODE.THROW_BAIT
				_throw_bait()
				minigame_lure_pivot.set_input( false ) ## Disable recticle
				return
				
			_update_power_angle_data()
			_focus_camera( minigame_lure_reticle )
		MODE.THROW_BAIT:
			_focus_camera( minigame_lure )
