extends CanvasLayer
## TODO THis is incomplete.
# https://youtu.be/kMybONQr0wA?t=11255
# check o_hoopz_death_grayscale

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var bg: ColorRect = $bg
@onready var ded_hoopz: AnimatedSprite2D = $bg/Control/ded_hoopz

@onready var defeat_text: RichTextLabel = $bg/defeat_text
@onready var defeat_flavor: Label = $bg/VBoxContainer/defeat_flavor

@onready var continue_btn: Button = $bg/VBoxContainer/B2_Border/MarginContainer/CenterContainer/VBoxContainer/continue
@onready var give_up_btn: Button = $bg/VBoxContainer/B2_Border/MarginContainer/CenterContainer/VBoxContainer/give_up

## TODO get original games text
const GO_NAMES := [
	"Got dunked on!",
	"You ate some dirt!",
	"Well... Shit."
]
const GO_FLAVOR := [
	"At that moment, you thought...",
]

func _ready() -> void:
	defeat_text.clear()
	defeat_text.parse_bbcode( "[wave amp=50.0 freq=5.0 connected=1] %s [/wave]" % Text.pr( GO_NAMES.pick_random() ) )
	defeat_flavor.text = Text.pr( GO_FLAVOR.pick_random() )
	
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
