extends Control

signal finished_animation

const SN_DNET_MODEM = preload("res://barkley2/assets/b2_original/audio/Dwarfnet/sn_dnet_modem.ogg")

@export var audio_stream_player: 	AudioStreamPlayer
@onready var bullshit_timer: 		Timer = $bullshit_timer
@onready var main_text: 			Label = $login_box/main_text
@onready var progress_text: 		Label = $login_box/progress_text
@onready var account_created: 		Label = $login_box/account_created

enum {CONN,REQ,FINISH}
var curr_mode := CONN

var progress := [
	".   .   .   .   .   .",
	" .   .   .   .   .   .",
	"  .   .   .   .   .   .",
	"   .   .   .   .   .   ."
]

func begin_animation() -> void:
	main_text.show()
	progress_text.show()
	account_created.hide()
	
	if B2_Playerdata.Quest("dwarfnetAccount") == 0:
		audio_stream_player.stream = SN_DNET_MODEM
		audio_stream_player.play()
		await audio_stream_player.finished
		curr_mode = CONN
		_on_bullshit_timer_timeout()
	else:
		bullshit_timer.start( randf_range(2.0,5.0) )
	
func finish_animation() -> void:
	finished_animation.emit()
	hide()

var t := 0.0 ## progress scroll
var index := 0
func _physics_process(delta: float) -> void:
	if visible:
		if t <= 0.0:
			t = 2.0
			progress_text.text = progress[index]
			index = wrapi( index + 1, 0, 4 )
		else:
			t -= 10 * delta

func _on_bullshit_timer_timeout() -> void:
	match curr_mode:
		CONN:
			curr_mode = REQ
			main_text.text = "Processing request"
			bullshit_timer.start( randf_range(2.0,5.0) )
		REQ:
			curr_mode = FINISH
			main_text.hide()
			progress_text.hide()
			account_created.show()
			bullshit_timer.start( randf_range(2.0,3.0) )
		FINISH:
			finish_animation()
