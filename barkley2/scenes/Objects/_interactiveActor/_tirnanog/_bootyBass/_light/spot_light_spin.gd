extends Node2D


func _ready() -> void:
	rotate( randf() * TAU )

func _process(delta: float) -> void:
	rotation += 3.0 * delta

func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	queue_free()
