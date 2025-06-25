extends Control
## Fun chat simulation

@onready var users_online_value: Label = $top_panel/users_online_value
@onready var chat_message: Label = $bottom_panel/HBoxContainer/chat_message
@onready var chat_scroll: VBoxContainer = $chat_scroll
@onready var chat_timer: Timer = $chat_timer

## Procedural messages ##
const WORD_0 := [
	"Hey",
	"lol...",
	"hey",
	"where",
	"what",
	]
const WORD_1 := [
	"Hey",
	"what",
	"snort",
	"bingo",
	"..."
	]
const WORD_2 := [
	"the haps",
	"and snookie",
	"palooza",
	"is",
	"",
	]
const WORD_3 := [
	"!!!",
	".",
	"",
	"NO!",
	"A/S/L",
	]

## Premades ##
const PREMADE := [
	"happy columbus dayy everyne!",
	"Hahahaha!",
	"xaxaxaxaxaxaxaxa",
	"Looking for gemstones, PM if have",
	"c-h-u-p-s for sale dont call cops, PM",
	"Hey gang, hows it goign?",
	"welcome to HECK, lol jk",
	"wheres the smoke? whers fire?",
	"the time for games is now!!",
	"A small boy missing in BrainCit, HELP!",
	"Qwertyqwertyqwerty",
	"mecharider twinturbo volume 6 now on sale",
	"love is a scam dont strust it",
	"hamburger s for all come to papa cafe",
	"KILL ALL DUERGA!!",
	]

## Users ##
const USERNAME := [
	"Galbatrox",
	"HANKO",
	"StegMui",
	"Kunahara",
	"xXxGokuxXx",
	"flip_boi666",
	"sweert1",
	"KamBodzek",
	"Palaryts",
	"c-dwarffo",
	"jesterGal11",
	"GameSpartaN",
	"Dontrell",
	"mizuki666",
	"-_-BAZ-_-",
	"Hemp Hog Jaze",
	"Jade SWAN_X",
	"ThriliDax",
	"22MopLord",
	"x_RUY_x",
	"dragonsfall01",
	]
	
const HOOPZ_MESSAGE := [
	"Hey guys, lol whats up ? ",
	"whats the haps, paps ",
	"lol whats up ",
	"Hey guys! ",
	"Hows it going lol ",
	"lol ",
	"hi guys ",
	"meets and greets gamers ",
	"lol hi ",
	"what up hombres lol ",
	]

func _ready() -> void:
	chat_message.text = HOOPZ_MESSAGE.pick_random()
	chat_message.visible_ratio = 0.0

func _on_chat_timer_timeout() -> void:
	## Gossip
	if randf() > 0.5:
		make_chat_msg( USERNAME.pick_random(), PREMADE.pick_random(), false )
	else:
		var stupid_blablabla : String = WORD_0.pick_random() + " " + WORD_1.pick_random() + " " + WORD_2.pick_random() + " " + WORD_3.pick_random()
		make_chat_msg( USERNAME.pick_random(), stupid_blablabla, false )
	
	## Clean oldest message
	if chat_scroll.get_children().size() > 20:
		chat_scroll.get_children().front().queue_free()
		
	## Users Online
	if randf() > 0.75:
		users_online_value.text = str( 4995863 + randi_range(-4, 4) )
		
	if randf() > 0.75:
		chat_timer.start( 0.0 )
	else:
		chat_timer.start( randf() )

func make_chat_msg( user : String, msg : String, is_player : bool ) -> void:
	var message := RichTextLabel.new()
	message.custom_minimum_size.y = 10.0
	message.bbcode_enabled = true
	if is_player:
		message.push_color( Color.PURPLE )
		message.append_text( user + ":\t\t" )
		message.pop()
		message.push_color( Color.AQUA )
		message.append_text( msg )
		message.pop()
	else:
		message.push_color( Color.RED )
		message.append_text( user + ":\t\t" )
		message.pop()
		message.push_color( Color.DARK_CYAN )
		message.append_text( msg )
		message.pop()
	chat_scroll.add_child( message )

func _input(event: InputEvent) -> void:
	if event is InputEventJoypadButton or event is InputEventKey:
		if visible:
			if Input.is_anything_pressed():
				chat_message.visible_characters += 1
				if chat_message.visible_ratio >= 1.0:
					make_chat_msg( "Bballster69", chat_message.text, true )
					chat_message.text = HOOPZ_MESSAGE.pick_random()
					chat_message.visible_ratio = 0.0
