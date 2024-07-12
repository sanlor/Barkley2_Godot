@tool
extends Control



signal name_entered

@onready var cc_name_box = $cc_name_box
@onready var cc_name_prompt = $cc_name_prompt
@onready var prompt_cursor = $cc_name_prompt/prompt_cursor

@onready var gen_btn = $gen_btn
@onready var premade_btn = $premade_btn
@onready var clear_btn = $clear_btn
@onready var accept_btn = $accept_btn

@onready var lowecase_btn = $lowecase_btn
@onready var uppercase_btn = $uppercase_btn

var generated_piece_one := 		["Bok","Aa","Tro","Leep","Erp","Ool","Pos","Qax","Xor","Eee","Tek","A","Eo"]
var generated_piece_two := 		["app","aza","o","iop","iino","xoxa","pel","stu","rea","ope","x","a","wert"]
var generated_piece_three := 	["tep","ax","rol","aa","bac","x","nera","aaop","asax","e","etra","et","oo"]
var name_premade := 			["Brayden","Kayden","Ayden","Hayden","Jayden","Braylen","Brycen","Trayden","Rayden","Mayden","Qayden","Gayden","Xayden","Nayden","Payden"]

var letters := "ABCDEFGHIJKLMNOPQRSTUVWXYZ-_1234567890:;$ "
var prompt_space := []
var prompt_position := 0

var prompt_letters := []

var display_letters_in_uppercase := false

func _ready():
	modulate.a = 0
	var tween := create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 1.0)
	
	cc_name_box.global_position = Vector2( 192, 99 ) - (cc_name_box.size / 2)
	cc_name_prompt.global_position = Vector2(101, 48 - 10)
	#for (i=0; i<14; i+=1;)
	#{
	#draw_text(97 + i * 14, 39, name_letter[i])
	#}
	
	for r in 3:
		for i in 14:
			var offset := 14
			var row_height := 20 * r
			
			if r == 0: ## Only apply for the first row.
				var letter_lbl := Label.new()
				cc_name_prompt.add_child( letter_lbl )
				letter_lbl.position.x += i * offset
				letter_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
				letter_lbl.text = ""
				prompt_space.append( letter_lbl )
			
			var letter_btn := Button.new()
			cc_name_box.add_child( letter_btn )
			letter_btn.text = letters[ i + (offset * r)]
			letter_btn.size = Vector2( 14, 22 )
			letter_btn.global_position = Vector2( 97 + i * offset, 70 + row_height)
			letter_btn.pressed.connect( add_letter_to_prompt.bind( letter_btn.text ) )
			prompt_letters.append( letter_btn )
			#label1.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			
	gen_btn.global_position = Vector2(156, 192) 		- (gen_btn.size / 2)
	premade_btn.global_position = Vector2(156, 220) 	- (premade_btn.size / 2)
	
	clear_btn.global_position = Vector2(236, 192) 		- (clear_btn.size / 2)
	accept_btn.global_position = Vector2(236, 220) 		- (accept_btn.size / 2)
	
	clear_btn.pressed.connect( clear_prompt )
	premade_btn.pressed.connect( get_premade_name )
	gen_btn.pressed.connect( gen_name )
	accept_btn.pressed.connect( accept_name )
	
	lowecase_btn.pressed.connect( set_lowercase )
	uppercase_btn.pressed.connect( set_uppercase )
	
	#set_lowercase(false)
	set_uppercase(false)
	
func type_name_to_prompt( _name : String ):
	for letter in _name:
		add_letter_to_prompt(letter, false)
	
func add_letter_to_prompt(letter : String,  play_sound := true ):
	if display_letters_in_uppercase:
		prompt_space[ prompt_position ].text = letter.to_upper()
	else:
		prompt_space[ prompt_position ].text = letter.to_lower()
	
	if prompt_position + 1 <  prompt_space.size():
		prompt_position += 1
		prompt_cursor.position.x = (prompt_position * 14) - 38
		set_lowercase(false)
	if play_sound:
		B2_Sound.play( "sn_cc_name_click1" )

func clear_prompt():
	for letter : Label in prompt_space:
		letter.text = ""
	prompt_position = 0
	prompt_cursor.position.x = (prompt_position * 14) - 38
	set_uppercase(false)
	B2_Sound.play( "sn_cc_name_clear" )
	
func gen_name():
	clear_prompt()
	## Generate Name from pieces
	var gen_n : String = str (generated_piece_one.pick_random() + generated_piece_two.pick_random() + generated_piece_three.pick_random() )
	type_name_to_prompt( gen_n.capitalize() )
	B2_Sound.play( "sn_cc_name_generate" )

func get_premade_name():
	clear_prompt()
	## Compile name from the premade list name
	var prem_n : String = name_premade.pick_random()
	type_name_to_prompt( prem_n.capitalize() )
	B2_Sound.play( "sn_cc_name_premade" )
	
func set_lowercase( play_sound := true ):
	display_letters_in_uppercase = false
	for _letters : Button in prompt_letters:
		_letters.text = _letters.text.to_lower()
		
	if play_sound:
		B2_Sound.play( "sn_cc_name_lowercase" )
	
func set_uppercase( play_sound := true ):
	display_letters_in_uppercase = true
	for _letters : Button in prompt_letters:
		_letters.text = _letters.text.to_upper()
		
	if play_sound:
		B2_Sound.play( "sn_cc_name_uppercase" )
	
func accept_name():
	## Name compilation
	var player_name := ""
	for letter : Label in prompt_space:
		player_name += letter.text
	if player_name.is_empty():
		#clear_prompt()
		B2_Sound.play("sn_cc_wizard_talk03")
		return
		
	## Check for blanks ##
	if player_name.count(" ") >= 14:
		## All blanks? Try again buddy ##
		clear_prompt()
		B2_Sound.play("sn_cc_wizard_talk03")
		return
		
	## Remove blanks at ends ##
	player_name = player_name.rstrip(" ")
	
	B2_Playerdata.character_name_type = 0;
	B2_Playerdata.character_name = player_name
	
	B2_Sound.play("sn_cc_button_accept")
	namebox_hide()

func namebox_show():
	pass
	
func namebox_hide():
	var tween := create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 1.0)
	await tween.finished
	name_entered.emit()
	queue_free()
