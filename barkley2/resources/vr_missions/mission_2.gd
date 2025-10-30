extends B2_VR_Mission

var enemy_count := 0

func count_enemies() -> void:
	var c := 0
	for child in get_children():
		if child is B2_EnemyCombatActor:
			if not child.is_actor_dead:
				c += 1
	enemy_count = c
	
func _physics_process(_delta: float) -> void:
	count_enemies()
	if enemy_count == 0:
		## Mission over, congrats!
		print("Mission 2 finished.")
		mission_over.emit()
		queue_free()
