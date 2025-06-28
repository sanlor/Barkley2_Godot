extends CanvasLayer

signal key_pressed
signal dnet_closed

const MUSIC_DNET := [
	preload("res://barkley2/assets/b2_original/audio/MusicWeb/mus_dnet_track1.ogg"),
	preload("res://barkley2/assets/b2_original/audio/MusicWeb/mus_dnet_track3.ogg"),
	preload("res://barkley2/assets/b2_original/audio/MusicWeb/mus_dnet_track4.ogg"),
	preload("res://barkley2/assets/b2_original/audio/MusicWeb/mus_dnet_track5.ogg"),
	preload("res://barkley2/assets/b2_original/audio/MusicWeb/mus_dnet_track6.ogg"),
	preload("res://barkley2/assets/b2_original/audio/MusicWeb/mus_dnet_track7.ogg"),
	preload("res://barkley2/assets/b2_original/audio/MusicWeb/mus_dnet_track8.ogg"),
	preload("res://barkley2/assets/b2_original/audio/MusicWeb/mus_dnet_track9.ogg"),
]
var music_index := 0

@export var audio_stream_player: 	AudioStreamPlayer

@export_category("Animation")
@export var enable_boot := true
@export var enable_registration := true

@onready var o_dnet_registration_boot: 	Control = $o_dnet_registration_boot
@onready var o_dnet_registration: 		Control = $o_dnet_registration
@onready var o_dnet_control: 			Control = $o_dnet_control


func _ready() -> void:
	## DEBUG
	#B2_Playerdata.preload_skip_tutorial_save_data()
	layer = B2_Config.DNET_LAYER
	
	o_dnet_registration_boot.hide()
	o_dnet_registration.hide()
	o_dnet_control.hide()
	
	if enable_boot:
		o_dnet_registration_boot.show()
		o_dnet_registration_boot.begin_animation()
		await o_dnet_registration_boot.finished_animation
	remove_child( o_dnet_registration_boot) ## Cleanup
	
	if enable_registration:
		o_dnet_registration.show()
		o_dnet_registration.begin_animation()
		await o_dnet_registration.finished_animation
	remove_child(o_dnet_registration) ## Cleanup
	
	## Skip initial account stuff. No need for the additional dellay everytime you open DNET.
	B2_Playerdata.Quest("dwarfnetAccount", 1)
	
	## Cleanup old animations
	if o_dnet_registration_boot: o_dnet_registration_boot.queue_free()
	if o_dnet_registration: o_dnet_registration.queue_free()
	
	o_dnet_control.show()
	
	#play_random_music()
	o_dnet_control.surf_the_web()
	print("done")

func close_dnet() -> void:
	B2_Playerdata.SaveGame()
	B2_Screen.set_cursor_type( B2_Screen.TYPE.POINT )
	dnet_closed.emit()
	queue_free()

func stop_music() -> void:
	audio_stream_player.stop()
	
func play_random_music( force_music = null ) -> void:
	if force_music:
		music_index = MUSIC_DNET.find(force_music)
	else:
		music_index = randi_range(0,7)
	play_music()

func play_music() -> void:
	audio_stream_player.stream = MUSIC_DNET[music_index]
	audio_stream_player.play()

## Play the keyboard SFX while DNET is open.
func _unhandled_input(event: InputEvent) -> void:
	if visible:
		if event is InputEventKey:
			B2_Sound.play("dnet_keyboard_press")
			key_pressed.emit()
