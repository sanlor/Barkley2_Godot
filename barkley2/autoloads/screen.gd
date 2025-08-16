extends CanvasLayer

# This autoload replaces o_curs, o_screen and o_pointer objects
# i think...

# This autoload handles the mouse cursor, along with its trail.
# WARNING This is becoming a huge mess. Stuff like SKILL_DISPLAY and MISSION_COMPLETE are instantiated on the room scene instead of here.

signal shop_closed
signal note_selected( note_string : String )

enum TYPE{POINT, HAND, BULLS, GRAB, CURSOR}
var curr_TYPE := TYPE.POINT

const UTILITYSTATION_SCREEN = preload("res://barkley2/scenes/_utilityStation/utilitystation_screen.tscn")
const MAP_SCREEN 			= preload("res://barkley2/scenes/Objects/System/_map/map_screen.tscn")
const PAUSE_SCREEN 			= preload("res://barkley2/scenes/Objects/System/pause_screen.tscn")
const QUICK_MENU_SCREEN 	= preload("res://barkley2/scenes/Objects/System/_quick_menu/quick_menu_screen.tscn")
const NOTE_SCREEN 			= preload("res://barkley2/scenes/Objects/System/_note/note_screen.tscn")
const SHOP_SCREEN 			= preload("res://barkley2/scenes/Objects/System/_shop/shop_screen.tscn")
const NOTIFY_ITEM 			= preload("res://barkley2/scenes/Objects/System/notify_item.tscn")
const GAME_OVER 			= preload("res://barkley2/scenes/_Godot_Combat/_gameover/game_over.tscn")

# Smoke Emitter
const O_SMOKE 				= preload("res://barkley2/scenes/_utilityStation/oSmoke.tscn")
const SMOKE_MASS 			= preload("uid://621y6e2ytfw1")

# battle related
const DAMAGE_NUMBER 				:= preload("res://barkley2/scenes/_Godot_Combat/_Damage_numbers/damage_number.tscn")
const MISSION_COMPLETE 				:= preload("uid://chpd2adtksefl")
const SKILL_DISPLAY 				:= preload("uid://douftxhh1k2w2")

# Item efffect
const O_ENTITY_INDICATOR_TEXT 		= preload("res://barkley2/scenes/_Godot_Combat/_combat/Indicators/o_entity_indicatorText.tscn")

# explosion sfx
const O_EFFECT_EXPLOSION 			= preload("res://barkley2/scenes/Objects/_effects/Misc/o_effect_explosion.tscn")

# Bloooooood
const O_EFFECT_BLOODDROP = preload("res://barkley2/scenes/_Godot_Combat/_blood/o_effect_blooddrop.tscn")

var title_screen_file := "res://barkley2/rooms/r_title.tscn"

@onready var mouse = $mouse
@onready var trail = $trail

var max_trail := 4 # 3 is pretty cool
var mouse_offset := Vector2.ZERO

var pause_screen: CanvasLayer
var can_pause := false # Cant pause during the title screens and certain parts.
var is_paused := false

var map_screen: CanvasLayer
var is_map_open := false

var note_screen: CanvasLayer
var is_notes_open := false

var quickmenu_screen: CanvasLayer
var is_quickmenu_open := false

var shop_screen: CanvasLayer
var is_shop_open := false

var utility_screen: CanvasLayer
var is_utility_open := false

func _ready() -> void:
	layer = B2_Config.SHADER_LAYER
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	set_cursor_type( TYPE.POINT )
	B2_Config.title_screen_loaded.connect( _reset_data )

func _reset_data():
	pause_screen 		= null
	can_pause 			= false
	is_paused 			= false

	map_screen 			= null
	is_map_open 		= false

	note_screen 		= null
	is_notes_open 		= false

	quickmenu_screen 	= null
	is_quickmenu_open 	= false

func set_cursor_type( type : TYPE) -> void:
	mouse.stop()
	match type:
		TYPE.POINT:
			mouse.animation = "point"
			mouse.frame = 0
			mouse.centered = true
			mouse_offset = Vector2.ZERO
			if not trail.is_inside_tree():
				add_child(trail)
		TYPE.HAND:
			mouse.animation = "hand"
			mouse.frame = 0
			mouse.centered = false
			mouse_offset = Vector2(-5,-4)
			if trail.is_inside_tree():
				remove_child(trail)
		TYPE.CURSOR:
			mouse.animation = "cursor"
			mouse.frame = 0
			mouse.centered = false
			mouse_offset = Vector2.ZERO
			if trail.is_inside_tree():
				remove_child(trail)
		TYPE.BULLS:
			mouse.animation = "bulls"
			mouse.play("bulls")
			mouse.frame = 0
			mouse.centered = true
			mouse_offset = Vector2.ZERO
			if trail.is_inside_tree():
				remove_child(trail)
		TYPE.GRAB:
			mouse.animation = "grab"
			mouse.frame = 0
			mouse.centered = false
			mouse_offset = Vector2(-5,-4)
			if trail.is_inside_tree():
				remove_child(trail)
			
	curr_TYPE = type
	mouse.modulate.a = 1.0
			

func is_any_menu_open() -> bool:
	return B2_Screen.is_map_open or B2_Screen.is_notes_open or B2_Screen.is_shop_open or B2_Screen.is_quickmenu_open

func display_damage_number( caller_node : Node, damage : float, color := Color.WHITE, linger_time := 2.0 ) -> void:
	var d = DAMAGE_NUMBER.instantiate()
	d.setup(caller_node, damage, linger_time)
	d.modulate = color
	caller_node.add_sibling(d)

## TODO
# scr_items_candy_use_fromMap
func display_item_effect( header : String, text : String ) -> void:
	var it := O_ENTITY_INDICATOR_TEXT.instantiate()
	it.setup_labels( header, "+" + text + "HP" )
	var origin_node
	
	if is_instance_valid( B2_CManager.o_cbt_hoopz ):
		origin_node = B2_CManager.o_cbt_hoopz
	elif is_instance_valid( B2_CManager.o_cts_hoopz ):
		origin_node = B2_CManager.o_cts_hoopz
	elif is_instance_valid( B2_CManager.o_hoopz ):
		origin_node = B2_CManager.o_hoopz
	else:
		push_error("WTF, no hoopz model is loaded?")
		breakpoint
		
	origin_node.add_sibling( it, true )
	print( "B2_Screen: Item effect spawned near ", origin_node.name )
	
	it.global_position = origin_node.global_position

func show_skill_name( skill_name : String ) -> void:
	var skill := SKILL_DISPLAY.instantiate()
	add_child( skill, true )
	skill.set_skill_name( skill_name )

func show_mission_complete_screen() -> void:
	var mission := MISSION_COMPLETE.instantiate()
	add_child( mission, true )
	B2_Input.player_has_control = false
	await mission.animation_finished
	B2_Input.player_has_control = true

func show_notify_screen( text : String ) -> void:
	var notice = NOTIFY_ITEM.instantiate()
	get_tree().current_scene.add_child( notice, true )
	await notice.show_notify_screen( text )
	
# check Smoke() /// Smoke("puff" / "mass", x, y, z, scl / type)
# this is a general purpose smoke emitter
func add_smoke(type : String, pos : Vector2, color : Color, time : float, _scale := 1.0 ) -> void:
	var my_smoke := O_SMOKE.instantiate()
	my_smoke.lifetime = time
	my_smoke.position = pos
	my_smoke.modulate = color
	my_smoke.scale *= _scale
	match type:
		"mass":
			my_smoke.process_material = SMOKE_MASS
		_:
			breakpoint
			
	get_tree().current_scene.add_child( my_smoke )

## scr_fx_explosion_createFromType()
## There are 10 types of explosions. Im adding them as I go aling
func make_explosion(type : int, pos : Vector2, color := Color.WHITE, delay := 0.0, _scale := 1.0 ) -> void:
	var explosion := O_EFFECT_EXPLOSION.instantiate()
	match type:
		2:
			explosion.init_Radius 			= 12;
			explosion.att_RadiusGain 		= 0.75;
			explosion.init_Pow 				= 12 + 3;
			explosion.att_PowGain 			= -0.4;
			explosion.att_PowRand 			= 8;
			explosion.init_Interval 		= 0.2;
			explosion.att_IntervalGain 		= 0.1;
			explosion.att_IntervalRand 		= 0.2;
			explosion.att_Time 				= 8;
			B2_CManager.camera.add_shake( 8, 140, pos.x, pos.y, 0.5 ) # ( 8, 140, pos.x, pos.y, 0.5 );
		_:
			push_error("Undefined type of explosion: ", type)
			
	explosion.explosion_sfx_name 	= "explosion_generic_" + str( type )
	explosion.position 				= pos
	explosion.modulate 				= color
	explosion.delay 				= delay
	explosion.z_index				= 1
	get_tree().current_scene.add_child( explosion, true )
	
	add_smoke( "mass", pos, Color( 0.25, 0.25, 0.25, randf_range(0.10, 0.25 )), 0.5, 0.15 )

func make_blood_drop( pos : Vector2, amount : int, color := Color.RED, velocity_mod := 1.0 ) -> void:
	# print( "blood create at %s." % str(pos) )
	for i in amount:
		var blood := O_EFFECT_BLOODDROP.instantiate()
		blood.position 				= pos
		blood.puddle_color			= color
		blood.z_index				= 0
		blood.velocity_mod			= velocity_mod
		get_tree().current_scene.add_child( blood, true )

func _physics_process(_delta: float) -> void:
	if trail.is_inside_tree():
		trail.modulate.a = mouse.modulate.a
		trail.add_point( mouse.position )
		if trail.get_point_count() > max_trail:
			trail.remove_point( 0 )
			
func _process(_delta: float) -> void:
	## Mouse stuff
	mouse.position = get_viewport().get_mouse_position().round() + mouse_offset
	
	if curr_TYPE == TYPE.POINT:
		mouse.modulate.a = randf_range(0.55,0.90)
	if curr_TYPE == TYPE.GRAB:
		if Input.is_action_pressed("Action"):
			mouse.frame = 1
		else:
			mouse.frame = 0
		
	# Pause stuff
	if can_pause: ## DEBUG
		if Input.is_action_just_pressed("Pause"):
			if is_map_open:
				hide_map_screen()
				return
				
			if is_paused:
				hide_pause_menu()
			else:
				show_pause_menu()
				
		# Map stuff
		## WARNING Missing aditional checks for open menus.
		# Its only checking for cutscenes and pause screen.
		if Input.is_action_just_pressed("Map"):
			if (not is_paused or is_map_open) and is_instance_valid(B2_CManager.o_hoopz):
				if is_notes_open: # check for others open screens.
					return
				if is_quickmenu_open:
					return
					
				if is_map_open:
					hide_map_screen()
				else:
					show_map_screen()
					
		if Input.is_action_just_pressed("Note"):
			if (not is_paused or is_notes_open) and is_instance_valid(B2_CManager.o_hoopz):
				if is_map_open: # check for others open screens.
					return
				if is_quickmenu_open:
					return
					
				if is_notes_open:
					hide_note_screen()
				else:
					show_note_screen()
					
		if Input.is_action_just_pressed("Quickmenu"):
			if (not is_paused or is_quickmenu_open) and is_instance_valid(B2_CManager.o_hoopz):
				if is_map_open: # check for others open screens.
					return
					
				if is_notes_open: # check for others open screens.
					return
				
				if is_quickmenu_open:
					hide_quickmenu_screen()
				else:
					show_quickmenu_screen()

func _notification(what: int) -> void: ## Pause game when the windows loses focus
	if what == NOTIFICATION_APPLICATION_FOCUS_OUT:
		if can_pause and not is_paused:
			# show_pause_menu() ## DEBUG
			pass

func show_defeat_screen() -> void:
	var gameover := GAME_OVER.instantiate()
	get_tree().current_scene.add_child( gameover )

# Show pausemenu object
func show_pause_menu() -> void:
	is_paused = true
	pause_screen = PAUSE_SCREEN.instantiate()
	get_tree().current_scene.add_child( pause_screen )
	B2_Music.volume_menu()
	
func hide_pause_menu() -> void:
	if is_instance_valid(pause_screen): # Debug errors
		pause_screen.queue_free()
	is_paused = false
	if not is_any_menu_open(): ## Issues with quick menu open while unpausing.
		get_tree().paused = false
	B2_Sound.play_pick("pausemenu_click")
	B2_Music.volume_menu()

## Map
func show_map_screen() -> void:
	is_map_open = true
	get_tree().paused = true
	map_screen = MAP_SCREEN.instantiate()
	get_tree().current_scene.add_child( map_screen )
	B2_Music.volume_menu()
	
	if is_instance_valid(B2_CManager.o_hud):
		B2_CManager.o_hud.hide_hud()
	
func hide_map_screen() -> void:
	if is_instance_valid(map_screen): # Debug errors
		await map_screen.hide_menu()
		map_screen.queue_free()
	is_map_open = false
	get_tree().paused = false
	B2_Music.volume_menu()
	
	if is_instance_valid(B2_CManager.o_hud):
		B2_CManager.o_hud.show_hud()

## Shop
func show_shop_screen( shop_name : String ) -> void:
	is_shop_open = true
	get_tree().paused = true
	shop_screen = SHOP_SCREEN.instantiate()
	shop_screen.my_shop_name = shop_name
	get_tree().current_scene.add_child( shop_screen )
	B2_Music.volume_menu()
	
	#if is_instance_valid(B2_CManager.o_hud):
		#B2_CManager.o_hud.hide_hud()

func hide_shop_screen() -> void:
	if is_instance_valid(shop_screen): # Debug errors
		await shop_screen.hide_menu()
		shop_screen.queue_free()
	is_shop_open = false
	get_tree().paused = false
	B2_Music.volume_menu()
	
	#if is_instance_valid(B2_CManager.o_hud):
		#B2_CManager.o_hud.show_hud()
	shop_closed.emit()
	
## Note
func show_note_screen( mode := 0 ) -> void:
	is_notes_open = true
	get_tree().paused = true
	note_screen = NOTE_SCREEN.instantiate()
	note_screen.mode = mode
	get_tree().current_scene.add_child( note_screen )
	B2_Music.volume_menu()
	
	if is_instance_valid(B2_CManager.o_hud):
		B2_CManager.o_hud.hide_hud()

func hide_note_screen() -> void:
	if is_instance_valid(note_screen): # Debug errors
		await note_screen.hide_menu()
		note_screen.queue_free()
	is_notes_open = false
	get_tree().paused = false
	B2_Music.volume_menu()
	
	if not B2_Input.cutscene_is_playing:
		if is_instance_valid(B2_CManager.o_hud):
			B2_CManager.o_hud.show_hud()

## Quick Menu
func show_quickmenu_screen() -> void:
	is_quickmenu_open = true
	get_tree().paused = true
	quickmenu_screen = QUICK_MENU_SCREEN.instantiate()
	get_tree().current_scene.add_child( quickmenu_screen )
	B2_Music.volume_menu()
	
	#if is_instance_valid(B2_CManager.o_hud):
	#	B2_CManager.o_hud.hide_hud()

func hide_quickmenu_screen( unpause := false ) -> void:
	if is_instance_valid(quickmenu_screen): # Debug errors
		await quickmenu_screen.hide_menu()
		quickmenu_screen.queue_free()
	is_quickmenu_open = false
	get_tree().paused = unpause
	B2_Music.volume_menu()
	
	#if is_instance_valid(B2_CManager.o_hud):
	#	B2_CManager.o_hud.show_hud()

func return_to_title():
	if B2_Playerdata.record_curr_location():
		B2_Playerdata.SaveGame() ## Do the saving bit.
	
	B2_Sound.stop_loop()
	get_tree().change_scene_to_file( title_screen_file )
	get_tree().paused = false
