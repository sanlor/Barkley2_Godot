extends CanvasLayer

@onready var r_title = get_parent()

@onready var game_slot_1 				: B2_Border_Button = $game_slot_1
@onready var game_slot_2 				: B2_Border_Button = $game_slot_2
@onready var game_slot_3 				: B2_Border_Button = $game_slot_3
@onready var game_slot_back_panel 		: B2_Border_Button = $back_panel
@onready var game_slot_delete_panel 	: B2_Border_Button = $delete_panel

## Game slots
var gameslot_width = 344 - 8;

var gameslot_x = 30;
var gameslot_y = 10; 

var gameslot_row = 60 - 2;
var gameslot_gap = 10;

# Obliterate button
var gameslot_destruct_x = 244;
var gameslot_destruct_y = 214;

# back button
var gameslot_back_x = 40;
var gameslot_back_y = 214;

## Godot
var selected_gameslot := 0 

func _ready():
	r_title.mode_change.connect( change_delete_button )
	
	game_slot_1.button_pressed.connect( _on_game_slot_1_button_pressed )
	game_slot_2.button_pressed.connect( _on_game_slot_2_button_pressed )
	game_slot_3.button_pressed.connect( _on_game_slot_3_button_pressed )
	
	game_slot_back_panel.button_pressed.connect( _on_back_panel_button_pressed )
	game_slot_delete_panel .button_pressed.connect( _on_delete_panel_button_pressed )
	
	#region Character Slots
	game_slot_back_panel.set_panel_size(100, 32)
	game_slot_back_panel.set_global_position( Vector2(gameslot_back_x - 8, gameslot_back_y - 8) )
	
	var backlabel := Label.new()
	backlabel.text = "Back"
	backlabel.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	backlabel.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	backlabel.size = Vector2(100, 32)
	game_slot_back_panel.add_decorations(backlabel)
	
	game_slot_delete_panel.set_panel_size(100, 32)
	game_slot_delete_panel.set_global_position( Vector2(gameslot_destruct_x - 8, gameslot_destruct_y - 8) )
	var deletelabel := backlabel.duplicate()
	deletelabel.text = "Obliterate"
	game_slot_delete_panel.add_decorations(deletelabel)
	
	game_slot_delete_panel.content_selected_color = Color.RED
	game_slot_delete_panel.content_highlight_color = Color.RED
	
	load_slots()
	
	# endregion
func load_slots():
	## Character Slots
	var slots := [game_slot_1,game_slot_2,game_slot_3]
	for slot in slots:
		for child in slot.get_children():
			if child is B2_Border_Foreground:
				continue
			
			(child as Label).queue_free()
				
	for i in 3:
		var dry = gameslot_y + gameslot_row * i + gameslot_gap * i;
		slots[i].set_panel_size( 344, 66 )
		slots[i].monitor_mouse = true
		slots[i].set_global_position( Vector2(gameslot_x - 8, dry - 8) )
		
		var label := Label.new()
		label.text = "Vacant Slot"
		label.size = slots[i].get_panel_size()
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		if i == 0:
			label.text += "\n(Canon Playthrough, do not steal)"
			label.position.y += (35.0 / 4.0)
			#label.set_position( Vector2(gameslot_x + 170, gameslot_y + gameslot_row * i + gameslot_gap * i + 35) ) ## 170
		else:
			#label.set_position( Vector2(gameslot_x + 170, gameslot_y + gameslot_row * i + gameslot_gap * i + 20) ) ## 170
			pass
			
		slots[i].add_decorations(label)

func change_delete_button():
	if r_title.mode == "destruct_confirm":
		game_slot_delete_panel.is_pressed = true
	else:
		game_slot_delete_panel.is_pressed = false

func show_delete_confirmation():
	var oConfirm : B2_Confirm = preload("res://barkley2/scenes/confirm/b2_confirm.tscn").instantiate()
	oConfirm.option1_pressed.connect( delete_gameslot 						) # Yes
	oConfirm.option2_pressed.connect( func(): r_title.mode = "gameslot"; game_slot_delete_panel.is_pressed = false 	) # No
	add_child(oConfirm)

func delete_gameslot():
	# selected_gameslot ## TODO Delete the gameslot ##### CRITICAL UNFINISHED!!!!!!
	game_slot_delete_panel.is_pressed = false
	r_title.mode = "gameslot"

func _on_game_slot_1_button_pressed():
	selected_gameslot = 0
	if r_title.mode == "destruct_confirm":
		show_delete_confirmation()
	else:
		r_title.mode = "gamestart_character"
		hide()

func _on_game_slot_2_button_pressed():
	selected_gameslot = 1
	if r_title.mode == "destruct_confirm":
		show_delete_confirmation()
	else:
		r_title.mode = "gamestart_character"
		hide()

func _on_game_slot_3_button_pressed():
	selected_gameslot = 2
	if r_title.mode == "destruct_confirm":
		show_delete_confirmation()
	else:
		r_title.mode = "gamestart_character"
		hide()

func _on_back_panel_button_pressed():
	r_title.mode = "basic"
	hide()

func _on_delete_panel_button_pressed():
	r_title.mode = "destruct_confirm"
