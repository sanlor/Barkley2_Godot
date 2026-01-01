@tool
@icon("res://barkley2/assets/b2_original/images/merged/s_map_ladder.png")
extends Area2D
class_name B2_Ladder

## ATTENTION This script is incomplete. it does not change hoopz animation, only plays sounds.

@onready var icon: Sprite2D = $icon

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

func _on_body_entered(body: Node2D) -> void:
	if body is B2_PlayerCombatActor:
		player_is_on_ladder = true
		body.toggle_actor_climb( player_is_on_ladder )

func _on_body_exited(body: Node2D) -> void:
	if body is B2_PlayerCombatActor:
		player_is_on_ladder = false
		body.toggle_actor_climb( player_is_on_ladder )
