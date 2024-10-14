@tool
extends CanvasLayer
class_name B2_DialogueChoice

# Dialog box variant for CHOICE command
# Notable changes:
#	Text is instant
#	Portrait image doesnt need the talking animation, only blinking
#	No "text"
#	

# DEBUG
@export var debug := false

## Auto Skip
var auto_skipping := false # Should be false from the start. enabled only when the player holds the action key.

const S_DIAG_FRAME 		= preload("res://barkley2/assets/b2_original/images/merged/s_diag_frame.png")
const S_RETURN 			= preload("res://barkley2/assets/b2_original/images/merged/s_return.png")
# reference script = o_dialogue

# The title of the text, defaults to an empty string.
var _title = "";

## Important
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


var flourishFrame = 0; 				## WARNING Set this up when the time comes.

## NOTE seems interesting
var style = 1; # 0 is old style, 1 is generated

## GODOT specific
signal input_pressed
signal choice_selected( choice_id )

var return_sprite : Sprite2D

var textbox_width := 384
var textbox_height := 240
var text_offset = textbox_width - 64;

var border_node 			: B2_Border
var portrait_frame_node 	: TextureRect
var portrait_img_node 		: AnimatedSprite2D

var title_node 				: RichTextLabel
var choice_node 			: ScrollContainer
var choice_vbox_node		: VBoxContainer
var choice_group			: ButtonGroup

var selection_arrow			: Sprite2D

var has_portrait := false

## Typing stuff
var textbox_pause 			:= 0.005 	#0.05; # Set tyhe typing speed.
var textbox_talk_cooldown 	:= 0.04 	#0.04;
var textbox_blink_cooldown 	:= 0.04 	#0.04;

var is_waiting_input := false

## Textbox Screens (More than 4 lines of texts)
var max_screens 	:= 1
var curr_screen 	:= 1
const max_lines		:= 4

## Portrait stuff
var blink_cooldown 	:= 0.0
var blink_speed 	:= 5.50
var is_talking		:= false

func _ready() -> void:
	layer = B2_Config.DIALOG_LAYER
	
	# Setup the dinamic frame
	border_node = B2_Border.new()
	border_node.set_seed( get_tree().root.get_child(0).name )
	
	add_child( border_node )
	border_node.name = "Dialog_Frame"
	border_node.position = Vector2( _draw_x, _draw_y )
	border_node.set_panel_size( textbox_width - _draw_x * 2, 48 + 44 )
	
	fastforward_control( B2_Input.is_fastforwarding )
	B2_Input.fastforward_request.connect( fastforward_control )
	
	choice_group 		= ButtonGroup.new()
	choice_node 		= ScrollContainer.new()
	choice_vbox_node 	= VBoxContainer.new()
	choice_node.add_child( choice_vbox_node )
	choice_vbox_node.set_anchors_preset( Control.PRESET_FULL_RECT)
	
	# Arrow
	selection_arrow = preload("res://barkley2/resources/B2_Dialogue/dialog_choice_arrow.tscn").instantiate()
	add_child( selection_arrow )
	
	
func fastforward_control( active : bool ):
	auto_skipping = active
	
func set_textbox_pos( _pos : Vector2, _size := Vector2.ZERO ) -> void:
	border_node.position = _pos
	border_node.set_panel_size( _size.x, _size.y )

## Add Choice, add button and connect signal.
func add_choice( choice_text : String ) -> void:
	var my_choice_id : int 				= choice_vbox_node.get_child_count()
	var my_selection_button 			:= Button.new()
	my_selection_button.alignment = HORIZONTAL_ALIGNMENT_LEFT
	my_selection_button.custom_minimum_size = Vector2( 300, 11 )
	
	my_selection_button.text = Text.pr(choice_text)
	
	choice_vbox_node.add_child( my_selection_button, true )
	print(my_choice_id)
	if my_choice_id == 0:
		my_selection_button.call_deferred( "grab_focus" ) 
		change_arrow_pos.call_deferred( my_selection_button )
	
	my_selection_button.mouse_entered.connect( my_selection_button.grab_focus)
	my_selection_button.focus_entered.connect( change_arrow_pos.bind(my_selection_button) )
	my_selection_button.pressed.connect( func(): choice_selected.emit( my_choice_id ); queue_free() )

func change_arrow_pos( button : Button ):
	# Need to wait this long because more than 4 items cause the scrollbox to scroll, wich takes some time.
	# Not sure what I mean? comment one of these awaits and see for yourself.
	await get_tree().process_frame
	await get_tree().process_frame
	selection_arrow.set_global_position( button.global_position + Vector2( -13, 1 ) )

func display_choices():
	var _text_offset := 0
	
	if has_portrait: 
		_text_offset = 40 + 15 # 15 is for the arrow
		
	add_child( choice_node, true )
	choice_node.follow_focus 					= true
	choice_node.scroll_vertical_custom_step 	= 24
	choice_node.horizontal_scroll_mode 			= ScrollContainer.SCROLL_MODE_DISABLED
	choice_node.theme 							= preload("res://barkley2/themes/dialogue_choice.tres")
	choice_node.position 						= Vector2( _draw_x + 30 + _text_offset, _draw_y + 12 + 5 + 16)
	choice_node.size 							= Vector2( 250, 11 * 4)
	
# Title in this case is the question.
func set_title( _text_title : String ) -> void:
	title_node 	= RichTextLabel.new(); add_child(title_node, true); title_node.bbcode_enabled = true
	title_node.theme = preload("res://barkley2/themes/dialogue.tres")
	_title 		= _text_title 	# whos speaking the text
	
	var _text_offset := 0
	if has_portrait: 
		_text_offset = 40
	
	title_node.name 		= "Title_text"
	title_node.position 	= Vector2( _draw_x + 30 + _text_offset, _draw_y + 12 + 5 )
	title_node.size 		= Vector2( 250, 12 )

	title_node.push_color( _title_color )
	title_node.append_text( Text.pr( _title ) )
	title_node.pop_all()
	
func set_portrait( portrait_name : String, from_name := true ) -> void:
	# Add the frame to the tree
	portrait_frame_node = TextureRect.new(); add_child( portrait_frame_node, true ) 
	
	portrait_frame_node.texture = S_DIAG_FRAME
	portrait_frame_node.position = Vector2( _draw_x + 15, _draw_y + 8 + 5 )
	
	if from_name:
		_load_portrait( B2_Gamedata.portrait_from_name.get(portrait_name, "s_portrait") ) # load the talker´s picture from its name. If the name is invalid, load a temp picture
	else:
		_load_portrait( portrait_name ) # load the talker´s picture
	portrait_frame_node.add_child( portrait_img_node ) # add the actual portrait 
	
	has_portrait = true

## Manually add the character portraits and setup the AnimatedSprite2D
func _load_portrait( portrait_name : String ):
	var file_name : String = B2_Gamedata.portrait_map.get( portrait_name, "" )
	
	assert( not file_name.is_empty(), "File could not be found." )
	assert( file_name.find("_strip") >= 0, "Weird file. Unexpected.")
	if debug: print( "n_frames: ", int( file_name[-5] ), " ", file_name[-5] )
	var n_frames := int( file_name[-5] ) # should return the "6" in s_port_variable_strip6.png. "-5" ignores the ".png" part of the files.
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
	
	var spritesheet : Texture2D = ResourceLoader.load( B2_Gamedata.PORTRAIT_PATH + file_name )
	
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

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
		
	# Handle portrait animation and blinking
	if has_portrait:
		if not is_talking:
			blink_cooldown 	-= delta
			
			if blink_cooldown < 0.0:
				portrait_img_node.animation = "blink"
				
				if portrait_img_node.frame == 1:
					blink_cooldown = blink_speed
					portrait_img_node.frame = 0
				else:
					blink_cooldown = blink_speed / 16.0
					portrait_img_node.frame = 1
