extends Control

signal inkblot_finished

@onready var cc_inkblots = $cc_inkblots_page/cc_inkblots
@onready var options = $cc_inkblots_page/options
@onready var cc_inkblots_page = $cc_inkblots_page

var inkblots_id := 0
var inkblots_choices := []
var inkblots_asked = 0

func _ready():
	# initial randomness
	seed( hash(Time.get_ticks_usec() ) )
	
	inkblots_id = randi_range( 0, 15 )
	
	for i in 4:
		var option_id := Label.new()
		cc_inkblots_page.add_child( option_id )
		option_id.global_position = Vector2( 69, 150 + i * 16 )
		option_id.text = str(i) + " -"
		option_id.theme = preload("res://barkley2/themes/main.tres")
		option_id.modulate = Color.RED
	
	inkblots_choices.resize(16)
	for i in inkblots_choices.size():
		inkblots_choices[i] = Array()
	
	inkblots_choices[0].append( "Basketball referee" )
	inkblots_choices[0].append( "Basketball hoop" )
	inkblots_choices[0].append( "A basketball whistle" )
	inkblots_choices[0].append( "Basketball jersey" )

	inkblots_choices[1].append( "Three pointer" )
	inkblots_choices[1].append( "Two pointer" )
	inkblots_choices[1].append( "Slam dunk" )
	inkblots_choices[1].append( "A basketball dunk" )

	inkblots_choices[2].append( "Jump shot" )
	inkblots_choices[2].append( "Foul ball" )
	inkblots_choices[2].append( "Third quarter of a basketball match" )
	inkblots_choices[2].append( "A be-dunked basketball" )

	inkblots_choices[3].append( "An ancient basketball secret" )
	inkblots_choices[3].append( "A lost basketball tome" )
	inkblots_choices[3].append( "A withered basketball parchment" )
	inkblots_choices[3].append( "Basketball artifact" )

	inkblots_choices[4].append( "Basketball shorts" )
	inkblots_choices[4].append( "Basketball net" )
	inkblots_choices[4].append( "Basketball court" )
	inkblots_choices[4].append( "Basketball cheerleader" )

	inkblots_choices[5].append( "College basketball" )
	inkblots_choices[5].append( "NBA" )
	inkblots_choices[5].append( "High school basketball" )
	inkblots_choices[5].append( "Little league basketball" )

	inkblots_choices[6].append( "Pre-game warmup" )
	inkblots_choices[6].append( "Basketball playbook" )
	inkblots_choices[6].append( "Assistant basketball coach" )
	inkblots_choices[6].append( "Slam dunk" )

	inkblots_choices[7].append( "Basketball totem" )
	inkblots_choices[7].append( "Basketball rune" )
	inkblots_choices[7].append( "Fun basketball vidcon" )
	inkblots_choices[7].append( "Basketball song on the radio" )

	inkblots_choices[8].append( "Bouncing basketball" )
	inkblots_choices[8].append( "Swooshing basketball" )
	inkblots_choices[8].append( "Dunked basketball" )
	inkblots_choices[8].append( "Deflated basketball" )

	inkblots_choices[9].append( "A cosmic dunk" )
	inkblots_choices[9].append( "Dribbling through the legs" )
	inkblots_choices[9].append( "Spectral ref" )
	inkblots_choices[9].append( "Glowing coach" )

	inkblots_choices[10].append( "Basketball layup" )
	inkblots_choices[10].append( "Basketball free throw" )
	inkblots_choices[10].append( "Basketball half court" )
	inkblots_choices[10].append( "Basketball sideline" )

	inkblots_choices[11].append( "Jock jams" )
	inkblots_choices[11].append( "Very high jump" )
	inkblots_choices[11].append( "Basketball player" )
	inkblots_choices[11].append( "Sneaker" )

	inkblots_choices[12].append( "Somber whistle" )
	inkblots_choices[12].append( "Energetic whistle" )
	inkblots_choices[12].append( "Chipper whistle" )
	inkblots_choices[12].append( "Distraught whistle" )

	inkblots_choices[13].append( "Bulging basketball muscle" )
	inkblots_choices[13].append( "Bedazzling basketball muscle" )
	inkblots_choices[13].append( "Waterproof basketball muscle" )
	inkblots_choices[13].append( "Eldritch basketball muscle" )

	inkblots_choices[14].append( "A wise coach" )
	inkblots_choices[14].append( "A chaotic coach" )
	inkblots_choices[14].append( "A cryptic coach" )
	inkblots_choices[14].append( "A wet coach" )

	inkblots_choices[15].append( "x10 gravity basketball chamber" )
	inkblots_choices[15].append( "x100 gravity basketball chamber" )
	inkblots_choices[15].append( "x1000 gravity basketball chamber" )
	inkblots_choices[15].append( "1/100 gravity basketball chamber" )
	
	setup_buttons()
	
func setup_buttons():
	inkblots_id += 1 + randi_range( 0, 1 )
	inkblots_id = wrapi( inkblots_id, 0, 15 )
	
	# clear old options
	var childs := options.get_children()
	for i in childs:
		i.queue_free()
		
	# inkblot
	cc_inkblots.frame = wrapi( inkblots_id, 0, 11 )
	
	# setup ink options
	for i in 4:
		var option := Button.new()
		options.add_child( option )
		
		option.position = Vector2( 91, 150 + i * 16)
		option.text = inkblots_choices[ inkblots_id ][ i ]
		option.theme = preload("res://barkley2/themes/main.tres")
		option.button_down.connect( func(): select_choice( i ); next_slide() )
		
func select_choice( choice ):
	B2_Sound.play( "sn_cc_inkblots_left" )
	B2_Playerdata.character_inkblots[ inkblots_id ] = choice
	# Quest("playerCCInkblot" + string(inkblots_id), i + 1);
	inkblots_asked += 1
	
	if inkblots_asked >= 4:
		fade_out()

func next_slide():
	if inkblots_asked >= 4:
		return
		
	var tween := create_tween()
	# center 192 120
	tween.tween_property( cc_inkblots_page, "position:x", 192 * 4, 1.0 )
	tween.tween_callback( setup_buttons )
	tween.tween_callback( B2_Sound.play.bind( "sn_cc_inkblots_right" ) )
	tween.tween_callback( cc_inkblots_page.set_position.bind( Vector2( -192, 120 ) ) )
	tween.tween_property( cc_inkblots_page, "position:x", 192, 1.0 )

func show_inkblot():
	show()
	modulate.a = 0.0
	var tween := create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 0.5)

func fade_out():
	var tween := create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.5)
	tween.tween_callback( emit_signal.bind("inkblot_finished") )
	#tween.tween_callback( queue_free )
