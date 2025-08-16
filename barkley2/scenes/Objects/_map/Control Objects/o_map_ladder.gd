@tool
@icon("res://barkley2/assets/b2_original/images/merged/s_map_ladder.png")
extends Area2D

## ATTENTION This script is incomplete. it does not change hoopz animation, only plays sounds.

@onready var icon: Sprite2D = $icon
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

@export_category("Setup")
@export var stretch := Vector2.ONE :
	set(s):
		stretch = s
		if icon:
			icon.scale = stretch

@export_category("SFX")
@export var ladder_sound := "ladder_other";

var player_is_on_ladder := false
var playing_sound := false

func _ready() -> void:
	if not Engine.is_editor_hint():
		icon.queue_free()
	else:
		icon.scale = stretch
		
	var sfx : String = B2_Sound.get_sound( ladder_sound )
	audio_stream_player_2d.stream = load(sfx)
	audio_stream_player_2d.volume_db = linear_to_db( B2_Config.sfx_gain_master )

func _on_body_entered(body: Node2D) -> void:
	if body is B2_PlayerCombatActor:
		player_is_on_ladder = true

func _on_body_exited(body: Node2D) -> void:
	if body is B2_PlayerCombatActordddddddd:
		player_is_on_ladder = false

func _physics_process(_delta: float) -> void:
	if playing_sound:
		return
		
	# Check if hoopz is moving
	if player_is_on_ladder:
		if is_instance_valid( B2_CManager.o_hoopz ):
			if B2_CManager.o_hoopz.velocity != Vector2.ZERO:
				playing_sound = true
				audio_stream_player_2d.play()

func _on_audio_stream_player_2d_finished() -> void:
	playing_sound = false
