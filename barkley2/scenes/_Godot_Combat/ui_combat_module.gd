extends Control
class_name B2_HudCombat

const MENU_WPN_DATA = preload("uid://cnkroip8gbsn1")

enum { NOTHING, PLAYER_AIMING,PLAYER_SELECTING_SOMETHING } ## What is the player doing?
var curr_action := NOTHING

signal selected_enemy( enemy : B2_EnemyCombatActor )
signal weapon_selected

var player_character 	: B2_HoopzCombatActor						## In this game, only one player character exists. 
var enemy_list 			: Array[B2_EnemyCombatActor] 	= [] 	## List of all active enemies

var aiming_angle 		:= Vector2.RIGHT
var enemy_selected		:= 0 :
	set(e):
		enemy_selected = wrapi( e, 0, enemy_list.size() ) ## Avoid OOB errors

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
					aiming_angle = ( Vector2(0,-16) + player_character.position ).direction_to( enemy_list[ enemy_selected ].position )
					
				player_character.aim_gun( aiming_angle )
				print("aiming_angle ", aiming_angle)
				
				pass
				if event.is_action_pressed("Action"):
					player_character.shoot_gun()
					print("shoot")
					
				if event.is_action_pressed("Holster"):
					player_control_weapons.show()
					player_control_move.show()
					player_control_defend.show()
					instructions.hide()
					player_character.stop_aiming()
					B2_CManager.combat_manager.resume_combat()
					curr_action = NOTHING
					print("holster")
				
			#print(enemy_selected)
			#print(aiming_angle)
			
		elif curr_action == PLAYER_SELECTING_SOMETHING:
			pass
		else:
			pass
			
		if Input.is_key_pressed(KEY_1):
			player_character.aim_gun( enemy_list.pick_random().position )

func _on_attack_btn() -> void:
	B2_CManager.combat_manager.pause_combat()
	
	if B2_Gun.get_current_gun():
		player_character.set_gun( B2_Gun.get_current_gun().get_held_sprite(), B2_Gun.get_current_gun().weapon_type )
		player_character.aim_gun( enemy_list.front().position )
		
	player_control_weapons.hide()
	player_control_move.hide()
	player_control_defend.hide()
	instructions.show()
	curr_action = PLAYER_AIMING
	
	### DEBUG
	#if B2_Gun.get_current_gun():
		#var gun = B2_Gun.get_current_gun() as B2_Weapon
		#gun.use_ammo( 15 )
		#gun.reset_action()
		#player_character.set_gun( B2_Gun.get_current_gun().get_held_sprite(), B2_Gun.get_current_gun().weapon_type )
		#await get_tree().process_frame
		#player_character.aim_gun( enemy_list.front().position )
	
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
