@tool
extends CanvasLayer

## NOTE What a nightmare this was!!
## NOTE Missing fonts are set as null right now.

var verbose_prints := true

@onready var color_rect: ColorRect = $ColorRect

@onready var no_notes_lbl: Label = $ColorRect/no_notes_lbl
@onready var note_name: Label = $ColorRect/B2_Border/note_name
@onready var note_itself: TextureRect = $ColorRect/note_itself
@onready var fade_effect: ColorRect = $ColorRect/fade_effect
@onready var prev_note: TextureButton = $ColorRect/prev_note
@onready var next_note: TextureButton = $ColorRect/next_note
@onready var exit_button: TextureButton = $ColorRect/exit_button
@onready var exit_spr: AnimatedSprite2D = $ColorRect/exit_button/exit_spr
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var animation_player: AnimationPlayer = $AnimationPlayer

const text_size := 9216.0
const map_size := 384.0
const map_speed := 0.15
var tween : Tween

var avaiable_notes := []

var note_fonts := [ ## Incomplete list. I am too lazy.
	load("res://barkley2/resources/fonts/fn1.tres"),
	load("res://barkley2/resources/fonts/fn1o.tres"),
	load("res://barkley2/resources/fonts/fn2.tres"),
	
	load("res://barkley2/resources/fonts/fn_small.tres"), # 3
	load("res://barkley2/resources/fonts/fn2c.tres"),
	load("res://barkley2/resources/fonts/fn2o.tres"),
	load("res://barkley2/resources/fonts/fn2f.tres"), # 6
	
	load("res://barkley2/resources/fonts/fn5o.tres"),
	null, # fn_7oc
	null, # fn_12o
	null, # fn_5os
	null, # fn_7ocs
	null, # fn_12ocs
	null, # fn_tactics
	null, # fn_tactics_bold
]

var selected_note := 0 :
	set(i):
		selected_note = wrapi( i, 0, avaiable_notes.size() )

func _ready() -> void:
	layer = B2_Config.NOTE_LAYER
	
	no_notes_lbl.text 		= Text.pr("No notes available.")
	exit_spr.frame 			= 0
	fade_effect.modulate.a 	= 0.0
	color_rect.modulate.a 	= 0.0
	
	avaiable_notes = B2_Note.get_all()
	
	# No maps avaiable, show nothing.
	if avaiable_notes.is_empty():
		prev_note.queue_free()
		next_note.queue_free()
		note_itself.queue_free()
		note_name.text = Text.pr( "No notes... :(")
		
	# only one note avaiable, remove arrow keys.
	elif avaiable_notes.size() == 1:
		prev_note.queue_free()
		next_note.queue_free()
		no_notes_lbl.hide()
		change_note()
		
	else:
		no_notes_lbl.hide()
		change_note()
		#avaiable_maps.sort()
		
	animation_player.play("show_myself")
	audio_stream_player.play()
	
func change_note() -> void: ## CRITICAL Need to change this to support the mental way B2 handles Notes.
	# get note name from the directory
	#note_name.text = Text.pr( B2_Note.notes[ avaiable_notes[selected_note] ] )
	note_name.text = Text.pr( avaiable_notes[selected_note] )
	note_itself.texture.region.position.x = B2_Note.notes[ avaiable_notes[selected_note] ]["note_id"] * map_size
	note_itself.texture.region.position.x = wrapf(note_itself.texture.region.position.x, 0, text_size)
	# ^^^^ Lol, wtf?
	
	#purge old data
	for c in note_itself.get_children():
		if is_instance_valid(c):
			c.queue_free()
	
	# Change note text.
	# TITLE # "Wilmer's Amortization Schedule", 
	# SFX # "sn_mnu_noteFlipLight01", 
	# DATA # "BAK|s_tnn_papers|15~STR|By Holy Supreme\nand Regnant Decree\nof Lord Emperor\nCuchulainn|-23|-84|3|3355344|1~STR|It is hereby known to\nDwarfkin and Duergar alike\n\nThat        \n\nof         ,\nis duly charged with\nremittance to The\nResplendent Coffers of\nPresident Cuchulainn,\nthe value of\n\n      Cuchu-Bucks\nor current equivalent\nneuroshekels.\n\nDue upon the reading\nof this decree.|-69|-48|3|0|1~STR|Mr. Wilmer|-41|-27|3|509|1~STR|Tir na nOg|-54|-13|3|254|1~STR|180,348|-68|36|3|509|1");
	if B2_Note.notes.has( avaiable_notes[selected_note] ):
		parse_data( B2_Note.notes.get( avaiable_notes[selected_note] )["note_data"] )
	else:
		push_error("Invalid DATA for note %s." % avaiable_notes[selected_note])

func parse_data( data : String ) -> void:
	# Holy shit, how did they come up with this stuff?
	# Check Note() line 437
	if data != "":
		var split_data := data.split( "~", true )
		var header_data := split_data[0].split("|") 
		# WARNING ^^^^^this contains information about the texture and BG. Will go unused on this port.
		# Example: BAK|s_tnn_papers|15 - What is BAK? no idea. It goes unused in the code, i think.
		for i : int in range( split_data.size() ):
			if i == 0: # skip the header.
				continue
				
			var text_data := split_data[i].split("|") 
			# 0 = STR| 1 = Text| 2 = x| 3 = y| 4 = font| 5 = col| 6 = alp
			# NOTE ^^^ What is STR?
			var label := Label.new()
			label.label_settings = LabelSettings.new()
			label.label_settings.line_spacing = 0
			label.label_settings.font = note_fonts[ int( text_data[4] ) ]
			if verbose_prints: 
				print(name + ": loaded font %s - %s." % [ int( text_data[4] ), label.label_settings.font.resource_name ] )
			label.text = Text.pr( text_data[1] )
			label.modulate = just_convert_gamemaker_color_to_hex_already( int( text_data[5] ) )
			label.modulate.a = float( text_data[6] )
			# NOTE Bitch, this wasnt supposed to be hard. GameMaker uses a stupid int based color ( draw_set_color(real(arrSub[5])) ). Its not hex. How can I convert it to something I can understand?
			# check https://marketplace.gamemaker.io/assets/2074/number-conversion-and-other
			note_itself.add_child(label)
			label.set_deferred( 
				"position", 
				Vector2( 
					float( text_data[2] ), 
					float( text_data[3] ) 
					) + get_viewport().get_visible_rect().size / 2
				)
	else:
		push_warning("NOTE: No data to parse. Is this normal?")
	pass

func just_convert_gamemaker_color_to_hex_already( stupid_color : int ) -> Color:
	# check https://marketplace.gamemaker.io/assets/2074/number-conversion-and-other
	## Shit, I just got it!!! Gamemaker uses a weird decimal sistem to set color!!!
	# check https://manual.gamemaker.io/lts/en/GameMaker_Language/GML_Reference/Drawing/Colour_And_Alpha/Colour_And_Alpha.htm#
	# c_lime 	  	65280 -> 0x00FF00 ( 00 B - FF G - 00 R )
	var my_col := Color.WHITE
	
	var stupid_hex_color := String.num_int64( stupid_color, 16, true).lpad(6,"0")
	var r := stupid_hex_color.substr(4, 1)
	var g := stupid_hex_color.substr(2, 1)
	var b := stupid_hex_color.substr(0, 1)
	
	if str(r + g + b).is_valid_hex_number():
		my_col = Color( r + g + b )
	else:
		push_warning("Invalid color :" + r + g + b)
	return my_col

func play_sfx() -> void:
	var sfx : String
	
	if B2_Note.notes.has( avaiable_notes[selected_note] ):
		sfx = B2_Note.notes.get( avaiable_notes[selected_note] )["note_sfx"]
	else:
		push_error("Invalid SFX for note %s." % avaiable_notes[selected_note])
		sfx = "sn_debug_one"
		
	B2_Sound.play(sfx)

func _on_exit_button_mouse_entered() -> void:
	if is_instance_valid(tween):
		tween.kill()
	tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(exit_spr, "frame", 7, 0.15 )
	tween.tween_property(fade_effect, "modulate:a", 0.75, 0.15 )

func _on_exit_button_mouse_exited() -> void:
	if is_instance_valid(tween):
		tween.kill()
	tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(exit_spr, "frame", 0, 0.15 )
	tween.tween_property(fade_effect, "modulate:a", 0.0, 0.15 )

func _on_prev_map_pressed() -> void:
	var cur_p := note_itself.texture.region.position.x as float
	var tar_p := cur_p - map_size as float
	tar_p = wrap(tar_p, 0, text_size)
	play_sfx()
	
	selected_note -= 1
	
	var t := create_tween()
	t.tween_callback( prev_note.set_disabled.bind(true) )
	t.tween_callback( next_note.set_disabled.bind(true) )
	
	#t.tween_property( note_itself, "texture:region:position:x", tar_p, map_speed )
	t.tween_property( note_itself, "position:x", 384 + 2, map_speed )
	t.tween_callback( note_itself.set_position.bind( Vector2( -384, 0 ) ) )
	t.tween_callback( change_note )
	t.tween_property( note_itself, "position:x", 0, map_speed )
	
	t.tween_callback( prev_note.set_disabled.bind(false) )
	t.tween_callback( next_note.set_disabled.bind(false) )

func _on_next_map_pressed() -> void:
	var cur_p := note_itself.texture.region.position.x as float
	var tar_p := cur_p + map_size as float
	tar_p = wrap(tar_p, 0, text_size)
	play_sfx()
	
	selected_note += 1
	
	var t := create_tween()
	t.tween_callback( prev_note.set_disabled.bind(true) )
	t.tween_callback( next_note.set_disabled.bind(true) )
	
	#t.tween_property( note_itself, "texture:region:position:x", tar_p, map_speed )
	t.tween_property( note_itself, "position:x", -384, map_speed )
	t.tween_callback( note_itself.set_position.bind( Vector2( 384 * 2, 0 ) ) )
	t.tween_callback( change_note )
	t.tween_property( note_itself, "position:x", 0, map_speed )
	
	t.tween_callback( prev_note.set_disabled.bind(false) )
	t.tween_callback( next_note.set_disabled.bind(false) )

func _on_exit_button_pressed() -> void:
	B2_Screen.hide_note_screen() # gracefully close the screen
	
func hide_menu():
	animation_player.play("hide_myself")
	audio_stream_player.play()
	return await animation_player.animation_finished
