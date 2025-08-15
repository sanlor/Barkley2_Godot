extends B2_HudCombat
#extends Node

enum { NOTHING, PLAYER_AIMING, PLAYER_MOVING, PLAYER_SELECTING_SOMETHING, PLAYER_AIMING_SKILL, } ## What is the player doing?
var curr_action := NOTHING

signal selected_enemy( enemy : B2_EnemyCombatActor )
signal weapon_selected
signal battle_results_finished

@onready var mini_tutorial: RichTextLabel = $"../mini_tutorial"

@onready var attack_btn: TextureButton = $attack_btn
@onready var item_btn: TextureButton = $item_btn
@onready var escape_btn: TextureButton = $escape_btn
@onready var defend_btn: TextureButton = $defend_btn
@onready var move_btn: TextureButton = $move_btn

@onready var weapon_stats_mini: 	VBoxContainer = $weapon_stats_mini

@onready var battle_results: 	NinePatchRect = $"../battle_results"

var player_character 	: B2_Player_TurnBased						## In this game, only one player character exists. 
var enemy_list 			: Array[B2_EnemyCombatActor] 	= [] 		## List of all active enemies

var aiming_angle 		:= Vector2.RIGHT
var enemy_selected		:= 0 :
	set(e):
		enemy_selected = wrapi( e, 0, enemy_list.size() ) ## Avoid OOB errors

var roll_power				:= 0.35
var process_player_inputs 	:= true
var battle_tween 			: Tween

func _ready() -> void:
	attack_btn.pressed.connect( 	_on_attack_btn )
	item_btn.pressed.connect( 		_on_item_btn )
	escape_btn.pressed.connect( 	_on_escape_btn )
	move_btn.pressed.connect( 		_on_move_btn )
	defend_btn.pressed.connect( 	_on_defend_btn )

## Resume battle after an attack only if the player is doing nothing
func can_resume_combat() -> bool:
	return curr_action == NOTHING

func register_player( player : B2_Player_TurnBased ) -> void:
	player_character = player
	
## Add enemies to an Array
func register_enemies( _enemy_list ) -> void:
	enemy_list = _enemy_list
	

func _on_attack_btn() -> void:
	B2_CombatManager.pause_combat()
	
	## Disabled 22/04/25
	if B2_Gun.get_current_gun():
		# Set the current gun and aim at the first enemy on the list.
		enemy_selected = enemy_selected # seems stupid, but this is important. avoid OOB array issues when enemies are removed/defeated.
		aiming_angle = ( Vector2(0,-16) + player_character.position ).direction_to( enemy_list[ enemy_selected ].position ) 
		player_character.aim_gun( aiming_angle )
	
	mini_tutorial.text = "Select Enemy [color=yellow]Left[/color] or [color=yellow]Right[/color].
Free aim [color=yellow]Up[/color] or [color=yellow]Down[/color].
Shoot or roll with [color=yellow]Action[/color].
Cancel with [color=yellow]Cancel[/color]."
	
	hide()
	curr_action = PLAYER_AIMING
	slow_time()
	
func _on_item_btn() -> void:
	print("o_hud_minimal: action disabled during tutorial.")
	
func _on_move_btn() -> void:
	B2_CombatManager.pause_combat()
	
	enemy_selected = enemy_selected # seems stupid, but this is important. avoid OOB array issues when enemies are removed/defeated.
	aiming_angle = ( Vector2(0,-16) + player_character.position ).direction_to( enemy_list[ enemy_selected ].position )
	
	player_character.point_at( aiming_angle, roll_power )
	
	mini_tutorial.text = "	Choose roll direction with [color=yellow]Left[/color] or [color=yellow]Right[/color].
Choose roll speed with [color=yellow]Up[/color] or [color=yellow]Down[/color].
Roll with [color=yellow]Action[/color].
Cancel with [color=yellow]Cancel[/color]."
	
	hide()
	curr_action = PLAYER_MOVING
	slow_time()
	
func _on_defend_btn() -> void:
	print("o_hud_minimal: action disabled during tutorial.")
	
func _on_escape_btn() -> void:
	print("o_hud_minimal: action disabled during tutorial.")
	
func _input(event: InputEvent) -> void:
	if process_player_inputs:
		
		if event is InputEventKey or event is InputEventMouseButton:
			if event.is_pressed():
				
				## Menu control
				match curr_action:
					PLAYER_AIMING:
						if Input.get_axis("Down", "Up"):
							aiming_angle = aiming_angle.rotated( sign( Input.get_axis("Down", "Up") ) * TAU / 16.0 )
						if Input.get_axis("Left", "Right"):
							enemy_selected += sign( Input.get_axis("Left", "Right") )
							## Vector2(0,-16) is the position for hoopz chest, the center point when aiming.
							aiming_angle = ( Vector2(0,-16) + player_character.position ).direction_to( enemy_list[ enemy_selected ].position ) 
							
						player_character.aim_gun( aiming_angle )
						
						if Input.is_action_pressed("Action"):
							B2_CombatManager.shoot_projectile( 
								player_character, 
								player_character.global_position + player_character.aim_target, 
								#B2_Gun.get_current_gun(), 
								player_character.stop_aiming 
								)
								
							action_queued()
							resume_time()
							print("%s: shoot" % self)
							
						if Input.is_action_pressed("Holster"):
							action_queued()
							player_character.stop_aiming()
							resume_time()
							print("%s: holster" % self)
				
					PLAYER_SELECTING_SOMETHING:
						## on a skill or item menu
						
						if Input.is_action_pressed("Holster"):
							action_queued()
						pass
				
					PLAYER_MOVING:
						if Input.get_axis("Down", "Up"):
							roll_power = clampf( roll_power + 0.1 * sign( Input.get_axis("Down", "Up") ), 0.1, 0.5 ) ## How far can hoopz roll, 0.0 to 1.0
							
						if Input.get_axis("Left", "Right"):
							aiming_angle = aiming_angle.rotated( sign( Input.get_axis("Left", "Right") ) * TAU / 32.0 )
							
						player_character.point_at( aiming_angle, roll_power )
							
						if Input.is_action_pressed("Action"):
							B2_Playerdata.player_stats.reset_action()
							action_queued()
							player_character.stop_pointing()
							player_character.start_rolling( aiming_angle )
							resume_time( 1.0 )
							## TODO Add Rolling
							
						if Input.is_action_pressed("Holster"):
							action_queued()
							player_character.stop_pointing()
							
							print("%s: holster" % self)
					_:
						pass
	
func action_queued() -> void:
	show()
	mini_tutorial.text = "Select an action using the [color=yellow]Hud[/color]
Either [color=yellow]Shoot[/color] or [color=yellow]Roll[/color] when you have enough [color=yellow]Action Points[/color]."

	attack_btn.grab_focus()
	B2_CombatManager.resume_combat()
	curr_action = NOTHING
	
func add_result_message( _msg : String, sfx := "sn_mouse_analoghover01" ) -> void:
	var msg : Dictionary
	msg["msg"] = _msg
	
	if sfx: ## sfx is optional
		msg["sfx"] = sfx
	battle_results.results.append( msg )

## battle ended, show results
func show_battle_results() -> void:
	mini_tutorial.hide()
	process_player_inputs = false ## avoild moving the player when the battle finishes.
	battle_results.show()
	battle_results.display_battle_results()
	
	get_parent().hide_battle_ui()
	await battle_results.battle_results_finished
	
	battle_results_finished.emit()
	
func slow_time( _time := 0.25 ):
	if battle_tween:
		battle_tween.kill()
	battle_tween = create_tween()
	battle_tween.set_ignore_time_scale( true )
	battle_tween.tween_property( Engine, "time_scale", 0.25, _time )
	print_rich("[color=red]Combat Module: Time slowed.[/color]")
	
func resume_time( _time := 0.25 ):
	if battle_tween:
		battle_tween.kill()
	battle_tween = create_tween()
	battle_tween.set_ignore_time_scale( true )
	battle_tween.tween_property( Engine, "time_scale", 1.0, _time )
	print_rich("[color=pink]Combat Module: Time resumed.[/color]")

func tick_combat() -> void:
	weapon_stats_mini.tick_combat()
	if B2_Gun.get_current_gun():
		var gun = B2_Gun.get_current_gun() as B2_Weapon
		attack_btn.disabled 	= not gun.is_at_max_action() and gun.has_ammo()
	else: ## Weird, player has no weapons.
		attack_btn.disabled 	= true
		
	move_btn.disabled 			= not B2_Playerdata.player_stats.is_at_max_action()
	#defend_btn.disabled 		= not B2_Playerdata.player_stats.is_at_max_action()
	#item_btn.disabled 			= not B2_Playerdata.player_stats.is_at_max_action()
	#escape_btn.disabled 		= not B2_Playerdata.player_stats.is_at_max_action()
	
	if move_btn.disabled: 	move_btn.modulate.a = 0.25; 
	else: move_btn.modulate.a 	= 1.0
	if defend_btn.disabled: defend_btn.modulate.a = 0.25; 
	else: defend_btn.modulate.a = 1.0
	if item_btn.disabled: 	item_btn.modulate.a = 0.25; 
	else: item_btn.modulate.a 	= 1.0
	if escape_btn.disabled: escape_btn.modulate.a = 0.25; 
	else: escape_btn.modulate.a = 1.0
	if attack_btn.disabled: attack_btn.modulate.a = 0.25; 
	else: attack_btn.modulate.a = 1.0
