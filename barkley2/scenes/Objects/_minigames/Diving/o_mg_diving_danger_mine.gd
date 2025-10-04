extends Area2D

const O_MG_DIVING_DANGER_EXPLOSION = preload("uid://s7vkb38vjeab")

@onready var s_mg_diving_mine: AnimatedSprite2D = $s_mg_diving_mine
@onready var flash: PointLight2D = $flash

func _ready() -> void:
	s_mg_diving_mine.speed_scale = randf_range(0.8,1.1)

func _on_s_mg_diving_mine_frame_changed() -> void:
	flash.enabled = s_mg_diving_mine.frame == 4

func _explode() -> void:
	var expl := O_MG_DIVING_DANGER_EXPLOSION.instantiate()
	expl.global_position = global_position
	add_sibling.call_deferred( expl, true )
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.name == "o_mg_diving_player":
		_explode()
	elif body.name == "o_mg_diving_danger_torpedo":
		_explode()
	elif body.name == "o_mg_diving_danger_explosion":
		_explode()
