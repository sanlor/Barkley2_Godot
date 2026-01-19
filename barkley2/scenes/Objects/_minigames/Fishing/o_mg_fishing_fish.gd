@icon("uid://codc2bcn8cjbk")
extends AnimatedSprite2D
class_name B2_MiniGame_Fish

@export var fishing_lure : B2_MiniGame_Lure

# Fish value
var value := 10

# MOVE ABOUT #
var move_x 					:= randi_range(-1,1)
var move_y 					:= randi_range(-1,1)
var x_origin 				:= position.x;
var y_origin 				:= position.y;
var wander_limit 			:= 48 + randi_range(0, 24 + value);
var hooked 					:= false;
var timer_hooked_spooked 	:= 5.0;
var timer_trashing 			:= 5.0;

var afraid_of_lure 			:= false

var target_pos				:= Vector2.ZERO

# SCAN #
var alpha_scan = 0;
var scanned = false;

var fish_gun : B2_Weapon

func _ready() -> void:
	#assert(fishing_lure, "Fishing lure export not set for %s." % name)
	
	_set_fish_value()
	wander_limit = 48 + randi_range(0, 24 + value);
	_set_fish_sprite()
	_set_afraid()
	@warning_ignore("integer_division")
	fish_gun = B2_Gun.generate_generic_gun(B2_Gun.TYPE.GUN_TYPE_NONE, B2_Gun.MATERIAL.NONE, { "gunsdrop": 20 + floor(value / 2) }) # check Drop line 84
	
	speed_scale = randf_range(1.0,2.0)
	play()
	
	x_origin = global_position.x
	y_origin = global_position.y
	
	_set_target()

func _set_target() -> void:
	target_pos = Vector2(x_origin, y_origin) + Vector2.LEFT.rotated( randf_range(0,TAU) ) * randf_range(5.0,30.0)

func _set_afraid() -> void:
	# AFRAID OF LURE OR NOT #
	if randi_range(0,100) <= 10 + (value * 0.5): afraid_of_lure = true;
	else: afraid_of_lure = false;

func _set_fish_sprite() -> void:
	# Sprite #
	if value <= 33: 		animation = "s_watershadow_small";
	elif value <= 66: 		animation = "s_watershadow_medium";
	else: 					animation = "s_watershadow_large";

func _set_fish_value() -> void:
	var room_node : B2_ROOMS = get_parent()
	var room := room_node.get_room_name()
	# Fish value, decides how good the gun is and how hard it is to catch the lunker //
	# BASIC LUNKERS - Sewers and the wasteland have pretty basic lunkers //
	# MEDIOCRE LUNKERS - Swamps, Dojo, Mines and Fary/Nexus have mediocre/good lunkers //
	# GOOF-TIER LUNKERS - Mountain has all ranges of lunkers, undersewers have the best tier lunkers, Cuchu's Lair has good tier lunkers // 
	if room == "r_fis_sewers01": value = 1 + randi_range(0,35);           # Max 36
	elif room == "r_fis_sewers02": value = 10 + randi_range(0,30);        # Max 40
	elif room == "r_fis_wasteland01": value = 20 + randi_range(0,10);     # Max 30
	elif room == "r_fis_nexus01": value = 15 + randi_range(0,25);         # Max 40
	elif room == "r_fis_swamps01": value = 55 + randi_range(0,30);        # Max 85
	elif room == "r_fis_ice01": value = 50 + randi_range(0,0);            # Max 50
	elif room == "r_fis_mines01": value = 30 + randi_range(0,40);         # Max 70
	elif room == "r_fis_mountain01": value = 1 + randi_range(0,98);       # Max 99
	elif room == "r_fis_undersewer01": value = 80 + randi_range(0,19);    # Max 99
	elif room == "r_fis_cuchu01": value = 20 + randi_range(0,79);         # Max 99
	else: value = 10;

func _physics_process(_delta: float) -> void:
	# rotation = lerpf( rotation, global_position.angle_to_point(target_pos) + 1.570, 0.01 ) # PI/2
	
	global_position = global_position.lerp( target_pos, 0.005 )
	
	if global_position.distance_to(target_pos) < 2.0:
		_set_target()
