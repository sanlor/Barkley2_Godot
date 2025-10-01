extends Area2D

@export var cup_name := "Sewer Goblet"

@onready var s_mg_diving_goblet: AnimatedSprite2D = $s_mg_diving_goblet

func _on_body_entered(body: Node2D) -> void:
	if body.name == "o_mg_diving_player":
		s_mg_diving_goblet.play("picked")
		B2_Screen.display_damage_number( self, cup_name, Color.WHITE, 4, 10.0 )
		B2_Sound.play("sn_mg_diving_goblet")

func _on_s_mg_diving_goblet_animation_finished() -> void:
	if s_mg_diving_goblet.animation == "picked":
		queue_free()
