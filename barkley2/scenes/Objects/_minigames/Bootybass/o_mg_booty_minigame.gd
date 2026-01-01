extends "res://barkley2/scenes/Objects/_minigames/Bootybass/DJs/o_mg_booty_dj_segments.gd"
## Hoopz DJ minigame.
# https://www.youtube.com/watch?v=hgnhVcyLy1I

# check o_mg_booty_effect_text
const O_MG_BOOTY_EFFECT_TEXT = preload("uid://bbblp2kyms0wy")

const ADORATION_MESSAGE := [
	"You stink!", 
	"Mediocre", 
	"Interesting...!", 
	"Whoa!!!", 
	"SUPERB!!"
	]
const RANKING := [
	"Toot failure",
	"Toot amateur",
	"Toot dork",
	"Toot hobbyist",
	"Toot slammer",
	"Tootlord",
	]
const RESULTS_TITLE := [
	"Adoration",
	"Toot Intensity",
	"Variety",
	"Booty Quotient",
	]
const TEXT_OPINION := [
	"Mamma mia!",
	"Awesome!",
	"Radical!",
	"Pretty good!",
	"Not bad!",
	"Boring!",
	"Lame!",
	"Obnoxious!",
	"Ghastly!",
	"Bunkum!",
	"Bullpuck!",
	]
const ALLOWED_KEYS := [
	KEY_0,KEY_1,KEY_2,KEY_3,KEY_4,KEY_5,KEY_6,KEY_7,KEY_8,KEY_9,
	KEY_A,KEY_B,KEY_C,KEY_D,KEY_E,KEY_F,KEY_G,KEY_H,KEY_I,KEY_J,KEY_K,KEY_L,KEY_M,KEY_N,KEY_O,KEY_P,KEY_Q,KEY_R,KEY_S,KEY_T,KEY_U,KEY_V,KEY_W,KEY_X,KEY_Y,KEY_Z,
	KEY_DELETE,KEY_SPACE,KEY_KP_SUBTRACT,KEY_KP_ADD
]
# There are a lot of sfx with the prefix "sn_bb_*", which was used here. maybe add a way to re-enable them? check sn_bb_hawk.ogg
const SOUND_INDEX := [
	"sn_enemy_cybergremlin_atk01",
	"sn_enemy_cybergremlin_atk02",
	"sn_enemy_cybergremlin_atk03",
	"sn_enemy_cybergremlin_grunt01",
	"sn_enemy_cybergremlin_grunt02",
	"sn_enemy_cybergremlin_grunt03",
	"sn_enemy_cybergremlin_grunt04",
	"sn_enemy_cybergremlin_battlecry01",
	"sn_enemy_cybergremlin_battlecry02",
	"sn_enemy_cybergremlin_atk01",
	"sn_enemy_duergar_atk01",
	"sn_enemy_duergar_atk02",
	"sn_enemy_duergar_grunt01",
	"sn_enemy_duergar_grunt02",
	"sn_enemy_duergar_grunt03",
	"sn_enemy_cybergremlin_scream01",
	"sn_enemy_cybergremlin_scream02",
	"sn_enemy_cybergremlin_death01",
	"sn_enemy_cybergremlin_death02",
	"sn_enemy_cybergremlin_death03",
	"sn_enemy_brainmenace_atk01",
	"sn_enemy_brainmenace_atk02",
	"sn_enemy_brainmenace_atk03",
	"sn_generic_metalres01",
	"sn_cow_moo3",
	"sn_powerdown01",
	"sn_bubblepop03",
	"sn_busted01", ## Was "sn_busted03", which doesnt exist.
	"sn_godless03",
	"sn_enemy_babyalien_swipe01",
	"sn_utilitycursor_buttondisabled01",
	"sn_cursor_select01",
	"sn_bb_orchit",
	"sn_bonedebris04",
	"sn_katsuFlourish01",
	"sn_pdt_muere",
	"sn_pdt_wilhelm01",
	"sn_pdt_alert01",
	"sn_squish5",
	"sn_dwarf_agree01",
]
@onready var dj_music_track_stream: AudioStreamPlayer = $dj_music_track_stream

# Info bar
@onready var infobar_bg: ColorRect = $booty_ui/infobar_bg
@onready var public_opinion_label: Label = $booty_ui/infobar_bg/public_opinion_label
@onready var public_opinion_result_label: Label = $booty_ui/infobar_bg/public_opinion_result_label
@onready var time_label: Label = $booty_ui/infobar_bg/time_label
@onready var time_left_label: Label = $booty_ui/infobar_bg/time_left_label

# Adoration bar
@onready var adoration_bg: ColorRect = $booty_ui/adoration_bg
@onready var adoration_label: Label = $booty_ui/adoration_bg/adoration_label
@onready var adoration_bar: ProgressBar = $booty_ui/adoration_bg/adoration_bar

@onready var adoration_bonus_label: Label = $booty_ui/adoration_bg/adoration_bonus_label

@onready var input_delay: Timer = $booty_ui/input_delay
@onready var adoration_lights_timer: Timer = $booty_ui/adoration_lights_timer

## UI
@onready var booty_ui: CanvasLayer = $booty_ui

# Ready message
@onready var ready_label: Label = $booty_ui/ready_label

# Finish game screen
@onready var finish_bg: ColorRect = $booty_ui/finish_bg

@export var adoration_decay_rate : Curve # replaces "adoration_decay_timer"

var o_bootySlayer01 		: B2_InteractiveActor
var o_animeBulldog01 		: B2_InteractiveActor

var music_track 			:= "mus_tnn_jockjam"

# Game result
var adoration				:= 0.0		# "Adoration"
var buttons_pressed			:= 0.0		# "Toot Intensity"
var variety_total			:= 0.0		# "Variety"
var reward_from_minigame 	:= 0.0		# "Booty Quotient"

var adoration_bonus 		:= 0

var variety 		: Array[bool] 	= []
var toot_points 	: Array[int] 	= []

var minigame_is_running 	:= false

# Color for the UI #
var red 					:= randi_range(0,150)
var green 					:= randi_range(0,150)
var blue 					:= randi_range(0,150)
var goal_red 				:= 255;
var goal_green 				:= 255;
var goal_blue 				:= 255;

var alpha_score 			:= 0.0
var alpha_score_goal 		:= 0.0
var alpha_text_finish 		:= 0.0
var alpha_countdown 		:= 0.0
var alpha_press_to_continue := 0.0
var alpha_toot 				:= 1.0
var adoration_bonus_alpha 	:= 1.0
var mixed_color				:= Color.WHITE
var mixed_color2				:= Color.WHITE
var scale_countdown 		:= 0.8;

func _ready() -> void:
	B2_Input.can_fast_forward = false
	
	variety.resize(40)
	variety.fill(false)
	
	toot_points.resize(40)
	for i in toot_points.size() - 1:
		toot_points[i] = 5 - randi_range(0,5)
		
	assert( ALLOWED_KEYS.size() == 40, "Invalid size: %s" % ALLOWED_KEYS.size() )
		
	adoration_bonus_label.hide()
	infobar_bg.hide()
	adoration_bg.hide()
	finish_bg.hide()
	ready_label.hide()
	super()
	
	# This node expects to find a node called "o_bootySlayer01" and "o_animeBulldog01" as its sibling.
	o_bootySlayer01 = get_parent().find_child("o_bootySlayer01")
	o_animeBulldog01 = get_parent().find_child("o_animeBulldog01")
	assert(o_animeBulldog01)
	assert(o_bootySlayer01)
	
	o_bootySlayer01.cinema_set( "stop" )
	o_animeBulldog01.cinema_set( "stop" )
	o_mg_booty_surface.hoopz_lights()
	
	camera_is_spining = true
	_begin_animation()

func _play_minigame_music() -> void:
	adoration_bonus_label.show()
	infobar_bg.show()
	adoration_bg.show()
	
	minigame_is_running = true
	dj_music_track_stream.stream = B2_Music.get_music_stream(music_track)
	dj_music_track_stream.play()
	adoration_lights_timer.start()

func _on_dj_music_track_stream_finished() -> void:
	minigame_is_running = false
	time_left_label.text = "00:00" ## Avoids the timer turning to "00:64".
	camera_is_spining = false
	await get_tree().create_timer(1.0).timeout
	o_mg_booty_surface.enable_light() ## Re-enable normal lightsx
	
	o_bootySlayer01.cinema_set( "default" )
	o_animeBulldog01.cinema_set( "default" )
	B2_CManager.o_cts_hoopz.cinema_set( "stand_S" )
	B2_CManager.o_cts_hoopz.z_index = 0
	
	# tally variety -> o_mg_booty_minigame step line 346
	variety_total = variety.count(true)
	
	# Hide stuff
	infobar_bg.hide()
	adoration_bg.hide()
	
	# Show finish sequence
	finish_bg.show()
	finish_bg.begin_sequence()
	await finish_bg.finished
	
	# Decide the consequences of your actions. NOTE 'reward_from_minigame' is set by 'finish_bg'.
	if reward_from_minigame > 128: 	B2_Playerdata.Quest("booty_just_won", 1);
	else: 							B2_Playerdata.Quest("booty_just_lost", 1);
	
	B2_Music.play("mus_tnn_bootylectro")
	finished.emit()
	B2_Input.can_fast_forward = true
	queue_free()

func _begin_animation() -> void:
	B2_CManager.o_cts_hoopz.cinema_set( "hoopzDJ", true ) # This shit was hidden! WTF!!! check o_mg_booty_minigame draw line 2. What a stupid way to set an animation.
	B2_CManager.o_cts_hoopz.z_index = 100
	
	ready_label.show()
	ready_label.rotation = 0
	ready_label.scale = Vector2.ZERO
	
	var farts := func(tween : Tween, text : String):
		tween.tween_callback( ready_label.set_modulate.bind( Color.RED ) )
		tween.tween_callback( ready_label.set_scale.bind( Vector2.ZERO ) )
		tween.tween_callback( ready_label.set_text.bind( text ) )
		tween.tween_callback( ready_label.set_rotation.bind( randf_range(-0.7, 0.7) ) )
		tween.tween_property( ready_label, "scale", Vector2.ONE * 5.0, 0.5 )
		tween.parallel().tween_property( ready_label, "modulate", Color.GREEN, 0.5 ).set_ease(Tween.EASE_OUT_IN)
		tween.tween_property( ready_label, "modulate", Color.TRANSPARENT, 0.25 )
		tween.tween_interval( 0.25 )
	
	var t := create_tween()
	farts.call( t, "3")
	farts.call( t, "2")
	farts.call( t, "1")
	farts.call( t, Text.pr("GO!") )
	
	t.tween_callback( ready_label.queue_free )
	
	## TODO
	spin_camera()
	await t.finished # wait for the animation to finish.
	_play_minigame_music()

func _update_public_opinion() -> void:
	pass
	
func _update_time() -> void:
	time_left_label.text = "00:" + str( int( dj_music_track_stream.stream.get_length() - dj_music_track_stream.get_playback_position() ) ).pad_zeros(2)
	time_left_label.modulate = Color.YELLOW#Color(mixed_color, alpha_countdown)
	
func _update_adoration() -> void:
	# Reduce adoration by time, using a decay rate modifier.
	adoration = clampf( adoration - 0.25 * adoration_decay_rate.sample( adoration / 100.0 ), 0.0, 100.0) 
	adoration_bar.value = adoration
	adoration_bar.modulate = mixed_color
	
	if adoration_bonus >= 0:	adoration_bonus_label.text = Text.pr("Adoration +") 	+ str( int(adoration_bonus) )
	else: 						adoration_bonus_label.text = Text.pr("Adoration ") 		+ str( int(adoration_bonus) )
	adoration_bonus_label.modulate = Color(mixed_color2, adoration_bonus_alpha)
	
	# Values #
	if adoration <= 20:
		public_opinion_result_label.modulate = Color.RED
		public_opinion_result_label.text = Text.pr("You stink!")
	elif adoration <= 40:
		public_opinion_result_label.modulate = Color.ORANGE
		public_opinion_result_label.text = Text.pr("Mediocre");
	elif adoration <= 60:
		public_opinion_result_label.modulate = Color.YELLOW
		public_opinion_result_label.text = Text.pr("Interesting...!");
	elif adoration <= 80:
		public_opinion_result_label.modulate = Color.GREEN
		public_opinion_result_label.text = Text.pr("Whoa!!!");
	elif adoration <= 100:
		public_opinion_result_label.modulate = mixed_color
		public_opinion_result_label.text = Text.pr("SUPERB!!");

func _unhandled_input(event: InputEvent) -> void:
	if event.is_pressed() and minigame_is_running:
		_process_input()

func _process_input() -> void:
	if not input_delay.is_stopped():
		return
		
	## 26/12/25 This is a bit weird. Im not sure how this should work yet.
	var make_a_toot 	:= false
	var toot_index		:= 0
	if B2_Input.is_using_gamepad():
		if Input.is_joy_button_pressed(0, JOY_BUTTON_A):
			make_a_toot = true;
			if Input.is_joy_button_pressed(0, JOY_BUTTON_DPAD_UP):		toot_index = 0
			elif Input.is_joy_button_pressed(0, JOY_BUTTON_DPAD_DOWN):	toot_index = 1
			elif Input.is_joy_button_pressed(0, JOY_BUTTON_DPAD_RIGHT):	toot_index = 2
			elif Input.is_joy_button_pressed(0, JOY_BUTTON_DPAD_LEFT):	toot_index = 3
			else:														toot_index = 4
		if Input.is_joy_button_pressed(0, JOY_BUTTON_B):
			make_a_toot = true;
			if Input.is_joy_button_pressed(0, JOY_BUTTON_DPAD_UP):		toot_index = 5
			elif Input.is_joy_button_pressed(0, JOY_BUTTON_DPAD_DOWN):	toot_index = 6
			elif Input.is_joy_button_pressed(0, JOY_BUTTON_DPAD_RIGHT):	toot_index = 7
			elif Input.is_joy_button_pressed(0, JOY_BUTTON_DPAD_LEFT):	toot_index = 8
			else:														toot_index = 9
		if Input.is_joy_button_pressed(0, JOY_BUTTON_X):
			make_a_toot = true;
			if Input.is_joy_button_pressed(0, JOY_BUTTON_DPAD_UP):		toot_index = 10
			elif Input.is_joy_button_pressed(0, JOY_BUTTON_DPAD_DOWN):	toot_index = 11
			elif Input.is_joy_button_pressed(0, JOY_BUTTON_DPAD_RIGHT):	toot_index = 12
			elif Input.is_joy_button_pressed(0, JOY_BUTTON_DPAD_LEFT):	toot_index = 13
			else:														toot_index = 14
		if Input.is_joy_button_pressed(0, JOY_BUTTON_Y):
			make_a_toot = true;
			if Input.is_joy_button_pressed(0, JOY_BUTTON_DPAD_UP):		toot_index = 15
			elif Input.is_joy_button_pressed(0, JOY_BUTTON_DPAD_DOWN):	toot_index = 16
			elif Input.is_joy_button_pressed(0, JOY_BUTTON_DPAD_RIGHT):	toot_index = 17
			elif Input.is_joy_button_pressed(0, JOY_BUTTON_DPAD_LEFT):	toot_index = 18
			else:														toot_index = 19
		if Input.is_joy_button_pressed(0, JOY_BUTTON_LEFT_SHOULDER):
			make_a_toot = true;
			if Input.is_joy_button_pressed(0, JOY_BUTTON_DPAD_UP):		toot_index = 20
			elif Input.is_joy_button_pressed(0, JOY_BUTTON_DPAD_DOWN):	toot_index = 21
			elif Input.is_joy_button_pressed(0, JOY_BUTTON_DPAD_RIGHT):	toot_index = 22
			elif Input.is_joy_button_pressed(0, JOY_BUTTON_DPAD_LEFT):	toot_index = 23
			else:														toot_index = 24
		if Input.is_joy_button_pressed(0, JOY_BUTTON_RIGHT_SHOULDER):
			make_a_toot = true;
			if Input.is_joy_button_pressed(0, JOY_BUTTON_DPAD_UP):		toot_index = 25
			elif Input.is_joy_button_pressed(0, JOY_BUTTON_DPAD_DOWN):	toot_index = 26
			elif Input.is_joy_button_pressed(0, JOY_BUTTON_DPAD_RIGHT):	toot_index = 27
			elif Input.is_joy_button_pressed(0, JOY_BUTTON_DPAD_LEFT):	toot_index = 28
			else:														toot_index = 29
		if roundf(Input.get_joy_axis(0, JOY_AXIS_TRIGGER_LEFT)) != 0.0:
			make_a_toot = true;
			if Input.is_joy_button_pressed(0, JOY_BUTTON_DPAD_UP):		toot_index = 30
			elif Input.is_joy_button_pressed(0, JOY_BUTTON_DPAD_DOWN):	toot_index = 31
			elif Input.is_joy_button_pressed(0, JOY_BUTTON_DPAD_RIGHT):	toot_index = 32
			elif Input.is_joy_button_pressed(0, JOY_BUTTON_DPAD_LEFT):	toot_index = 33
			else:														toot_index = 34
		if roundf(Input.get_joy_axis(0, JOY_AXIS_TRIGGER_RIGHT)) != 0.0:
			make_a_toot = true;
			if Input.is_joy_button_pressed(0, JOY_BUTTON_DPAD_UP):		toot_index = 35
			elif Input.is_joy_button_pressed(0, JOY_BUTTON_DPAD_DOWN):	toot_index = 36
			elif Input.is_joy_button_pressed(0, JOY_BUTTON_DPAD_RIGHT):	toot_index = 37
			elif Input.is_joy_button_pressed(0, JOY_BUTTON_DPAD_LEFT):	toot_index = 38
			else:														toot_index = 39
	else:
		for key in ALLOWED_KEYS.size() - 1:
			if Input.is_key_pressed( ALLOWED_KEYS[key] ):
				make_a_toot = true
				toot_index = key
				break
	# Play the toot #
	if make_a_toot == true:
		# Buttons #
		buttons_pressed += 1;

		# Variety #
		variety[toot_index] = true;

		# Toot alpha effect #
		alpha_toot += (adoration_bonus + 5.0) / 10.0 * 0.25; 

		# Play toot #
		B2_Sound.play( SOUND_INDEX[toot_index], 0, false, 1, randf_range( 0.75, 1.25 ), 0.5 )

		# Add adoration #
		adoration_bonus = toot_points[toot_index];
		adoration += adoration_bonus;

		# No spamming the same key for points #
		if toot_points[toot_index] > -5:
			toot_points[toot_index] -= 1;

		# Effects #
		adoration_bonus_alpha = 1.0

		# Limit adoration to 100 #
		adoration = clampf(adoration, 0.0, 100.0)

		# Text popup #
		var text_opinion = TEXT_OPINION.duplicate() ## I fucked up and inverted the array. I WILL NOT FIX IT and added this botch code.
		text_opinion.reverse()
		var popup : Control = O_MG_BOOTY_EFFECT_TEXT.instantiate() #instance_create(-100, -100, o_mg_booty_effect_text);
		popup.my_text = text_opinion[ adoration_bonus + 5 ]
		popup.my_text_id = adoration_bonus + 5
		booty_ui.add_child( popup, true )

		# No more toots #
		make_a_toot = false;
		
		# Avoid multiple, instant inputs (gamepad)
		input_delay.start()

func _update_colors() -> void:
	# Countdown scale #
	if scale_countdown < 8: scale_countdown += 0.5;
		
	# Alphas #
	if alpha_score < alpha_score_goal: alpha_score += 0.1;
	if alpha_score > alpha_score_goal: alpha_score -= 0.1;
	if alpha_toot > 0: alpha_toot -= 0.05;
	if alpha_countdown > 0: alpha_countdown -= 0.025;

	# Color red #
	if red < goal_red: red += 15;
	if red > goal_red: red -= 10;
	if red > 255: red = 255;
	if red < 0: red = 0;
	if red == goal_red:
		if goal_red == 0: goal_red = 255;
		elif goal_red == 255: goal_red = 0;
		
	# Color green #
	if green < goal_green: green += 20;
	if green > goal_green: green -= 10;
	if green > 255: green = 255;
	if green < 0: green = 0;
	if green == goal_green:
		if goal_green == 0: goal_green = 255;
		elif goal_green == 255: goal_green = 0;
		
	# Color Blue #
	if blue < goal_blue: blue += 10;
	if blue > goal_blue: blue -= 10;
	if blue > 255: blue = 255;
	if blue < 0: blue = 0;
	if blue == goal_blue:
		if goal_blue == 0: goal_blue = 255;
		elif goal_blue == 255: goal_blue = 0;
		
	# Mix colors #
	mixed_color = Color.from_rgba8(255 -red, 255 - green, 255 - blue)
	mixed_color2 = Color.from_rgba8(red, green, blue)

func _physics_process(delta: float) -> void:
	super(delta)
	
func _on_process_timer_timeout() -> void:
	if minigame_is_running:
		#_process_input()
		_update_public_opinion()
		_update_time()
		_update_adoration()
		_update_colors()

func _on_adoration_lights_timer_timeout() -> void:
	if minigame_is_running:
		if adoration <= 35:
			for i in 4:
				o_mg_booty_surface.light_control.create_light_flash(0, 0.5)
		elif adoration <= 65:
			for i in 10:
				o_mg_booty_surface.light_control.create_light_flash(0, 0.5)
		elif adoration <= 100:
			for i in 16:
				o_mg_booty_surface.light_control.create_light_flash(0, 0.5)
		else:
			for i in 20:
				o_mg_booty_surface.light_control.create_light_flash(0, 0.5)
	adoration_lights_timer.start( randf_range(0.5,2) )
