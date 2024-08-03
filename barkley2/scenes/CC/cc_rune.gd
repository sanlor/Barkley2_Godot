extends Control

signal rune_selected

@onready var rune_bg = $rune_bg
@onready var rune_center = $rune_center
@onready var rune_description = $rune_description
@onready var rune_message = $rune_message
@onready var exit_message = $exit_message

const CC_RUNE_RUNES = preload("res://barkley2/scenes/CC/cc_rune_runes.tscn")

var col : Array[Color]

var description : PackedStringArray
var message : PackedStringArray

var zauber := 0

## Orbit
const orbit_speed := 0.35
var target_orbit_speed := orbit_speed
var time_goes_on := 0.0
var can_orbit := false

const rune_dir := Vector2(70,0)
var target_rune_dir := rune_dir

var runes := Array()

var can_finish_rune_process := false

# God bless this mess
func _ready():
	col.resize(8)
	description.resize(8)
	message.resize(8)
	
	rune_message.hide()
	exit_message.hide()
		
#region data
	# rune color
	col[0] = Color.ORANGE
	col[1] = Color.LIME
	col[2] = Color.RED
	col[3] = Color.PURPLE
	col[4] = Color.AQUA
	col[5] = Color.YELLOW
	col[6] = Color.FUCHSIA
	col[7] = Color.GRAY
	
	# Rune decription after selection
	message[0] = "Like the fire in our hearts, your spirit burns with passion. Your archnemesis is the letter O.";
	message[1] = "Like hard candy from a bowl, your heart is sweet but strong. Your are spiritually close to the Grandfather Clock element.";
	message[2] = "Like the ruthless glaciers of the deep north, you also are a force of nature. Your tongue is immune to metal based traps.";
	message[3] = "Like the plentiful ricefields of the east, your wealth is shared to those in need. You draw your power from Rice Crispies.";
	message[4] = "Like the unruly children who scream and shout, you too love the animes. You yearn to dress funny and are overweight.";
	message[5] = "Like the ultimate artform, you too seek to bring perfection into the universe. Gamestop and webcomics are your Ying and Yang.";
	message[6] = "Like the delicious yellow candy of nature, you also hold the power of transformation when fire is near. Your spirit animal is the Phoenix.";
	message[7] = "Like the proud and noble Pumilius Pumilio, you too respect the power of gemstones. Goblets and rubies bring you unfathomable tranquility.";
	
	# rune description after mouse hover
	description[0] = "M'kah, spirit of fire";
	description[1] = "Tuh, ghost of grandpa";
	description[2] = "Esh'tak, specter of winter";
	description[3] = "Olop, wraith of riceballs";
	description[4] = "Nip'pon, apparition of anime";
	description[5] = "Xatar, phantom of vidcons";
	description[6] = "Dilly dong dong, kelpie of corn cobs";
	description[7] = "As'hak, haunt of dwarves";
	
	
#endregion

	# show_runes()

func show_runes():
	rune_bg.visible = true
	rune_bg.color.a = 0.0
	var tween := create_tween()
	tween.tween_property( rune_bg, "color:a", 0.5, 1.0 )
	tween.tween_interval( 1.5 )
	await tween.finished
	
	for i in 8:
		var rune = CC_RUNE_RUNES.instantiate()
		rune_center.add_child( rune )
		runes.append( rune )
		rune.position += Vector2(500,500) # HACK - outside the screen
		rune.mouse_hovering.connect( _show_description )
		rune.mouse_clicked.connect( _selected_rune )
		rune.set_rune_id( i )
		rune.set_rune_color( col[i] )
		
	target_orbit_speed = 5.0
	target_rune_dir.x = 150.0
	
	can_orbit = true
	
	tween = create_tween()
	tween.set_parallel( true )
	tween.tween_property(self, "target_orbit_speed", 	orbit_speed, 	2.0).set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "target_rune_dir:x", 	rune_dir.x, 	2.0).set_trans(Tween.TRANS_SINE)
	await tween.finished
	
	for rune in runes:
		rune.can_be_clicked = true

func _show_description(id : int, _show : bool):
	rune_description.visible = _show
	rune_description.text = Text.pr( description[id] )
	rune_description.modulate = col[id]

func _selected_rune( id : int ):
	B2_Playerdata.Quest("playerCCRune", description[id] ) ## Save data.
	
	var selected_rune = runes[ id ]
	
	rune_message.modulate = col[ id ]
	rune_message.text = Text.pr( message[ id ] )
	
	rune_message.modulate.a = 0.0
	exit_message.modulate.a = 0.0
	
	exit_message.text = Text.pr( "Press any key to continue" )
	
	rune_message.show()
	exit_message.show()
	
	var tween := create_tween()
	#tween.set_parallel( true )
	for rune in runes: # fade other runes
		if rune == selected_rune:
			continue
		tween.parallel().tween_property(rune, "modulate:a", 0.0, 0.25).set_trans(Tween.TRANS_SINE)
		
	tween.tween_property(self, "target_rune_dir:x", 	0.0, 	1.5).set_trans(Tween.TRANS_SINE)
	tween.tween_callback( set.bind("can_orbit", false ) )
	tween.tween_callback( 
		func(): 
			for rune in runes: 
				if rune == selected_rune:
					continue
				rune.queue_free() 
	)
	tween.tween_interval( 1.5 )
	tween.tween_property(rune_message, "modulate:a", 1.0, 1.0)
	tween.tween_interval( 2.0 )
	tween.tween_property(exit_message, "modulate:a", 1.0, 1.0)
	tween.tween_callback( set.bind( "can_finish_rune_process", true ) )
	
func fade_out():
	var tween := create_tween()
	tween.tween_property( self, "modulate:a", 0.0, 0.5 )
	tween.tween_callback( emit_signal.bind( "rune_selected" ) )
	
func _physics_process(delta):
	if can_orbit:
		## Speeen.
		time_goes_on += delta * target_orbit_speed
		#time_goes_on = wrapf(time_goes_on, 0, TAU) # no leaky memory, ok?
		for i in 8:
			runes[i].position = target_rune_dir.rotated( TAU / 8 * i + ( -time_goes_on ) )
			runes[i].position.x *= 2.0
		#print(time_goes_on)
		
	if can_finish_rune_process:
		if Input.is_action_just_pressed("Action"):
			fade_out()
