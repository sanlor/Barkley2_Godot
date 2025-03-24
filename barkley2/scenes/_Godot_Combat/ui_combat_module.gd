extends Control
class_name B2_HudCombat

const MENU_WPN_DATA = preload("uid://cnkroip8gbsn1")

enum { NOTHING, PLAYER_AIMING,PLAYER_SELECTING_SOMETHING } ## What is the player doing?
var curr_action := NOTHING

signal selected_enemy( enemy : B2_EnemyCombatActor )
signal weapon_selected

@onready var weapon_stats_mini: VBoxContainer = $weapon_stats_mini

@onready var attack_btn: 	Button = $player_control_weapons/MarginContainer/VBoxContainer/attack_btn
@onready var skill_btn: 	Button = $player_control_weapons/MarginContainer/VBoxContainer/skill_btn
@onready var item_btn: 		Button = $player_control_weapons/MarginContainer/VBoxContainer/item_btn
@onready var escape_btn: 	Button = $player_control_weapons/MarginContainer/VBoxContainer/escape_btn

@onready var move_btn: 		Button = $player_control_move/MarginContainer/move_btn
@onready var defend_btn: 	Button = $player_control_defend/MarginContainer/defend_btn

@onready var player_control_weapons: B2_Border = $player_control_weapons
@onready var player_control_move: B2_Border = $player_control_move
@onready var player_control_defend: B2_Border = $player_control_defend

@onready var instructions: RichTextLabel = $instructions

var player_character 	: B2_HoopzCombatActor						## In this game, only one player character exists. 
var enemy_list 			: Array[B2_EnemyCombatActor] 	= [] 	## List of all active enemies

var aiming_angle 		:= Vector2.RIGHT
var enemy_selected		:= 0 :
	set(e):
		enemy_selected = wrapi( e, 0, enemy_list.size() ) ## Avoid OOB errors

func _ready() -> void:
	instructions.hide()
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

#func _unhandled_key_input(event: InputEvent) -> void:
func _input(event: InputEvent) -> void:
	if event is InputEventKey or event is InputEventMouseButton:
		if event.is_pressed():
			## Menu control
			if curr_action == PLAYER_AIMING:
				if Input.get_axis("Down", "Up"):
					aiming_angle = aiming_angle.rotated( sign( Input.get_axis("Down", "Up") ) * PI / 32.0 )
				if Input.get_axis("Left", "Right"):
					enemy_selected += sign( Input.get_axis("Left", "Right") )
					## Vector2(0,-16) is the position for hoopz chest, the center point when aiming.
					aiming_angle = ( Vector2(0,-16) + player_character.position ).direction_to( enemy_list[ enemy_selected ].position ) 
					
				player_character.aim_gun( aiming_angle )
				
				if event.is_action_pressed("Action"):
					#player_character.shoot_gun()
					var combat_manager := B2_CManager.combat_manager
					combat_manager.shoot_projectile( player_character, B2_Gun.get_current_gun(), player_character.stop_aiming )
					action_queued()
					print("%s: shoot" % self)
					
				if event.is_action_pressed("Holster"):
					action_queued()
					player_character.stop_aiming()
					print("%s: holster" % self)
			
		elif curr_action == PLAYER_SELECTING_SOMETHING:
			pass
		else:
			pass

func action_queued() -> void:
	player_control_weapons.show()
	player_control_move.show()
	player_control_defend.show()
	instructions.hide()
	B2_CManager.combat_manager.resume_combat()
	curr_action = NOTHING

func _on_attack_btn() -> void:
	B2_CManager.combat_manager.pause_combat()
	
	if B2_Gun.get_current_gun():
		# Set the current gun and aim at the first enemy on the list.
		player_character.aim_gun( ( Vector2(0,-16) + player_character.position ).direction_to( enemy_list[ enemy_selected ].position )  )
		
	player_control_weapons.hide()
	player_control_move.hide()
	player_control_defend.hide()
	instructions.show()
	curr_action = PLAYER_AIMING
	
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
