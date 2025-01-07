extends CanvasLayer

# check quickmenu2()
# check q_menu_left, q_menu_right, q_menu_top, q_menu_bottom
## When the player presses Q, this quickmenu is shown.

## TODO Add chat function (Top)
## TODO Add Zaubers visualization (Top)
## TODO Add Stats (Right)
## TODO Add Guns, Guns staus and such. (Left)
## TODO Figure what a gun bag is and how to populate it. (Left)
## TODO Add Candies (Bottom)

## Top
const top_hidden_y 	:= -60.0
const top_shown_y 	:= 0.0
@onready var top: B2_Border = $top


## Right
const right_hidden_x 	:= 384.0
const right_shown_x 	:= 318.0
@onready var right: B2_Border = $right

@onready var shift_knob: TextureRect = $right/shift_box/shift_knob
@onready var defense_stat: Label = $right/defense/defense_stat

## Stats
const left_hidden_x 	:= -111.0
const left_shown_x 		:= -11.0
const left_gun_hidden_x	:= -201
const left_gun_shown_x	:= 0
@onready var left: Control = $left
@onready var gun_name_panel: B2_Border = $gun_name_panel

@onready var g_stat: Label = $right/glamp/G_stat
@onready var l_stat: Label = $right/glamp/L_stat
@onready var a_stat: Label = $right/glamp/A_stat
@onready var m_stat: Label = $right/glamp/M_stat
@onready var p_stat: Label = $right/glamp/P_stat

@onready var lvl_stat: Label = $right/lvl_stat
@onready var hp_stat: Label = $right/hp_stat
@onready var weight_stat: Label = $right/weight_stat

## Bottom
const bottom_hidden_y 	:= 210.0
const bottom_shown_y 	:= 140.0
@onready var bottom: Control = $bottom

## Malaises
@onready var status_effects: 	Control 	= $right/status_effects
@onready var malaises_none: 	Label 		= $right/status_effects/malaises_none

## CUUUUUUUUUUUUUUURSE!
@onready var curse_status: Label = $right/curse_status

## Inventory
const inv_hidden_y 	:= -210.0
const inv_shown_y 	:= 0.0
@onready var inventory: B2_Border = $inventory

var tween : Tween
const tween_speed := 0.15

func _ready() -> void:
	load_top_menu() # Zaubers and shiet.
	load_right_menu() # Stats and gearshift knob.
	B2_Screen.set_cursor_type( B2_Screen.TYPE.CURSOR )
	
	left.position.x 			= left_hidden_x
	right.position.x 			= right_hidden_x
	top.position.y 				= top_hidden_y
	bottom.position.y 			= bottom_hidden_y
	gun_name_panel.position.x 	= left_gun_hidden_x
	inventory.position.y 		= inv_hidden_y
	inventory.hide()
	
	show_menu()
	
	tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(left, "position:x", left_shown_x, tween_speed * randf_range(0.9,1.1) )
	#tween.tween_property(gun_name_panel, "position:x", left_gun_shown_x, tween_speed * randf_range(0.9,1.1) )
	tween.tween_property(right, "position:x", right_shown_x, tween_speed * randf_range(0.9,1.1) )
	tween.tween_property(top, "position:y", top_shown_y, tween_speed * randf_range(0.9,1.1) )
	tween.tween_property(bottom, "position:y", bottom_shown_y, tween_speed * randf_range(0.9,1.1) )
	
func show_menu():
	tween = create_tween()
	
	tween.tween_callback(left.show)
	tween.tween_callback(gun_name_panel.show)
	tween.tween_callback(right.show)
	tween.tween_callback(top.show)
	tween.tween_callback(bottom.show)
	
	tween.set_parallel(true)
	tween.tween_property(left, "position:x", left_shown_x, tween_speed * randf_range(0.9,1.1) )
	#tween.tween_property(gun_name_panel, "position:x", left_gun_shown_x, tween_speed * randf_range(0.9,1.1) )
	tween.tween_property(right, "position:x", right_shown_x, tween_speed * randf_range(0.9,1.1) )
	tween.tween_property(top, "position:y", top_shown_y, tween_speed * randf_range(0.9,1.1) )
	tween.tween_property(bottom, "position:y", bottom_shown_y, tween_speed * randf_range(0.9,1.1) )
	return await tween.finished
	
func hide_menu():
	B2_Screen.set_cursor_type( B2_Screen.TYPE.POINT )
	if is_instance_valid(tween):
		tween.kill()
	tween = create_tween()
	
	tween.set_parallel(true)
	tween.tween_property(left, "position:x", left_hidden_x, tween_speed * randf_range(0.9,1.1) )
	tween.tween_property(gun_name_panel, "position:x", left_gun_hidden_x, tween_speed * randf_range(0.9,1.1) )
	tween.tween_property(right, "position:x", right_hidden_x, tween_speed * randf_range(0.9,1.1) )
	tween.tween_property(top, "position:y", top_hidden_y, tween_speed * randf_range(0.9,1.1) )
	tween.tween_property(bottom, "position:y", bottom_hidden_y, tween_speed * randf_range(0.9,1.1) )
	if inventory.visible:
		tween.tween_property( inventory, "position:y", inv_hidden_y, tween_speed * randf_range(0.6,0.8) )
	tween.set_parallel(false)
	
	tween.tween_callback(left.hide)
	tween.tween_callback(gun_name_panel.hide)
	tween.tween_callback(right.hide)
	tween.tween_callback(top.hide)
	tween.tween_callback(bottom.hide)
	
	return await tween.finished

func _on_o_btn_pressed() -> void:
	B2_Screen.hide_quickmenu_screen()

func _on_maps_btn_pressed() -> void:
	B2_Screen.hide_quickmenu_screen( true )
	B2_Screen.show_map_screen()
	
func _on_notes_btn_pressed() -> void:
	B2_Screen.hide_quickmenu_screen( true )
	B2_Screen.show_note_screen()

func _on_chat_btn_pressed() -> void:
	## TODO implement chat function.
	B2_Sound.play("sn_busted01")

func _on_items_btn_pressed() -> void:
	await hide_menu()
	tween = create_tween()
	tween.tween_callback( inventory.show )
	tween.tween_property(inventory, "position:y", inv_shown_y, tween_speed * randf_range(0.6,0.8) )
	
	await inventory.closed
	
	tween = create_tween()
	tween.tween_property( inventory, "position:y", inv_hidden_y, tween_speed * randf_range(0.6,0.8) )
	tween.tween_callback( inventory.hide )
	await tween.finished
	show_menu()

func load_top_menu() -> void:
	## TODO Add Zaubers
	pass

func load_right_menu() -> void:
	## Gear knob position. Check q_menu_right - Draw End - Line 48
	var player_speed : int = B2_Playerdata.Stat("speed") ## TODO get the real player speed.
	var maxSpeed := 15;
	
	#match 4: ## DEBUG
	match floor( ( min( maxSpeed, player_speed) /maxSpeed ) * 5):
		0: shift_knob.position = Vector2( 1, 7)
		1: shift_knob.position = Vector2( 7, 7)
		2: shift_knob.position = Vector2( 11, 7)
		3: shift_knob.position = Vector2( 3, 17)
		4: shift_knob.position = Vector2( 9, 17)
		_:
			## OOB
			breakpoint
	shift_knob.position -= Vector2( 4, 9) ## weird offset.
	
	## Defense stat
	defense_stat.text = str( B2_Playerdata.Stat("res_normal") )

	## GLAMP
	g_stat.text = str( B2_Playerdata.Stat("GUTS") )
	l_stat.text = str( B2_Playerdata.Stat("LUCK") )
	a_stat.text = str( B2_Playerdata.Stat("AGILE") )
	m_stat.text = str( B2_Playerdata.Stat("MIGHT") )
	p_stat.text = str( B2_Playerdata.Stat("PIETY") )
	
	## LVL and HP
	lvl_stat.text 		= str( B2_Config.get_user_save_data( "player.xp.questxp", 0 ) )
	hp_stat.text 		= str( 69 ) ## lol. ## TODO Add a way to check for player HP
	weight_stat.text 	= str( B2_Playerdata.Stat("weight") ) ## WARNING The position of this label is not wrong. Its like that on the original game too.
	
	## Malaises
	## TODO Implement status effects
	var list_status_effect := Array() # Im assuming the status are strings here.
	
	if not list_status_effect.is_empty():
		malaises_none.queue_free()
		
		for i in range( list_status_effect.size() ):
			var stat = list_status_effect[i]
			var l := Label.new()
			l.text = str(stat)
			l.name = str(stat)
			
			l.label_settings = LabelSettings.new()
			l.label_settings.font = preload("res://barkley2/resources/fonts/fn_7ocs.tres")
			l.label_settings.font_color = Color.YELLOW
			l.position = Vector2( 10, 60 + 15 * i )
			status_effects.add_child( l, true )
			
	## Some curse, IDK
	if B2_Playerdata.Quest("mummysCurse") == 1:
		curse_status.text = Text.pr("Scourged")

func flicker() -> void:
	## NOTE It this an expensive function?
	var alpha := randf_range(0.55, 1.0)
	right.flicker(alpha)
	left.flicker(alpha)
	top.flicker(alpha)
	bottom.flicker(alpha)
	inventory.flicker(alpha)
	
func _physics_process(delta: float) -> void:
	if randf() > 0.35:
		flicker()
