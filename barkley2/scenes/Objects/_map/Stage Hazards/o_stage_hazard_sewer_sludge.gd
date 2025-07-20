extends Sprite2D

@onready var contact_area: Area2D = $contact_area

func _ready() -> void:
	hide()

func _on_hit_cooldown_timeout() -> void:
	if contact_area.has_overlapping_bodies():
		for body : Node2D in contact_area.get_overlapping_bodies():
			if body is B2_CombatActor:
				body.damage_actor( 1, Vector2.ZERO )
				## TODO add status effect
				push_warning("TODO: status effects.")
