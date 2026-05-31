extends B2_VR_Mission

@onready var o_enemy_catfish_small: 	B2_Enemy_CatFish = $o_enemy_catfish_small
@onready var o_enemy_catfish_small_2: 	B2_Enemy_CatFish = $o_enemy_catfish_small2
@onready var o_enemy_catfish_small_3: 	B2_Enemy_CatFish = $o_enemy_catfish_small3
@onready var enemies := [o_enemy_catfish_small,o_enemy_catfish_small_2,o_enemy_catfish_small_3]

var enemy_count := 0

func _ready() -> void:
	for child in enemies: # Reparent enemies
		remove_child(child)
		add_sibling(child)

func count_enemies() -> void:
	var c := 0
	for child in enemies:
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
