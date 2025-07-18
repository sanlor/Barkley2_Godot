@tool
extends CanvasLayer
class_name B2_Dialogue

# DEBUG
@export var debug := false

## Auto Skip
var auto_skipping := false # Should be false from the start. enabled only when the player holds the action key.

const S_DIAG_FRAME 		= preload("res://barkley2/assets/b2_original/images/merged/s_diag_frame.png")
const S_RETURN 			= preload("res://barkley2/assets/b2_original/images/merged/s_return.png")
# reference script = o_dialogue

const LINE_SIZE := 9

# The title of the text, defaults to an empty string.
var _title = "";

## Important
# The full text that should be displayed.
var _my_text = "";
# The x offset to draw the dialogue at, defaults to 8.
var _draw_x = 8;
# The y offset to draw the dialogue at, defaults to 0.
var _draw_y = 140;

# The different colors for the different texts, defaults are set below.
var _title_color 	= Color.LIGHT_BLUE # c_ltblue;
#var _text_color 	= Color.WHITE # c_white;

# The sound used whenever characters are typed.
var _talk_sound 	= "sn_talk1";
# The sound used whenever a textbox is completed and the player selects to go to the next one.
var _confirm_sound 	= "sn_talk3";

# Draw without the dialog box
#var _boxless = false; 				## WARNING Set this up when the time comes.
# Draw the normal dialog box
#var _normal_backdrop = true; 		## WARNING Set this up when the time comes.
# Draw the mystery dialog box // Usable for Mysterious voices heard from the darkness etc.
#var _mystery_backdrop = false; 	## WARNING Set this up when the time comes.

# Blink
#var blink = 0;
#var blinkTime = 4; # Variance in blink, 4 means it can be from 4 to 6 seconds (4 + (4 / 2))
#var blinkDuration = 0.2; # Duration of blink
#var blinkCount = randf_range( 0, blinkTime + ( blinkTime / 2 ) ) # random(blinkTime + (blinkTime / 2));
var flourishFrame = 0; 				## WARNING Set this up when the time comes.

## NOTE seems interesting
var style = 1; # 0 is old style, 1 is generated

## GODOT specific
signal finished_typing
signal input_pressed
signal awnsered_question( bool )

var return_sprite : Sprite2D

var textbox_width := 384
var textbox_height := 240
var text_offset = textbox_width - 64;

var border_node 			: B2_Border
var portrait_frame_node 	: TextureRect
var portrait_img_node 		: AnimatedSprite2D

var title_node 				: RichTextLabel
var text_node 				: RichTextLabel

var has_portrait := false
var port_load_failed := false

## Typing stuff
var textbox_pause 			:= 0.015 	#0.05; # Set tyhe typing speed.
var textbox_talk_cooldown 	:= 0.04 	#0.04;
var textbox_blink_cooldown 	:= 0.04 	#0.04;

var comma_pause 			:= 0.15 			#0.1
var period_pause 			:= 0.30 			#0.5
var dash_pause 				:= 0.20 			#0.2
var question_pause 			:= 0.45 			#0.5 ## Added by me, not on the original.
var exclamation_pause 		:= 0.45 			#0.5 ## Added by me, not on the original.

var normal_typing 			:= 0.8			#1.0
var fast_typing 			:= 0.2
var curr_typing_speed := normal_typing

var portrait_talk_speed		:= 0.1
var portrait_talk_time 		:= -100.0

var portrait_talk_frame		:= 0 # Animation frame for the protrait

var return_sprite_time 		:= 0.2		#0.2
var return_sprite_cooldown 	:= 0.2	#0.2

var type_timer := 0.0
var can_type := false
var is_typing := false

var voice_sound_played := false

var is_waiting_input := false
var text_delays : PackedInt32Array

## Textbox Screens (More than 4 lines of texts)
var max_screens 	:= 1
var curr_screen 	:= 1
const max_lines		:= 4

## Portrait stuff
var blink_cooldown 	:= 0.0
var blink_speed 	:= 5.50
var is_talking		:= false

func _ready() -> void:
	if debug: print_debug("DEBUG enabled.")
	layer = B2_Config.DIALOG_LAYER
	_draw_y = B2_Config.dialogY # set the diag box on top or on the bottom. almost always, its on the bottom.
	
	# Setup the dinamic frame
	border_node = B2_Border.new()
	border_node.bg_opacity = 0.85
	border_node.set_seed( get_tree().root.get_child(0).name ) # This ensures that the border is random, but doesnt change all the time.
	
	# Identify this diag box
	name = "Dialog_box"
	
	add_child( border_node )
	border_node.name = "Dialog_Frame"
	border_node.position = Vector2( _draw_x, _draw_y )
	border_node.set_panel_size( textbox_width - _draw_x * 2, 48 + 44 )
	
	input_pressed.connect( handle_input )
	
	# Setup the return sprite (the one that blinks while waiting input
	return_sprite = Sprite2D.new()
	return_sprite.centered 		= false
	return_sprite.texture 		= S_RETURN
	border_node.add_child( return_sprite, true )
	return_sprite.position 		= border_node.size - Vector2(24,24)
	
	fastforward_control( B2_Input.is_fastforwarding )
	B2_Input.fastforward_request.connect( fastforward_control )
	
func fastforward_control( active : bool ):
	auto_skipping = active
	#if active:
		#curr_typing_speed = fast_typing
	#else:
	curr_typing_speed = normal_typing
	
func set_textbox_pos( _pos : Vector2, _size := Vector2.ZERO ) -> void:
	border_node.position = _pos
	border_node.set_panel_size( _size.x, _size.y )

func set_text( _text : String, _text_title := "" ) -> void:
	if not _text_title.is_empty():
		title_node 	= RichTextLabel.new(); add_child(title_node, true); title_node.bbcode_enabled = true
		title_node.theme = preload("res://barkley2/themes/dialogue_game.tres")
		_title 		= _text_title 	# whos speaking the text
		
	# Setup Text RTL
	text_node 	= RichTextLabel.new(); add_child(text_node); text_node.bbcode_enabled = true; text_node.scroll_active = false; text_node.visible_characters_behavior = TextServer.VC_CHARS_AFTER_SHAPING; text_node.clip_contents = false
	text_node.theme = preload("res://barkley2/themes/dialogue_game.tres")
	_my_text 	= _text 		# text dialog
	
func set_portrait( portrait_name : String, from_name := true ) -> void:
	if from_name:
		_load_portrait( B2_Gamedata.portrait_from_name.get(portrait_name, "s_portrait") ) # load the talker´s picture from its name. If the name is invalid, load a temp picture
	else:
		_load_portrait( portrait_name ) # load the talker´s picture
		
	if not port_load_failed:
		# Add the frame to the tree
		portrait_frame_node = TextureRect.new(); 
		add_child( portrait_frame_node, true ) 
		portrait_frame_node.texture = S_DIAG_FRAME
		portrait_frame_node.position = Vector2( _draw_x + 15, _draw_y + 8 + 5 )
	
		portrait_frame_node.add_child( portrait_img_node ) # add the actual portrait 
		has_portrait = true
	
func display_dialog( _is_boxless := false ):
	var _text_offset := 0
	if has_portrait: 
		_text_offset = 40
	
	if not title_node == null:
		title_node.name 		= "Title_text"
		title_node.position 	= Vector2( _draw_x + 30 + _text_offset, _draw_y + 12 + 5 )
		title_node.size 		= Vector2( 250, 12 )

		title_node.push_color( _title_color )
		title_node.append_text( Text.pr( _title ) )
		title_node.pop_all()
	
	text_node.name 				= "Text"
	text_node.size 				= Vector2( 264, LINE_SIZE * max_lines) ## NOTE If you change the font, also change this. Was Vector2( 264, 11 * 4)
	text_node.theme.set_constant("line_separation", "RichTextLabel", 1)
	
	if not has_portrait: 
		text_node.size.x += 64 # compensate for the aditional space not being used by the portrait.
	text_node.position 			= Vector2( _draw_x + 30 + _text_offset, _draw_y + 12 + 5 + 16)
	text_node.get_v_scroll_bar().custom_step = LINE_SIZE # avoid partial scroll
	
	text_node.set_text( Text.pr( _my_text ) )
	
	# Add the delay points for the text ("_")
	text_delays = Text.get_delays( text_node.get_parsed_text() ) ## NOTE might have an issue with more than 3 delays.
	if debug: print( "Text delays: ", text_delays )
	
	# remove delay reference
	text_node.set_text( text_node.get_text().replace("_", "").strip_edges() ) 
	
	can_type = true
	text_node.visible_characters = 0
	type_timer = textbox_pause * curr_typing_speed
	
	# IMPORTANT - DiagBox only show 4 lines per screen and waits for input. If the text has 5 or 6 lines, add 3 or 2 more lines to pad the diag box.
	## CRITICAL this doesnt work right with 5 lines.
	if text_node.get_line_count() > 4:
		@warning_ignore("integer_division")
		max_screens 	= ceili( float( text_node.get_line_count() ) / float(max_lines) )
		var additional_lines : int =  max_lines - (text_node.get_line_count() % max_lines) # <- im a genius at math! Modulus! after 15 year, something from my highschool is finally useful!
		if debug: print( "max_screens: ", max_screens," - Lines: ",text_node.get_line_count() ); print("Adding %s lines." % str( additional_lines ) )
		for r in additional_lines:
			# new line pad the scrollbox
			text_node.text += "\n " # <- This space is important. dont know why, it just is.
			if debug: print("adding extra line")
	
	## Oh the joy of debug weird erros.
	# the code above sometimes creates a window with 4 "\n".
	# the code below is a hack because its easier that fixing the issue.
	if text_node.get_text().ends_with("\n \n \n \n "):
		text_node.set_text( text_node.get_text().trim_suffix( "\n \n \n \n " ) )
		if debug: print_debug("newline hack applied!")
	await finished_typing
	return

## Manually add the character portraits and setup the AnimatedSprite2D
func _load_portrait( portrait_name : String ):
	var file_name : String = B2_Gamedata.portrait_map.get( portrait_name, "" )
	var spritesheet : Texture2D
	
	if file_name.is_empty():
		#has_portrait = false
		port_load_failed = true
		push_error("Dialogue received an invalid portrait ' %s '. Disabling this portrait..." % portrait_name)
		return
	
	if not file_name.is_valid_filename():
		push_warning("Weird, filename ' %s ' doesnt seem valid. Trying to fix it... ' %s '." % [file_name, portrait_name] )
		spritesheet = ResourceLoader.load( B2_Gamedata.PORTRAIT_PATH + file_name + ".png")
	else:
		spritesheet = ResourceLoader.load( B2_Gamedata.PORTRAIT_PATH + file_name )
		
	@warning_ignore("integer_division")
	var n_frames := int( spritesheet.get_width() / 34 ) ## This should return the correct amount of frames.
	if debug: print( "n_frames: ", n_frames, " ", spritesheet.get_width() )
	## WARNING more than 9 frames might be an issue.
	assert( n_frames > 0, "I warned you bro! ^^^^^^")
	# Potraits should never have _strip0
	
	# Setup node
	portrait_img_node = AnimatedSprite2D.new()
	portrait_img_node.centered = false
	portrait_img_node.offset = Vector2(8, 10) # trial and error
	
	var anim_frames := SpriteFrames.new()
	anim_frames.add_animation( "blink" )
	anim_frames.add_animation( "talk" )
	
	@warning_ignore("integer_division")
	var d_offset := int( spritesheet.get_width() / n_frames )
	
	for f in n_frames:
		var frame_tex := AtlasTexture.new( )
		frame_tex.atlas = spritesheet
		var frame_offset = d_offset * f
		frame_tex.region = Rect2( Vector2(frame_offset, 0), Vector2( d_offset, spritesheet.get_height() ) )
		if f == 0:
			anim_frames.add_frame("blink", frame_tex )
		if f > 0 and f < n_frames - 1:
			anim_frames.add_frame("talk", frame_tex )
		if f == n_frames - 1:
			anim_frames.add_frame("blink", frame_tex )
			
	portrait_img_node.sprite_frames = anim_frames
	
func show_box(): # allow showing the dialog box with some fancy animation
	show()

func hide_box(): # allow hiding the dialog box with some fancy animation
	hide()

func _portrait_is_silent():
	if not has_portrait:
		return
	voice_sound_played = false
	is_talking = false
	portrait_img_node.animation = "blink"
	portrait_img_node.frame = 0

func _portrait_is_talking(delta):
	if not has_portrait:
		return
	# allow to control the speed for the portrait animation.
	if portrait_talk_time < 0:
		portrait_talk_time = portrait_talk_speed
		is_talking = true
		blink_cooldown = blink_speed

		portrait_img_node.animation = "talk"
		var max_frame = portrait_img_node.sprite_frames.get_frame_count( "talk" )
		#var new_frame := wrapi( portrait_img_node.frame + 1, 0, max_frame )
		portrait_talk_frame = wrapi( portrait_talk_frame + 1, 0, max_frame )
		portrait_img_node.frame = portrait_talk_frame
		## WARNING The code above is incomplete.
		# Its missing the part that "randomize" the talking Frames by skipping some frames sometimes.
		# check scr_event_action_dialogue()
		# check o_dialogue draw_end event.
	else:
		portrait_talk_time -= 15.0 * delta
		#is_talking = false

func _type_next_letter(delta):
	if is_waiting_input:
		return
		
	if type_timer >= 0.0 and curr_typing_speed == normal_typing: # Waste time until the timer is below 0.0
		type_timer -= delta
	else:
		if text_node.get_character_line( text_node.visible_characters ) >= max_lines * curr_screen:
			is_typing = false
			if debug: print("Waiting for input to write text.")
			curr_typing_speed = normal_typing
			_portrait_is_silent()
			return_sprite.visible = true
			
			await wait_user_input()
				
			text_node.scroll_to_line( max_lines * curr_screen )
			curr_screen += 1
			
		var add_wait := 0.0
		
		var curr_char : String = text_node.get_parsed_text() [ text_node.visible_characters ]
		is_typing = true
		
		match curr_char: # add a pause for certain characters
			" ":
				add_wait = 0.0
				voice_sound_played = false
				_portrait_is_silent()
			",": # "-" is a global const DIALOGUE_DELAY on the original
				add_wait = comma_pause
				_portrait_is_silent()
			".":
				add_wait = period_pause
				_portrait_is_silent()
			"-":
				add_wait = dash_pause
				_portrait_is_silent()
			"!":
				add_wait = exclamation_pause
				_portrait_is_silent()
			"?":
				add_wait = question_pause
				_portrait_is_silent()
			"\n":
				# Does this even work?
				_portrait_is_silent()
			_:
				# Avoid playing sounds when players skips
				if curr_typing_speed == normal_typing:
					# This ensures that the voice clip only plays at the start of a phrase.
					if not voice_sound_played:
						B2_Sound.play( _talk_sound, 0.0, false, 1, 1.0 )
						voice_sound_played = true
					_portrait_is_talking(delta)
					
		var amount_text := 1
		
		type_timer = ( textbox_pause + add_wait ) * curr_typing_speed
		
		if curr_typing_speed == fast_typing:
			amount_text = 10
			type_timer = 0
		
		if auto_skipping:
			@warning_ignore("narrowing_conversion")
			if OS.has_feature("web"):
				amount_text = 10 # Fixes for slow typing in html5 exports
			else:
				amount_text = 1
			type_timer = 0
		
		# Avoid issues with the text skipping
		if not text_node.visible_ratio == 1.0: 
			text_node.visible_characters += amount_text
			
		# Avoid issues with the line counting routine.
		text_node.visible_characters = clampi(text_node.visible_characters, 0, text_node.get_parsed_text().length())
		
		if text_delays.has( text_node.visible_characters ):
			add_wait = comma_pause * 2.5
			_portrait_is_silent()
			if debug: print(" !!! hit a '_', Waiting for %s seconds." % add_wait)
			type_timer = ( textbox_pause + add_wait ) * curr_typing_speed


func wait_user_input():
	is_waiting_input = true
	if not auto_skipping and not Input.is_action_pressed("Holster"): ## last condition is a quick fix for FFWDing during parts of the dialog.
		await input_pressed
		B2_Sound.play( _confirm_sound, 0.0, false, 1, 1.0 )
	is_waiting_input = false

func handle_input():
	if text_node.visible_ratio < 1.0 and is_typing:
		curr_typing_speed = fast_typing
		B2_Sound.play( _talk_sound, 0.0, false, 1, 1.0 )

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
		
	# Handle portrait animation and blinking
	if has_portrait:
		if not is_talking:
			blink_cooldown -= delta
			
			if blink_cooldown < 0.0:
				portrait_img_node.animation = "blink"
				
				if portrait_img_node.frame == 1:
					blink_cooldown = blink_speed
					portrait_img_node.frame = 0
				else:
					blink_cooldown = blink_speed / 16.0
					portrait_img_node.frame = 1
			
	if Input.is_action_just_pressed("Action") or Input.is_action_just_pressed("Holster"):
		input_pressed.emit()
		
	# Type text to textbox
	if can_type and not is_waiting_input:
		return_sprite.visible = false
		_type_next_letter(delta)
		
		# All text was typed
		if text_node.visible_characters >= text_node.get_parsed_text().length():
			curr_typing_speed = normal_typing
			can_type = false
			is_typing = false
			return_sprite.visible = true
			_portrait_is_silent()
			if debug: print("Finished typing")
			await wait_user_input()
			finished_typing.emit()
			hide_box()
	else:
		return_sprite_time += delta * 10
		return_sprite.offset.y = int( sin(return_sprite_time) * 2 )
