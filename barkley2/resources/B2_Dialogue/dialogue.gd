@tool
extends Control
class_name B2_Dialogue

const S_DIAG_FRAME = preload("res://barkley2/assets/b2_original/images/merged/s_diag_frame.png")


# reference script = o_dialogue

## Related Garage from the Settings():
	#// DO NOT TOUCH SETTINGS BELOW
	#global.fadeRoomTemp = -1; //For custom fade times
#
	#global.dialogFrame = s_diag_frame;
	#global.dialogCorner = s_diag_corner;
	#global.dialogReturn = s_return;
	#global.dialogEdge = s_diag_edge;
	#global.dialogBG = s_diag_bg;
	#global.dialogBGalt = s_diag_bg_alt;

	# Portrait frame.
	# draw_sprite(_diag_frame, 0, portrait_frame_left, portrait_frame_top);
	# Actual portrait.
	#draw_sprite(_portrait, _talk_frame, portrait_left, portrait_top);
	#if (global.portraitFlicker)
	#{
		#var ptf = random(0.05);
		#ptf += abs(lengthdir_x(0.1, current_time / 3));
		#ptf += abs(lengthdir_y(0.1, current_time / 11));
		#draw_sprite_ext(_portrait, _talk_frame, portrait_left, portrait_top, 1, 1, 0, c_black, ptf);
	#}

# The title of the text, defaults to an empty string.
var _title = "";
# The portrait for this text, defaults to NULL.
# var _portrait = null;  NOTE Not used in Godot
# The number of frames a portrait has.
# var _portrait_frames = null; NOTE Not used in Godot
# The speed of the portrait animation.
var _portrait_speed = 1.0 # global.dialogFaceSpeed * global.dialogSpeed; // * global.dialogSpeed; //was 0.5;
# True if the portrait animation should always play, or false if we want normal animation.
var _always_play_portrait_animation = false;

## Important
# The full text that should be displayed.
var _my_text = "";
var _text_length = 0;
# The x offset to draw the dialogue at, defaults to 8.
var _draw_x = 8;
# The y offset to draw the dialogue at, defaults to 0.
var _draw_y = 140;
# if (global.dialogY == -1) _draw_y = 140;
# else _draw_y = global.dialogY;

# The amount of lines this textbox has, defaults to 4.
var _lines = 4;
# The amount of characters that are added per 1/10s, defaults to 3.
var _text_speed = 3;

# The different colors for the different texts, defaults are set below.
var _title_color 	= Color.LIGHT_BLUE # c_ltblue;
var _text_color 	= Color.WHITE # c_white;

# The sound used whenever characters are typed.
var _talk_sound 	= "sn_talk1";
# The sound used whenever a textbox is completed and the player selects to go to the next one.
var _confirm_sound 	= "sn_talk3";

# Draw without the dialog box
var _boxless = false;
# Draw the normal dialog box
var _normal_backdrop = true;
# Draw the mystery dialog box // Usable for Mysterious voices heard from the darkness etc.
var _mystery_backdrop = false;

# Blink
var blink = 0;
var blinkTime = 4; # Variance in blink, 4 means it can be from 4 to 6 seconds (4 + (4 / 2))
var blinkDuration = 0.2; # Duration of blink
var blinkCount = randf_range( 0, blinkTime + ( blinkTime / 2 ) ) # random(blinkTime + (blinkTime / 2));
var flourishFrame = 0;

## NOTE seems interesting
var style = 1; # 0 is old style, 1 is generated

## GODOT specific
signal finished_typing
signal input_pressed
signal awnsered_question( bool )

var textbox_width := 384
var textbox_height := 240
var text_offset = textbox_width - 64;

var border_node 			: B2_Border
var portrait_frame_node 	: TextureRect
var portrait_img_node 		: AnimatedSprite2D

var title_node 				: RichTextLabel
var text_node 				: RichTextLabel

var has_portrait := false

## Typing stuff
var textbox_pause = 0.02 #0.16;
var textbox_talk_cooldown = 0.04 #0.16;
var textbox_blink_cooldown = 0.04 #0.16;

var comma_pause := 0.4 #0.8
var period_pause := 1.1 #2.2
var dash_pause := 0.4 #0.8
var question_pause := 0.7 #2.2 ## Added by me, not on the original.
var exclamation_pause := 0.7 #2.2 ## Added by me, not on the original.

var normal_typing := 1.0
var fast_typing := 0.01
var curr_typing_speed := normal_typing

var type_timer := 0.0
var can_type := false
var is_typing := false

func _ready() -> void:
	#if not Engine.is_editor_hint():
	border_node = B2_Border.new()
	add_child( border_node )
		
	border_node.position = Vector2( _draw_x, _draw_y )
	border_node.set_panel_size( textbox_width - _draw_x * 2, 48 + 44 )
	
	set_text("`kw`Operation Valkyrie`rt` states to extract a youngster powerful beyond its years... look at those traps and delts... not to mention those tris and lats... That looks like `kw``w1`power`w0``rt` to me.","bbbbb")
	set_portrait( "s_port_hoopz" )
	display_dialog()
	
func set_textbox_pos( _pos : Vector2, _size := Vector2.ZERO ) -> void:
	border_node.position = _pos
	border_node.set_panel_size( _size.x, _size.y )

func set_text( _text : String, _text_title := "" ) -> void:
	if not _text_title.is_empty():
		title_node 	= RichTextLabel.new(); add_child(title_node); title_node.bbcode_enabled = true
		_title 		= _text_title 	# whos speaking the text
		
	text_node 	= RichTextLabel.new(); add_child(text_node); text_node.bbcode_enabled = true
	_my_text 	= _text 		# text dialog
	
func set_portrait( portrait_name : String ) -> void:
	# Add the frame to the tree
	portrait_frame_node = TextureRect.new(); add_child( portrait_frame_node ) 
	
	portrait_frame_node.texture = S_DIAG_FRAME
	portrait_frame_node.position = Vector2( _draw_x + 15, _draw_y + 8 + 5 )
	
	_load_portrait( portrait_name ) # load the talker´s picture
	portrait_frame_node.add_child( portrait_img_node ) # add the actual portrait 
	
	#portrait_img_node.play("blink")
	portrait_img_node.play("talk")
	
	has_portrait = true
	
func display_dialog( _is_boxless := false ):
	var text_offset := 0
	if has_portrait: 
		text_offset = 40
	
	if not title_node == null:
		title_node.name 		= "Title_text"
		title_node.position 	= Vector2( _draw_x + 27 + text_offset, _draw_y + 12 + 5 )
		title_node.size 		= Vector2( 290, 12 )

		title_node.push_color( _title_color )
		title_node.append_text( Text.pr( _title ) )
		title_node.pop_all()
	
	text_node.name 				= "Text"
	text_node.position 			= Vector2( _draw_x + 27 + text_offset, _draw_y + 12 + 5 + 16)
	text_node.size 				= Vector2( 290, 12 * 4)

	text_node.push_color( _text_color )
	text_node.append_text( Text.pr( _my_text ) )
	text_node.pop_all()
	
	can_type = true
	text_node.visible_characters = 0
	type_timer = textbox_pause * curr_typing_speed
	
	await finished_typing
	return

func _load_portrait( portrait_name : String ):
	var file_name : String = B2_Gamedata.portrait_map.get( portrait_name, "" )
	
	assert( not file_name.is_empty(), "File could not be found." )
	assert( file_name.find("_strip") >= 0, "weird file.")
	print( "n_frames: ", int( file_name[-5] ), " ", file_name[-5] )
	var n_frames := int( file_name[-5] ) # should return the "6" in s_port_variable_strip6.png
	
	# Setup node
	portrait_img_node = AnimatedSprite2D.new()
	portrait_img_node.centered = false
	portrait_img_node.offset = Vector2(8, 10) # trial and error
	
	var anim_frames := SpriteFrames.new()
	anim_frames.add_animation( "blink" )
	anim_frames.add_animation( "talk" )
	
	var spritesheet : Texture2D = ResourceLoader.load( B2_Gamedata.PORTRAIT_PATH + file_name )
	
	var offset := int( spritesheet.get_width() / n_frames )
	
	for f in n_frames:
		var frame_tex := AtlasTexture.new( )
		frame_tex.atlas = spritesheet
		var frame_offset = offset * f
		frame_tex.region = Rect2( Vector2(frame_offset, 0), Vector2(offset, spritesheet.get_height() ) )
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

func _type_next_letter(delta):
	if type_timer > 0.0: # Waste time until the timer is below 0.0
		type_timer -= delta
	else:
		var add_wait := 0.0
		var curr_char : String = _my_text [ text_node.visible_characters ]

		match curr_char: # add a pause for certain characters
			" ":
				add_wait = 0.0
				#wizard_cc.wizard_is_silent() # a small pause, the wizard stop talking.
			",":
				add_wait = comma_pause
				#wizard_cc.wizard_is_silent()
			".":
				add_wait = period_pause
				#wizard_cc.wizard_is_silent()
			"-":
				add_wait = dash_pause
				#wizard_cc.wizard_is_silent()
			"!":
				add_wait = exclamation_pause
				#wizard_cc.wizard_is_silent()
			"?":
				add_wait = question_pause
				#wizard_cc.wizard_is_silent()
			_:
				# Avoid playing sounds when players skips
				#wizard_cc.wizard_is_talking()
				
				if curr_typing_speed == normal_typing:
					B2_Sound.play( _talk_sound, 0.0, false, 1, 2.0 )
				
		#wizard_cc.wizard_is_talking()
		type_timer = (textbox_pause + add_wait) * curr_typing_speed
		
		if not text_node.visible_ratio == 1.0: # avoid issues with the text skipping
			text_node.visible_characters += 1

func _process(delta):
	if Input.is_action_just_pressed("Action"):
		curr_typing_speed = fast_typing
		if text_node.visible_ratio == 1.0:
			input_pressed.emit()
		else:
			text_node.visible_ratio = 1.0
			B2_Sound.play( _talk_sound, 0.0, false, 1, 2.0 )
			
	if can_type:
		_type_next_letter(delta)
		
		if text_node.visible_ratio == 1.0:
			can_type = false
			# wizard_cc.wizard_is_silent()
			
			await input_pressed # we dont wait for inputs on questions
			finished_typing.emit()
