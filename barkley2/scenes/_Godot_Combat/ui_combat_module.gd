extends Control
class_name B2_HudCombat
const MENU_WPN_DATA = preload("uid://cnkroip8gbsn1")

signal selected_enemy( enemy : B2_EnemyCombatActor )
signal weapon_selected

var player_character 	: B2_HoopzCombatActor						## In this game, only one player character exists. 
var enemy_list 			: Array[B2_EnemyCombatActor] 	= [] 	## List of all active enemies

@onready var weapon_stats_mini: VBoxContainer = $weapon_stats_mini

@onready var attack_btn: 	Button = $player_control_weapons/MarginContainer/VBoxContainer/attack_btn
@onready var skill_btn: 	Button = $player_control_weapons/MarginContainer/VBoxContainer/skill_btn
@onready var item_btn: 		Button = $player_control_weapons/MarginContainer/VBoxContainer/item_btn
@onready var escape_btn: 	Button = $player_control_weapons/MarginContainer/VBoxContainer/escape_btn

@onready var move_btn: 		Button = $player_control_move/MarginContainer/move_btn
@onready var defend_btn: 	Button = $player_control_defend/MarginContainer/defend_btn

func _ready() -> void:
	attack_btn.pressed.connect( 	_on_attack_btn )
	skill_btn.pressed.connect( 		_on_skill_btn )
	item_btn.pressed.connect( 		_on_item_btn )
	escape_btn.pressed.connect( 	_on_escape_btn )
	move_btn.pressed.connect( 		_on_move_btn )
	defend_btn.pressed.connect( 	_on_defend_btn )

# Is this needed?
func register_player( player : B2_HoopzCombatActor ) -> void:
	player_character = player
	
## Add enemies to an Array
func register_enemies( _enemy_list ) -> void:
	enemy_list = _enemy_list

func _on_attack_btn() -> void:
	## DEBUG
	if B2_Gun.get_current_gun():
		var gun = B2_Gun.get_current_gun() as B2_Weapon
		gun.use_ammo( 15 )
		gun.reset_action()
	pass
	
func _on_skill_btn() -> void:
	pass
	
func _on_item_btn() -> void:
	pass
	
func _on_move_btn() -> void:
	pass
	
func _on_defend_btn() -> void:
	pass
	
func _on_escape_btn() -> void:
	pass

func tick_combat() -> void:
	weapon_stats_mini.tick_combat()
	
	if B2_Gun.get_current_gun():
		var gun = B2_Gun.get_current_gun() as B2_Weapon
		attack_btn.disabled 	= not gun.is_at_max_action() and gun.has_ammo()
		skill_btn.disabled 		= not gun.is_at_max_action() and gun.has_ammo()
	move_btn.disabled 		= not B2_Playerdata.player_stats.is_at_max_action()
	defend_btn.disabled 	= not B2_Playerdata.player_stats.is_at_max_action()
