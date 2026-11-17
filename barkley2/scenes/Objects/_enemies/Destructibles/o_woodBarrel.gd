extends B2_EnemyCombatActor

func _after_damage() -> void:
	pass

func _before_death() -> void:
	pass

func _after_death() -> void:
	ActorSmokeEmitter.emitting = true
