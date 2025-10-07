extends CanvasLayer
## TODO This is incomplete.
# https://youtu.be/kMybONQr0wA?t=11255
# check o_hoopz_death_grayscale

## WARNING Junklord not implemented.
# check o_gbl_junklord01

@onready var animation_player: 	AnimationPlayer = $AnimationPlayer
@onready var bg: 				ColorRect = $bg
@onready var ded_hoopz: 		AnimatedSprite2D = $bg/Control/ded_hoopz

@onready var defeat_flavor: 	Label = $bg/VBoxContainer/defeat_flavor

@onready var continue_btn: 		Button = $bg/VBoxContainer/B2_Border/MarginContainer/CenterContainer/VBoxContainer/continue
@onready var give_up_btn: 		Button = $bg/VBoxContainer/B2_Border/MarginContainer/CenterContainer/VBoxContainer/give_up

@onready var haiku_text_vbox: 	VBoxContainer = $bg/haiku_text_vbox
@onready var haiku_lbl_1: 		Label = $bg/haiku_text_vbox/haiku_lbl_1
@onready var haiku_lbl_2: 		Label = $bg/haiku_text_vbox/haiku_lbl_2
@onready var haiku_lbl_3: 		Label = $bg/haiku_text_vbox/haiku_lbl_3

## TODO get original game's text
const GO_NAMES := [
	"Got dunked on!",
	"You ate some dirt!",
	"Well... Shit."
	]
const GO_FLAVOR := [
	"At that moment, you thought...",
	]

const HAIKUS : Array[Array] = [
		["A fond memory",				"Passes like a gentle breeze",			"As my heart draws still"],
		["A collection of",				"memories and thoughts and dreams;", 	"That is all I was"],
		["Living essence spills;", 		"Ebbing tides on a bank that", 			"falls forever dry"],
		["Petals fall like rain", 		"I close my eyes one last time", 		"And feel their caress"],
		["A refreshing mist", 			"Cooling my descent to Hell;", 			"A final comfort"],
		["From my breast spills forth", "The essence that sustains me", 		"And a cleft Mars Bar"],
		["A bolt of lightning!", 		"A brief reprieve from the dark;",		"Gone from whence it came"],
		["So little can one", 			"human hope to achieve in", 			"but a single life"],
		["I recall the taste", 			"of ripe plums from the orchard", 		"as I fall asleep"],
		["I raise my hand to", 			"run my fingers through the clouds", 	"as my soul ascends"],
		["My eyes shed no tears", 		"For I already knew the", 				"ending of this tale"],
		["I had hoped to see", 			"Mount Fuji in the autumn", 			"Before my time came"],
		["An old shepherd plays", 		"A sweet pipe melody to", 				"mark the coming spring"],
		["An unmarked gravestone", 		"tells neither truths nor fiction;", 	"neither names nor deeds"],
	]

var play_haykus := true

func _ready() -> void:
	## Set the correct grayscale
	if B2_CManager.get_BodySwap() == "prison": 	ded_hoopz.animation = "grayscale_prison"
	else:										ded_hoopz.animation = "grayscale"
	
	defeat_flavor.text = Text.pr( GO_FLAVOR.pick_random() )
	
	if play_haykus:
		_load_haikus()
		if B2_CManager.get_BodySwap() == "prison":
			animation_player.play("spin some haikus_prison")
		else:
			animation_player.play("spin some haikus")
	else:
		animation_player.play("haha you goofed")
	
	## Increase death count - NOTE Taken from the B2_ROOMXY script.
	var deaths : int = B2_Config.get_user_save_data( "player.deaths.total", 0 )
	deaths += 1
	B2_Config.set_user_save_data( "player.deaths.total", deaths )
	print( "Death screen displayed. Total death count is %s." % str( B2_Config.get_user_save_data( "player.deaths.total", -1 ) ) )
	
	## VR Missions silliness.
	if B2_Config.get_current_save_slot() == 69:
		continue_btn.text = Text.pr( "No credits left to continue." )
		continue_btn.disabled = true
		give_up_btn.text = Text.pr( "[Jack-off the cybespace.]")
		B2_Playerdata.SaveGame( true )
	
func play_music() -> void:
	B2_Music.play("mus_gameover")

func _load_haikus():
	var haiku : Array = HAIKUS.pick_random()
	haiku_lbl_1.text = haiku[0]
	haiku_lbl_2.text = haiku[1]
	haiku_lbl_3.text = haiku[2]

func _on_give_up_pressed() -> void:
	B2_Sound.play( "sn_cc_death" )
	B2_Music.stop()
	_disable_buttons()
	animation_player.play("you big pussy")
	await animation_player.animation_finished
	
	## NOTE Add a silly animation fo hoopz looking sad.
	# Chrono Triggers gameover screen (Lavos)
	# https://www.pinterest.com/pin/1196337402745668/
	# https://static.tvtropes.org/pmwiki/pub/images/fmab_rain.png
	
	
	B2_Screen.return_to_title()

func _on_continue_pressed() -> void:
	B2_Sound.play( "sn_dwarfchain" )
	## Set the correct grayscale
	
	if B2_CManager.get_BodySwap() == "prison":
		animation_player.play("nevah giveup_prison")
	else:
		animation_player.play("nevah giveup")
	B2_Music.stop()
	_disable_buttons()
	await animation_player.animation_finished
	B2_Playerdata.player_stats.full_restore()
	
	if get_tree().current_scene is B2_ROOMS:
		var room : B2_ROOMS = get_tree().current_scene
		get_tree().current_scene.hide()
		B2_RoomXY.respawn( room.get_room_area(), room.get_room_name() )
	else:
		## ???? dies outside a room?
		breakpoint
		
	queue_free()

func _disable_buttons() -> void:
	continue_btn.disabled 	= true
	give_up_btn.disabled 	= true
