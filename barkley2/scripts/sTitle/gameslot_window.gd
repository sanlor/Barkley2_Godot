extends CanvasLayer

@onready var r_title = get_parent()

@onready var game_slot_1 = $game_slot_1
@onready var game_slot_2 = $game_slot_2
@onready var game_slot_3 = $game_slot_3
@onready var game_slot_back_panel = $back_panel
@onready var game_slot_delete_panel = $delete_panel

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

func _ready():
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
	game_slot_delete_panel.selected_color = Color.RED
	
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
	
func _on_game_slot_1_button_pressed():
	pass # Replace with function body.

func _on_game_slot_2_button_pressed():
	pass # Replace with function body.

func _on_game_slot_3_button_pressed():
	pass # Replace with function body.

func _on_back_panel_button_pressed():
	r_title.mode = "basic"
	hide()

func _on_delete_panel_button_pressed():
	pass # Replace with function body.
