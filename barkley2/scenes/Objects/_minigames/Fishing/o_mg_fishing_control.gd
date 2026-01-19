extends CanvasLayer
# Controls the fishing minigame. Fucking annoying.
# NOTE Movement factorial -> https://www.youtube.com/watch?v=0QXZQjwBn68

const SN_FISHINGREEL_01 		:= preload("uid://b0e7hi7otspg6")
const SN_FISHINGREELFAST_01 	:= preload("uid://cd762s0kir751")

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

## Audio Stuff
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

## Battle UI
@onready var fish_battle_box_border: Control = $fish_battle_box_border

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

## UI Stuff
@onready var animation_player: AnimationPlayer = $AnimationPlayer

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

var caught_something	:= false
var hooked_fish			: B2_MiniGame_Fish

## Camera limits
@export var limit_width			:= Vector2(0,800)
@export var limit_height		:= Vector2(0,640)

func _ready() -> void:
	_set_room_return()
	_update_power_angle_data()
	_update_gunbag_data()
	_update_lure_data()
	_reset_bait()
	hide_battle_ui()
	
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
		
	var lure_thrown_speed := 2.0
	caught_something = false
		
	_reset_bait()
	
	## Check o_mg_fishing_lure -> begin step
	var t := create_tween()
	#t.tween_property( minigame_camera, "global_position", minigame_player.global_position, 0.5 ).set_trans(Tween.TRANS_CUBIC)
	t.tween_callback( minigame_lure.set_mod.bind( Color.WHITE ) )
	t.tween_interval( 0.5 )
	t.tween_callback( B2_Sound.play.bind("fishing_lure_cast") )
	t.tween_callback( minigame_player.cinema_playset.bind("fishingCast", "fishingIdle") )
	t.tween_interval( 0.6 )
	t.tween_callback( B2_Sound.play.bind("fishing_lure_fall") )
	t.tween_callback( _hide_ui )
	t.tween_callback( minigame_lure.show )
	t.tween_callback( minigame_lure.enable_shadow.bind(true) )
	t.tween_callback( minigame_lure.set_lure_rot.bind( Vector2.UP.angle(), 1.0 ) ) # Make the lure look up when thrown.
	t.tween_method( bait_offset, 0.0, -PI, lure_thrown_speed ) # 
	t.parallel().tween_property( minigame_lure, "global_position", minigame_lure_reticle.global_position, lure_thrown_speed )
	t.tween_callback( minigame_lure.enable_shadow.bind(false) ) # Lure hit the water, disable shadow and reduce the alpha.
	t.tween_callback( minigame_lure.splash )
	t.tween_callback( minigame_lure.set_mod.bind( Color( 0.25, 0.25, 0.25, 0.25 ) ) )
	#t.tween_callback( B2_Sound.play.bind("splash_out") )
	t.tween_callback( set.bind("curr_MODE", MODE.REELING) )
	t.tween_callback( _play_sfx.bind( false ) )

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

func _show_ui() -> void:
	animation_player.play("show_ui")
	
func _hide_ui() -> void:
	animation_player.play("hide_ui")

func check_fish_bait_collision() -> B2_MiniGame_Fish:
	var lure 						:= minigame_lure
	var room 						: B2_ROOMS = get_parent()
	var space_state 				:= room.get_world_2d().direct_space_state
	var params 						:= PhysicsPointQueryParameters2D.new()
	params.collide_with_areas 		= true
	params.collide_with_bodies 		= false
	#params.exclude = [ source_actor.get_rid() ]
	params.collision_mask 			= 0b00000000_00000000_00000000_00000101 ## --> https://docs.godotengine.org/en/4.5/tutorials/physics/physics_introduction.html#collision-layers-and-masks
	params.position 				= lure.global_position
	var result : Array[Dictionary] 	= space_state.intersect_point(params)
	if result:
		for r : Dictionary in result:
			# r["collider"] is a 'Area2D'. Parent should be 'B2_MiniGame_Fish'
			print( r["collider"].get_parent().name )
			return r["collider"].get_parent() as B2_MiniGame_Fish
				
	return null

func show_battle_ui() -> void:
	fish_battle_box_border.show()
	
func hide_battle_ui() -> void:
	fish_battle_box_border.hide()

## If you lose the minigame and the fish gets loose.
## NOTE 'lost_lish()' is spelled wrong, it was supposed to be 'lost_fish()'. I decided not to change it for fun.
func lost_lish() -> void:
	caught_something = false
	hide_battle_ui()
	
## Play the reeling sfx.
func _play_sfx( fast : bool ) -> void:
	match curr_MODE:
		MODE.REELING:
			#if not audio_stream_player.playing:
			if fast:		audio_stream_player.stream = SN_FISHINGREELFAST_01
			else:			audio_stream_player.stream = SN_FISHINGREEL_01
			audio_stream_player.play()
		_:
			#if audio_stream_player.playing:
			audio_stream_player.stop()

func _physics_process(_delta: float) -> void:
	match curr_MODE:
		MODE.SETUP:
			if Input.is_action_just_pressed("Action"):
				_play_sfx.bind( false )
				
				## TODO check before casting
				curr_MODE = MODE.THROW_BAIT
				_throw_bait()
				minigame_lure_pivot.set_input( false ) ## Disable recticle
				return
				
			_update_power_angle_data()
			_focus_camera( minigame_lure_reticle )
		MODE.THROW_BAIT:
			_focus_camera( minigame_lure )
		
		MODE.REELING:
			_focus_camera( minigame_lure )
			var lure_pos := minigame_lure.global_position
			var player_pos := minigame_player.global_position
			var lure_dir := lure_pos.direction_to(player_pos)
			if Input.is_action_pressed("Action"):
				lure_dir *= 1.5
				
			## Animation stuff based on if the player is holding the button.
			if Input.is_action_just_pressed("Action"):
				minigame_player.cinema_set("fishingCast2")
				_play_sfx( true )
			elif Input.is_action_just_released("Action"):
				minigame_player.cinema_set("fishingCast1")
				_play_sfx( false )
				
			lure_dir += ( Input.get_vector( "Left", "Right", "Up", "Down" ) * float( LURE_DATA[selected_lure][LURE_AERO] ) * 0.10 ) ## Apply player influence
			#lure_dir = lure_dir.normalized()
			minigame_lure.set_lure_rot( abs( lure_dir.angle() ), 0.025 ) # abs to avoid backward spin bullshit
			
			minigame_lure.global_position += lure_dir * 0.25
			
			## Check of caught something
			var _hooked_fish = check_fish_bait_collision()
			if _hooked_fish:
				if not caught_something: ## Just once, set some fish, lure and UI stuff
					caught_something = true
					hooked_fish = _hooked_fish
					hooked_fish.hooked = true
					show_battle_ui()
					print("Caught!!")
			else:
				if caught_something: ## Just once, unset some fish, lure and UI stuff
					caught_something = false
					if hooked_fish:
						hooked_fish.hooked = false
						hooked_fish = null
					hide_battle_ui()
					print("Lost...")
			
			var camera_speed := 0.1
			
			## Frame the battle UI
			if caught_something:
				minigame_camera.offset = minigame_camera.offset.lerp( Vector2(-50,0), camera_speed )
				minigame_camera.zoom = minigame_camera.zoom.lerp( Vector2(2,2) , camera_speed )
			else:
				minigame_camera.offset = minigame_camera.offset.lerp( Vector2(0,0), camera_speed )
				minigame_camera.zoom = minigame_camera.zoom.lerp( Vector2(1,1) , camera_speed )
				
			
			if minigame_lure.global_position.distance_to(minigame_player.global_position) < 45.0:
				# TODO check if caught something.
				if caught_something: 	# Caught something.
					curr_MODE = MODE.CAUGHT
					
				else:		# Caught nothing.
					curr_MODE = MODE.SETUP
					minigame_lure_pivot.set_input( true )
					minigame_lure.hide()
					minigame_lure.global_position = player_pos
					_show_ui()
				
				_play_sfx( false )
				
		## Hoopz has caught something.
		MODE.CAUGHT:
			pass
