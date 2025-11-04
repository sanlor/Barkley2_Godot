extends CanvasLayer

@onready var r_title = get_parent()

@onready var game_slot_1 				: B2_Border_Button = $game_slot_1
@onready var game_slot_2 				: B2_Border_Button = $game_slot_2
@onready var game_slot_3 				: B2_Border_Button = $game_slot_3
@onready var game_slot_back_panel 		: B2_Border_Button = $back_panel
@onready var game_slot_delete_panel 	: B2_Border_Button = $delete_panel

@onready var fade_out = $fade_out

## Game slots
var gameslot_width 			: float = 344 - 8;

var gameslot_x 				: float = 30;
var gameslot_y 				: float = 10; 

var gameslot_row 			: float = 60 - 2;
var gameslot_gap 			: float = 10;

# Obliterate button
var gameslot_destruct_x 	: float = 244;
var gameslot_destruct_y 	: float = 214;

# back button
var gameslot_back_x 		: float = 40;
var gameslot_back_y 		: float = 214;

## Godot
var selected_gameslot := 0 
var slot_has_data := [
	false,
	false,
	false, ]


func _ready():
	B2_Config.language_changed.connect( load_slots )
	
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
	backlabel.text = Text.pr("Back")
	backlabel.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	backlabel.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	backlabel.size = Vector2(100, 32)
	game_slot_back_panel.add_decorations(backlabel)
	
	game_slot_delete_panel.set_panel_size(100, 32)
	game_slot_delete_panel.set_global_position( Vector2(gameslot_destruct_x - 8, gameslot_destruct_y - 8) )
	var deletelabel := backlabel.duplicate()
	deletelabel.text = Text.pr("Obliterate")
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
			
			child.queue_free()
				
	for i in 3:
		var dry : float = gameslot_y + gameslot_row * i + gameslot_gap * i;
		slots[i].set_panel_size( 344, 66 )
		slots[i].monitor_mouse = true
		slots[i].set_global_position( Vector2(gameslot_x - 8, dry - 8) )
		
		if B2_Config.has_user_save( i ):		# this slot has saved game. get player data from the file
			B2_Config.select_user_slot( i )
			
			slot_has_data[i] = true
			var spc = 12;
			
			var gameslot_name = Text.pr( str( B2_Config.get_user_save_data("quest.vars.playerNameFull") ) )## string(scr_savedata_get("quest.vars.playerNameFull"));
			var gameslot_mood = Text.pr( "Crestfallen" ); # scr_savedata_get();
			var gameslot_level = Text.pr( "Level " + str( B2_Config.get_user_save_data("player.xp.level") ) )## string(scr_savedata_get("player.xp.level"));
			var gameslot_chapter = Text.pr( "Chapter name" );
			var gameslot_gormstones = 1; # scr_savedata_get("money");
			var gameslot_gametime = Text.pr( str( B2_Config.get_user_save_data("clock.time") ) )## string(scr_savedata_get("clock.time"));
			var gameslot_location = Text.pr( str( B2_Config.get_user_save_data("map.room") ) )## string(scr_savedata_get("map.room"));
			var my_tim = ( 24.0 - B2_Config.get_user_save_data("clock.time", 0.0) / 3600.0) / 24.0 ## if(i == 0) tim = (24 - real(scr_savedata_get("clock.time")) / 3600)/24;
			r_title.tim = max(r_title.tim, my_tim)
			
			## Portrait
			var pl_port := TextureRect.new()
			slots[i].add_child( pl_port )
			pl_port.texture = preload("res://barkley2/assets/b2_original/images/sGlebFace.png") ## Static picture. its the same on the demo, for some reason.
			pl_port.global_position = Vector2( gameslot_x + 1, dry + 3 )
			#slots[i].add_decorations( pl_port )
			
			## Name
			var pl_name := Label.new()
			pl_name.modulate = Color.WHITE
			slots[i].add_decorations( pl_name )
			pl_name.text = gameslot_name
			pl_name.global_position = Vector2( gameslot_x + 40, dry + 2 + (spc * 0) )
			#slots[i].add_child( pl_name )
			
			## Mood
			var pl_mood := Label.new()
			pl_mood.modulate = Color8(90, 240, 40)
			slots[i].add_decorations( pl_mood )
			pl_mood.text = gameslot_mood
			pl_mood.global_position = Vector2( gameslot_x + 40, dry + 2 + (spc * 1) )
			#slots[i].add_child( pl_mood )
			
			## Level
			var pl_level := Label.new()
			pl_level.modulate = Color8(240, 240, 60)
			slots[i].add_decorations( pl_level )
			pl_level.text = gameslot_level
			pl_level.global_position = Vector2( gameslot_x + 40, dry + 2 + (spc * 2) )
			#slots[i].add_child( pl_level )
			
			## Gorm Stones collected ## NOTE WTF is this? This is an incomplete feature on the demo.
			for g in gameslot_gormstones:
				var gorm := TextureRect.new()
				slots[i].add_child( gorm )
				gorm.texture = preload("res://barkley2/assets/b2_original/images/sGormstone.png") ## Static picture. its the same on the demo, for some reason.
				gorm.global_position = Vector2( gameslot_x + 40 + g * 12, dry + (spc * 3) )
				
				
			## Chapter title
			var pl_chapter := Label.new()
			pl_chapter.modulate = Color8(220, 220, 255)
			slots[i].add_decorations( pl_chapter )
			pl_chapter.text = gameslot_chapter
			pl_chapter.global_position = Vector2( gameslot_x + 120, dry + 2 + (spc * 0) )
			#slots[i].add_child( pl_chapter )
			
			
			## Time and Location
			var pl_time := Label.new()
			slots[i].add_decorations( pl_time )
			pl_time.text = gameslot_gametime
			pl_time.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
			pl_time.global_position 		= Vector2( gameslot_x + 320, dry + 20 )
			pl_time.global_position.x 		-= pl_time.size.x
			#slots[i].add_child( pl_time )
			
			var pl_location := Label.new()
			slots[i].add_decorations( pl_location )
			pl_location.text = gameslot_location
			pl_location.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
			pl_location.global_position 		= Vector2( gameslot_x + 320, dry + 4 )
			pl_location.global_position.x 		-= pl_location.size.x
			#slots[i].add_child( pl_location )
			
		else:									# this slot has no saved game. show vacant slot
			slot_has_data[i] = false
			var label := Label.new()
			label.text = Text.pr( "Vacant Slot" )
			label.size = slots[i].get_panel_size()
			label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
			if i == 0:
				label.text += Text.pr( "\n(Canon Playthrough, do not steal)" )
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
	oConfirm.givTxt = Text.pr("Is this the game you want to destruct?")
	oConfirm.option1_pressed.connect( delete_gameslot 						) # Yes
	oConfirm.option2_pressed.connect( func(): r_title.mode = "gameslot"; game_slot_delete_panel.is_pressed = false 	) # No
	add_child( oConfirm )

func delete_gameslot():
	if slot_has_data[ selected_gameslot ]:
		# selected_gameslot ## TODO Delete the gameslot ##### CRITICAL UNFINISHED!!!!!!
		# the original demo had a bug where you could delete a vacant spot. This simulates this issue.
		B2_Config.delete_user_save_data( selected_gameslot )
		load_slots()
		
	game_slot_delete_panel.is_pressed = false
	r_title.mode = "gameslot"
	game_slot_delete_panel.grab_focus()

func start_saved_game():
	fade_out.show()
	fade_out.modulate.a = 0.0
	
	var saved_room = str( B2_Config.get_user_save_data("map.room") )
	B2_Music.stop( 0.25 )
	## DEBUG Stuff.
	#if saved_room == "r_fct_eggRooms01": # this is the only room ready.
	#	B2_RoomXY.warp_to( saved_room, 1.0 )
	#else:
	#	B2_RoomXY.warp_to( "r_wip", 1.0 ) # load WIP room if someone tries do messe with the save system
	#tween.tween_callback( get_tree().change_scene_to_file.bind( "res://barkley2/rooms/r_wip.tscn" ) ) # in the final game, we should ask something what room to load.
	var room_name 	:= str( B2_Config.get_user_save_data("map.room", "big_butts") )
	var room_x 		:= str( B2_Config.get_user_save_data("map.x", 0) )
	var room_y 		:= str( B2_Config.get_user_save_data("map.y", 0) )
	B2_RoomXY.warp_to( room_name + "," + room_x + ","  + room_y + ",1", 0.5 )

func _on_game_slot_1_button_pressed():
	selected_gameslot = 0
	B2_Config.select_user_slot( 0 )
	if r_title.mode == "destruct_confirm":
		show_delete_confirmation()
	elif B2_Config.has_user_save( selected_gameslot ):
		start_saved_game()
	else:
		B2_Config.select_user_slot( selected_gameslot )
		r_title.mode = "gamestart_character"
		hide()

func _on_game_slot_2_button_pressed():
	selected_gameslot = 1
	B2_Config.select_user_slot( 1 )
	if r_title.mode == "destruct_confirm":
		show_delete_confirmation()
	elif B2_Config.has_user_save( selected_gameslot ):
		start_saved_game()
	else:
		B2_Config.select_user_slot( selected_gameslot )
		r_title.mode = "gamestart_character"
		hide()

func _on_game_slot_3_button_pressed():
	selected_gameslot = 2
	B2_Config.select_user_slot( 2 )
	if r_title.mode == "destruct_confirm":
		show_delete_confirmation()
	elif B2_Config.has_user_save( selected_gameslot ):
		start_saved_game()
	else:
		B2_Config.select_user_slot( selected_gameslot )
		r_title.mode = "gamestart_character"
		hide()

func _on_back_panel_button_pressed():
	r_title.mode = "basic"
	hide()

func _on_delete_panel_button_pressed():
	r_title.mode = "destruct_confirm"

func _on_visibility_changed() -> void:
	if visible:
		game_slot_1.grab_focus()
