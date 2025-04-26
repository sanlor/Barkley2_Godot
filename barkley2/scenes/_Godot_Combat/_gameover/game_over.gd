extends CanvasLayer

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var bg: ColorRect = $bg
@onready var ded_hoopz: AnimatedSprite2D = $bg/Control/ded_hoopz

@onready var defeat_text: RichTextLabel = $bg/defeat_text

@onready var continue_btn: Button = $bg/VBoxContainer/B2_Border/MarginContainer/CenterContainer/VBoxContainer/continue
@onready var give_up_btn: Button = $bg/VBoxContainer/B2_Border/MarginContainer/CenterContainer/VBoxContainer/give_up


func _ready() -> void:
	defeat_text.clear()
	defeat_text.parse_bbcode( "[wave amp=50.0 freq=5.0 connected=1] Got dunked on! [/wave]")
	
	animation_player.play("haha you goofed")
	
func play_music() -> void:
	B2_Music.play("mus_gameover")


func _on_give_up_pressed() -> void:
	B2_Sound.play( "sn_cc_death" )
	B2_Music.stop()
	_disable_buttons()

func _on_continue_pressed() -> void:
	B2_Sound.play( "sn_dwarfchain" )
	animation_player.play("nevah giveup")
	B2_Music.stop()
	_disable_buttons()
	if get_tree().current_scene is B2_ROOMS:
		var room : B2_ROOMS = get_tree().current_scene
		B2_RoomXY.respawn( room.get_room_area(), room.get_room_name() )
	else:
		## ???? dies outside a room?
		breakpoint

func _disable_buttons() -> void:
	continue_btn.disabled 	= true
	give_up_btn.disabled 	= true
