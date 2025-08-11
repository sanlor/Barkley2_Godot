@tool
@icon("res://barkley2/assets/b2_original/images/merged/sBCTWarpE.png")
extends Area2D
## This scene is responsible to spawn enemies and start the combat cinama script.

@onready var detection_radius: CollisionShape2D = $detection_radius

@export_tool_button("Make CinemaSpot") var make_action = _make_cinema_spot
@export_tool_button("Make Enemies") var make_enemies = _make_enemies
@export var enemy_list 		: Dictionary[PackedScene, int]
@export var my_enemies 		: Array[B2_EnemyCombatActor] 	## list of spawned enemies
@export var nest_radius		:= 64.0

@export_category("Prep")
@export var start_activated := true
@export var keep_current_music := false

@export_category("Combat stuff")
@export var combat_script : B2_Script_Combat

func _make_cinema_spot():
	var cinema := B2_CinemaSpot.new()
	var id := get_tree().get_nodes_in_group("cinema_spot").size()
	cinema.cinema_id = id
	cinema.name = "o_cinema" + str( id )
	add_sibling(cinema, true)
	cinema.position = position
	cinema.owner = get_parent()

func _ready() -> void:
	detection_radius.shape.radius = nest_radius
	if start_activated:
		activate_nest()
	else:
		deactivate_nest()
	
func _on_body_entered(body: Node2D) -> void:
	if body == B2_CManager.o_hoopz:
		if my_enemies.is_empty():
			push_error("Enemy Nest tried to activate without any enemies set.")
			deactivate_nest()
		else:
			deactivate_nest()
			begin_battle()
	
# Used to manually add enemies.
func add_enemy( enemy : B2_EnemyCombatActor ) -> void:
	my_enemies.append( enemy )
	
func activate_nest() -> void:
	detection_radius.set_deferred( "disabled", false )

func deactivate_nest() -> void:
	detection_radius.set_deferred( "disabled", true )
	
func _make_enemies() -> void:
	if my_enemies.is_empty():
		for e in enemy_list:
			for n in enemy_list[e]:
				var angle = 2 * PI * n / enemy_list[e]
				var enemy = e.instantiate() as B2_EnemyCombatActor
				await get_tree().process_frame
				add_sibling( enemy, true )
				enemy.set_owner( get_parent() )
				enemy.position = global_position + Vector2.RIGHT.rotated( angle ) * 50.0
				my_enemies.append( enemy )

func begin_battle() -> void:
	_pre_battle_start()
	for e : B2_EnemyCombatActor in my_enemies:
		e.set_mode( B2_EnemyCombatActor.MODE.COMBAT )
		
	B2_CManager.cinema_caller = self
	B2_CManager.start_combat( combat_script, my_enemies )
	#B2_CManager.combat_manager.combat_ended.connect( _post_battle_end )
	B2_CombatManager.combat_ended.connect( _post_battle_end )
	deactivate_nest()

# Called before the battle starts. Used for specific events.
func _pre_battle_start() -> void:
	pass

# Called after the battle ends. Used for specific events.
func _post_battle_end() -> void:
	pass
