extends CanvasLayer

const CONFIRMATION_BOX = preload("uid://dkqmhxi70d2o7")

const ART_DATA : Dictionary[String, Array]= {
##	NAME				ID		DESCRIPTION
	"Goofster": 		[00, 	"Goofsters are tall and slender creatures most well known for their supernatural hardy constitution. ##While Goofsters are considered to be benevolent, social creatures, they are rarely, if ever, seen among their kin. Instead they prefer the company of sentient mallards and rats. ##Goofsters live and thrive in ancient subterranean ruins but are highly susceptible to microwave tunnels."],
	"Slender Man":		[01, 	"Slender Men are the cursed offspring of a forgotten Mesopotamian King. They are born without a face and as such are forever plagued by an unsatiable hunger. ##The dark magicks that run in their veins makes them immortal, which rather than being a divine blessing only serves to prolong their suffering. These conditions make the Slender Men weak and malnourished, hence their name."],
	"Drakescorned": 	[02, 	"The Drakescorned are a noble subgenus of orc who shun the use of all nunchucks. ##Versed in asceticism, the Drakescorned live in secluded mountain monasteries where they train their minds and bodies to deflect bows and arrows. ##As their name implies, they recieve a -2 penalty to all drake-based skill checks but more than make up for it with high level juggling. ##The Drakescorned are known for their elaborate wicker baskets."],
	"Sergal": 			[03, 	"Sergals are the mystical offspring of highborne elves and werewolves. They are worshipped in many cultures almost exclusively as benevolent deities protecting the realm. ##All Sergals have a pathological fear of ghosts, and they try to avoid ancient ruins and graveyards any way they can."],
	"Geldrach": 		[04, 	"Geldrachs are a very common barnyard animal found on many traditional farms. They are a genetically engineered species that are bred for the sole purpose of being cattle, and on some more rare occasions, for their milk. ##They are easily identifiable by their mixture of black and brown fur."],
	"Dire Juggler": 	[05, 	"Dire Juggler are distant cousins of more well known species, Jugglers. Isolated and imprisoned onto a distant island during the events of The Second Cudgel War the Firstborne Jugglers slowly changed to a more dire existence. ##To this day not much else is known about the Dire Jugglers, but their recent resurgence aligns with the prophecy of the end times."],
	"Hellmonster": 		[06, 	"Hellmonster are considered to be one of the most formidable demons of Hell, and their high position in the demon hierarchy supports this viewpoint. They use devastating Hell Magicks to battle their foes and have the ability to conjure Illiorchs Infernal Worms without spending any magicpoints. ##Hellmonsters are archenemies with Sporelips and Elder Stardusters."],
	"Mujahoudini": 		[07, 	"The Mujahoudini are desert dwelling mystics who live solely to entertain people with their crazy stunts and daring feats. ##Not much is known about their day to day existence, but many rumours suggest that the Mujahoudini do not eat, drink or sleep, but rather spend every waking moment honing their art and protecting their oil."],
}

## NOTE What a nightmare this was!!
## NOTE Missing fonts are set as null right now.
# NOTE Need to act the "select" command. check https://youtu.be/kMybONQr0wA?t=15952
var verbose_prints := false

## When giving a note to someone, inform what note you selected.
#signal note_selected( selected_note_name : String )
# Dumbass, there is an signal for this already: B2_Screen.note_selected

@onready var color_rect: ColorRect = $ColorRect

@onready var no_notes_lbl: 			Label = $ColorRect/no_notes_lbl
@onready var note_name: 			Label = $ColorRect/B2_Border/note_name
@onready var note_itself: 			TextureRect = $ColorRect/note_itself
@onready var fade_effect: 			ColorRect = $ColorRect/fade_effect
@onready var prev_note: 			TextureButton = $ColorRect/prev_note
@onready var next_note: 			TextureButton = $ColorRect/next_note
@onready var exit_button: 			TextureButton = $ColorRect/exit_button
@onready var give_button: 			B2_Border_Button = $ColorRect/give_button
@onready var exit_spr: 				AnimatedSprite2D = $ColorRect/exit_button/exit_spr
@onready var audio_stream_player: 	AudioStreamPlayer = $AudioStreamPlayer
@onready var animation_player: 		AnimationPlayer = $AnimationPlayer

@onready var confirm_bg: 			ColorRect = $confirm_bg
@onready var give_lbl: 				Label = $confirm_bg/dialog/VBoxContainer/give_lbl
@onready var yes_btn: 				Button = $confirm_bg/dialog/VBoxContainer/HBoxContainer/yes_btn
@onready var no_btn: 				Button = $confirm_bg/dialog/VBoxContainer/HBoxContainer/no_btn

@onready var gallery: 				Control = $ColorRect/gallery
@onready var s_gallery: TextureRect = $ColorRect/gallery/sGallery
@onready var s_gallery_text: Label = $ColorRect/gallery/sGallery_text


const text_size := 9216.0
const map_size := 384.0
const map_speed := 0.15
var tween : Tween

var avaiable_notes := []
var mode := 0 # 0 = Viewer, 1 = Select

var note_fonts := [ ## Incomplete list. I am too lazy.
	load("res://barkley2/resources/fonts/fn1.tres"), 			# 0
	load("res://barkley2/resources/fonts/fn1o.tres"), 			# 1
	load("res://barkley2/resources/fonts/fn2.tres"), 			# 2
	
	load("res://barkley2/resources/fonts/fn_small.tres"), 		# 3
	load("res://barkley2/resources/fonts/fn2c.tres"),			# 4
	load("res://barkley2/resources/fonts/fn2o.tres"),			# 5
	load("res://barkley2/resources/fonts/fn2f.tres"), 			# 6
	
	load("res://barkley2/resources/fonts/fn5o.tres"),					# 7
	load("res://barkley2/resources/fonts/fn_7oc.tres"), # fn_7oc		# 8
	load("res://barkley2/resources/fonts/fn_12ocs.tres"), # fn_12o 		# 9
	load("res://barkley2/resources/fonts/s_fn5os.tres"), # fn_5os		# 10
	load("res://barkley2/resources/fonts/fn_7ocs.tres"), # fn_7ocs		# 11
	load("res://barkley2/resources/fonts/fn_12ocs.tres"), # fn_12ocs	# 12
	load("res://barkley2/resources/fonts/fn_tactics.tres"), # fn_tactics			# 13
	load("res://barkley2/resources/fonts/fn_tactics_bold.tres"), # fn_tactics_bold	#14
]

var selected_note := 0 :
	set(i):
		selected_note = wrapi( i, 0, avaiable_notes.size() )

var time			:= 0.0

func _ready() -> void:
	layer = B2_Config.NOTE_LAYER
	B2_Input.ffwd( false )
	
	no_notes_lbl.text 		= Text.pr("No notes available.")
	exit_spr.frame 			= 0
	fade_effect.modulate.a 	= 0.0
	color_rect.modulate.a 	= 0.0
	
	avaiable_notes = B2_Note.get_all()
	
	## TODO 23/12/25 add gamepad controls 
	if mode == 0:		## Viewer
		give_button.queue_free()
		gallery.queue_free()
	
	elif mode == 1:		## Select
		## Disable button if there are no notes.
		give_button.disabled = avaiable_notes.is_empty()			## Show "no notes" screen and disable the "give" button.
		gallery.queue_free()
	
	elif mode == 2:		## Gallery
		## Also, check o_mg_artgallery. seems to be unused.
		color_rect.color.a = 0.85
		prev_note.queue_free()
		next_note.queue_free()
		give_button.queue_free()
		note_itself.queue_free()
		gallery.show()
	else:
		## weird mode
		breakpoint
	
	# Button setup
	yes_btn.text 	= Text.pr(yes_btn.text)
	no_btn.text 	= Text.pr(no_btn.text)
	confirm_bg.hide()
	
	# No notes avaiable, show nothing.
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
	# Has some notes.
	else:
		no_notes_lbl.hide()
		change_note()
		#avaiable_maps.sort()
		
	if mode == 2:
		animation_player.play("show_myself_gallery")
	else:
		animation_player.play("show_myself")
		audio_stream_player.play()
		
	# Adjust gamepad navigation:
	if give_button:
		exit_button.focus_neighbor_right = give_button.get_path()
	else:
		if next_note:
			exit_button.focus_neighbor_right = next_note.get_path()
		
	exit_button.grab_focus()
	
func _input(event: InputEvent) -> void:
	if visible:
		if event is InputEventJoypadButton or event is InputEventMouseButton:
			# Improves the gamepad menu navigation
			if Input.is_action_just_pressed("Holster"):
				get_viewport().set_input_as_handled()
				_on_exit_button_pressed()
		
		if event is InputEventJoypadButton:
			# Change notes / maps using the gamepad without focus.
			if Input.is_action_just_pressed("Roll"): # LB
				if prev_note:
					get_viewport().set_input_as_handled()
					_on_prev_map_pressed()
					
			if Input.is_action_just_pressed("Action"): # RB
				if next_note:
					get_viewport().set_input_as_handled()
					_on_next_map_pressed()
				
	
func change_note() -> void: ## CRITICAL Need to change this to support the mental way B2 handles Notes.
	if mode == 2: ## Gallery mode.
		## Set gallery
		var art : Array = ART_DATA.get(B2_Note.gallery_name)
		s_gallery.texture.region.position.x = 132 * art[0]
		note_name.text = Text.pr( B2_Note.gallery_name )
		s_gallery_text.text = Text.pr( art[1] )
		return
	# get note name from the directory
	note_name.text = Text.pr( avaiable_notes[selected_note] )
	if note_itself:
		note_itself.texture.region.position.x = B2_Note.get_note_from_db( avaiable_notes[selected_note] )["note_id"] * map_size
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
	if B2_Note.has_note_in_db( avaiable_notes[selected_note] ):
		parse_data( B2_Note.get_note_from_db( avaiable_notes[selected_note] )["note_data"] )
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
			label.modulate = B2_Gamedata.just_convert_gamemaker_color_to_hex_already( int( text_data[5] ) )
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

func play_sfx() -> void:
	var sfx : String
	
	if B2_Note.has_note_in_db( avaiable_notes[selected_note] ):
		sfx = B2_Note.get_note_from_db( avaiable_notes[selected_note] )["note_sfx"]
	else:
		push_error("Invalid SFX for note %s." % avaiable_notes[selected_note])
		sfx = "sn_debug_one"
		
	B2_Sound.play(sfx)

func _on_prev_note_focus_exited() -> void:
	prev_note.modulate = Color.WHITE

func _on_next_note_focus_exited() -> void:
	next_note.modulate = Color.WHITE

func _on_exit_button_focus_entered() -> void:
	_on_exit_button_mouse_entered()

func _on_exit_button_focus_exited() -> void:
	_on_exit_button_mouse_exited()

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
	B2_Screen.note_selected.emit( "exit" )
	B2_Screen.hide_note_screen() # gracefully close the screen
	
func hide_menu():
	if mode == 2:
		animation_player.play("hide_myself_gallery")
	else:
		animation_player.play("hide_myself")
		audio_stream_player.play()
	return await animation_player.animation_finished

func _on_give_button_button_pressed() -> void:
	give_lbl.text = Text.pr( "Would you like to give '%s' ?" % str( avaiable_notes[selected_note] ) )
	animation_player.play("confirm_show")
	no_btn.grab_focus()

func _on_yes_btn_pressed() -> void:
	animation_player.play("confirm_hide")
	print_rich("[color=yellow]Selected note '%s'.[/color]" % str( avaiable_notes[selected_note] ) )
	await animation_player.animation_finished
	B2_Screen.note_selected.emit( str( avaiable_notes[selected_note] ) )
	B2_Screen.hide_note_screen()

func _on_no_btn_pressed() -> void:
	animation_player.play("confirm_hide")
	exit_button.grab_focus()
	
func _physics_process(delta: float) -> void:
	time += 5.0 * delta
	
	# Flash button when in focus
	if prev_note:
		if prev_note.has_focus():
			prev_note.modulate = Color.WHITE * ( sin(time) + 2.0 )
			
	# Flash button when in focus
	if next_note:
		if next_note.has_focus():
			next_note.modulate = Color.WHITE * ( sin(time) + 2.0 )
