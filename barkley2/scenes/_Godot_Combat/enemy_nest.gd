@tool
extends Area2D
## This scene is responsible to spawn enemies and start the combat cinama script.

@onready var detection_radius: CollisionShape2D = $detection_radius

@export_tool_button("Make_marker") var make_action = _make_marker
@export var enemy_list 		: Dictionary[PackedScene, int]
@export var nest_radius		:= 64.0

@export_category("Combat stuff")
@export var combat_script : B2_CombatScript

var my_enemies : Array[B2_EnemyCombatActor]

@export var player_position_marker : Marker2D ## Where should the player walk to at the start of the battle

func _make_marker():
	player_position_marker = Marker2D.new()
	player_position_marker.name = "player_position_marker"
	add_child(player_position_marker, true)
	player_position_marker.owner = self

func _ready() -> void:
	detection_radius.shape.radius = nest_radius
	make_enemies()
	
func _on_body_entered(body: Node2D) -> void:
	if body == B2_CManager.o_hoopz:
		begin_battle()
	
func make_enemies() -> void:
	for e in enemy_list:
		for n in enemy_list[e]:
			var angle = 2 * PI * n / enemy_list[e]
			var enemy = e.instantiate() as B2_EnemyCombatActor
			add_sibling.call_deferred( enemy, true )
			enemy.position = global_position + Vector2.RIGHT.rotated( angle ) * 50.0
			my_enemies.append( enemy )

func begin_battle() -> void:
	B2_CManager.start_combat( combat_script, my_enemies )
	
	#combat_manager = COMBAT_MANAGER.instantiate()
	#combat_manager.register_player( player )
	#player.disable_control()
	#
	#if player_position_marker:
		#sfx.stream = BATTLE_START
		#sfx.play()
		#await sfx.finished
		#
		#await get_tree().process_frame
		#var t := get_tree().create_tween()
		### FIXMEset_use_custom_integrator
		#t.tween_property( player, "position", player_position_marker, 0.4 ).set_trans(Tween.TRANS_CIRC)
		#await t.finished
	#else:
		#push_warning( "Player position marker not set." )
	#
	#for e in my_enemies:
		#combat_manager.register_enemy( e )
	pass
