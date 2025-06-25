extends Control

@onready var audio_stream_player: 	AudioStreamPlayer = $"../../AudioStreamPlayer"
@onready var dnet_screen: 			CanvasLayer 			= $"../.."
@onready var muzak_title: 			Label 					= $bg_track/muzak_banner/muzak_title
@onready var pappy_himself: 		AnimatedSprite2D 		= $pappy_himself
@onready var pappy_audio: 			AudioStreamPlayer 		= $pappy_audio

## Track names ##
const TRACK_NAME := [
	"apecrescendo",
	"cute",
	"doomwop",
	"dw_2",
	"hweru3",
	"killers2",
	"town_2",
	"wapbap_2",
	"weez_2",
	]

@export var info_sfx_player 	: AudioStreamPlayer

func _ready() -> void:
	audio_stream_player.finished.connect( 
		func(): 
			_on_o_dnet_muzak_next_pressed()
			_update_music_title() 
			)
			
	_update_music_title()

func _update_music_title() -> void:
	muzak_title.text = TRACK_NAME[ dnet_screen.music_index ]

func _on_o_dnet_muzak_play_pressed() -> void:
	dnet_screen.play_music()
	pappy_himself.play("pappy_tapping")
	pappy_audio.stop()
	_update_music_title()

func _on_o_dnet_muzak_pause_pressed() -> void:
	dnet_screen.stop_music()
	pappy_himself.animation = "pappy_talking"
	pappy_himself.stop()
	pappy_audio.stop()
	_update_music_title()

func _on_o_dnet_muzak_prev_pressed() -> void:
	dnet_screen.music_index = wrapi( dnet_screen.music_index - 1, 0, 8 )
	dnet_screen.play_music()
	pappy_himself.play("pappy_tapping")
	pappy_audio.stop()
	_update_music_title()

func _on_o_dnet_muzak_next_pressed() -> void:
	dnet_screen.music_index = wrapi( dnet_screen.music_index + 1, 0, 8 )
	dnet_screen.play_music()
	pappy_himself.play("pappy_tapping")
	pappy_audio.stop()
	_update_music_title()

func _on_quick_and_dirty_mouse_detection_pressed() -> void:
	pappy_himself.play("pappy_talking")
	pappy_audio.play()

func _on_pappy_audio_finished() -> void:
	if audio_stream_player.is_playing():
		pappy_himself.play("pappy_tapping")
	else:
		pappy_himself.frame = 0
		pappy_himself.stop()
