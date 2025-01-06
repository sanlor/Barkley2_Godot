extends CanvasLayer

# check quickmenu2()
# check q_menu_left, q_menu_right, q_menu_top, q_menu_bottom
## When the player presses Q, this quickmenu is shown.

## TODO Add chat function
## TODO Add Zaubers visualization

## Top
#wid = (SCREEN_WIDTH/4)*3;
#hei = SCREEN_HEIGHT/4;

## Right
@onready var shift_knob: TextureRect = $right/shift_box/shift_knob
@onready var defense_stat: Label = $right/defense/defense_stat

## Stats
@onready var g_stat: Label = $right/glamp/G_stat
@onready var l_stat: Label = $right/glamp/L_stat
@onready var a_stat: Label = $right/glamp/A_stat
@onready var m_stat: Label = $right/glamp/M_stat
@onready var p_stat: Label = $right/glamp/P_stat

@onready var lvl_stat: Label = $right/lvl_stat
@onready var hp_stat: Label = $right/hp_stat
@onready var weight_stat: Label = $right/weight_stat

## Malaises
@onready var status_effects: 	Control 	= $right/status_effects
@onready var malaises_none: 	Label 		= $right/status_effects/malaises_none

## CUUUUUUUUUUUUUUURSE!
@onready var curse_status: Label = $right/curse_status

func _ready() -> void:
	load_top_menu() # Zaubers and shiet.
	load_right_menu() # Stats and gearshift knob.
	
func hide_menu():
	return

func _on_o_btn_pressed() -> void:
	B2_Screen.hide_quickmenu_screen()


func _on_maps_btn_pressed() -> void:
	pass # Replace with function body.


func _on_notes_btn_pressed() -> void:
	pass # Replace with function body.


func _on_chat_btn_pressed() -> void:
	pass # Replace with function body.


func _on_items_btn_pressed() -> void:
	pass # Replace with function body.

func load_top_menu() -> void:
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
