extends B2_VR_Mission
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var o_enemy_drone_egg: 	B2_Enemy_EggDrone = $o_enemy_drone_egg
@onready var o_enemy_drone_egg_2: 	B2_Enemy_EggDrone = $o_enemy_drone_egg2
@onready var o_enemy_drone_egg_3: 	B2_Enemy_EggDrone = $o_enemy_drone_egg3
@onready var enemy_pool 			:= [o_enemy_drone_egg, o_enemy_drone_egg_2, o_enemy_drone_egg_3]

func _ready() -> void:
	#B2_CombatManager.combat_ended.connect( mission_over.emit )
	o_enemy_drone_egg.enemy_was_defeated.connect( 	check_enemies.bind(o_enemy_drone_egg) )
	o_enemy_drone_egg_2.enemy_was_defeated.connect( check_enemies.bind(o_enemy_drone_egg_2) )
	o_enemy_drone_egg_3.enemy_was_defeated.connect( check_enemies.bind(o_enemy_drone_egg_3) )
	
func check_enemies( enemy : B2_Enemy_EggDrone ) -> void:
	if enemy_pool.has( enemy ):
		enemy_pool.erase( enemy )
	else:
		push_error( enemy.name, " died, but it wasnt on the array.")
		#breakpoint
		
	## All enemies defeated
	if enemy_pool.is_empty():
		mission_over.emit()

func play( anim_name : String ) -> void:
	animation_player.play( anim_name )
