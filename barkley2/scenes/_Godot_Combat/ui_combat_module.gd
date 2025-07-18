extends B2_HudCombat

const MENU_WPN_DATA = preload("uid://cnkroip8gbsn1")

enum { NOTHING, PLAYER_AIMING, PLAYER_MOVING, PLAYER_SELECTING_SOMETHING, PLAYER_AIMING_SKILL, } ## What is the player doing?
var curr_action := NOTHING

signal selected_enemy( enemy : B2_EnemyCombatActor )
signal weapon_selected
signal battle_results_finished

@onready var o_hud: 				B2_Hud = $".."
@onready var fade: 					ColorRect = $"../fade"
@onready var weapon_stats_mini: 	VBoxContainer = $weapon_stats_mini

## Old menu
@onready var player_control_weapons: 	B2_Border = $player_control_weapons
@onready var player_control_move: 		B2_Border = $player_control_move
@onready var player_control_defend: 	B2_Border = $player_control_defend
#@onready var attack_btn: 				Button = $player_control_weapons/MarginContainer/VBoxContainer/attack_btn
#@onready var skill_btn: 				Button = $player_control_weapons/MarginContainer/VBoxContainer/skill_btn
#@onready var item_btn: 				Button = $player_control_weapons/MarginContainer/VBoxContainer/item_btn
#@onready var escape_btn: 				Button = $player_control_weapons/MarginContainer/VBoxContainer/escape_btn
#@onready var move_btn: 				Button = $player_control_move/MarginContainer/move_btn
#@onready var defend_btn: 				Button = $player_control_defend/MarginContainer/defend_btn

## New cool menu
@onready var player_controls_new: 	Control = $player_controls_new
@onready var defend_btn: 			Button = $player_controls_new/menu_space/defend_btn
@onready var attack_btn: 			Button = $player_controls_new/menu_space/ScrollContainer/VBoxContainer/attack_btn
@onready var skill_btn: 			Button = $player_controls_new/menu_space/ScrollContainer/VBoxContainer/skill_btn
@onready var item_btn: 				Button = $player_controls_new/menu_space/ScrollContainer/VBoxContainer/item_btn
@onready var escape_btn: 			Button = $player_controls_new/menu_space/ScrollContainer/VBoxContainer/escape_btn
@onready var move_btn: 				Button = $player_controls_new/menu_space/move_btn
@onready var button_list_1 := [defend_btn,attack_btn,skill_btn,item_btn,escape_btn,move_btn] ## main battle UI buttons

## Item and skill
@onready var item_and_skill_list: Control = $item_and_skill_list

## Fluff
@onready var instructions: RichTextLabel = $instructions
@onready var slowdown_label: Label = $slowdown_label

@onready var battle_results: Control = $battle_results

var player_character 	: B2_HoopzCombatActor						## In this game, only one player character exists. 
var enemy_list 			: Array[B2_EnemyCombatActor] 	= [] 	## List of all active enemies

var aiming_angle 		:= Vector2.RIGHT
var enemy_selected		:= 0 :
	set(e):
		enemy_selected = wrapi( e, 0, enemy_list.size() ) ## Avoid OOB errors
var roll_power			:= 1.0

var process_player_inputs := true

var battle_tween : Tween

var selected_skill : B2_WeaponSkill

## Resume battle after an attack only if the player is doing nothing
func can_resume_combat() -> bool:
	return curr_action == NOTHING

func _ready() -> void:
	instructions.hide()
	slowdown_label.hide()
	item_and_skill_list.hide()
	player_controls_new.hide()
	
	attack_btn.pressed.connect( 	_on_attack_btn )
	skill_btn.pressed.connect( 		_on_skill_btn )
	item_btn.pressed.connect( 		_on_item_btn )
	escape_btn.pressed.connect( 	_on_escape_btn )
	move_btn.pressed.connect( 		_on_move_btn )
	defend_btn.pressed.connect( 	_on_defend_btn )
	B2_CManager.hoopz_got_hit.connect( _cancel_action )
	
# Is this needed?
func register_player( player : B2_HoopzCombatActor ) -> void:
	player_character = player
	
## Add enemies to an Array
func register_enemies( _enemy_list ) -> void:
	enemy_list = _enemy_list

## Check if any UI element has input focus.
func focus_check():
	match curr_action:
		NOTHING:
			#var focus := false
			var candidates : Array[Button] = []
			for b : Button in button_list_1:
				if b.has_focus():
					return
				elif not b.disabled:
					candidates.append( b )
				else:
					pass ## button is disabled and not in focus.
					
			if candidates:
				candidates.front().grab_focus()
			else:
				pass # nothing is avaiable to focus on.

#func _unhandled_key_input(event: InputEvent) -> void:
func _input(event: InputEvent) -> void:
	if process_player_inputs:
		
		if event is InputEventKey or event is InputEventMouseButton:
			if event.is_pressed():
				focus_check()
				
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
						
						if Input.is_action_just_pressed("Action"):
							#player_character.shoot_gun()
							var combat_manager := B2_CManager.combat_manager
							combat_manager.shoot_projectile( 
								player_character, 
								player_character.global_position + player_character.aim_target, 
								B2_Gun.get_current_gun(), 
								player_character.stop_aiming 
								)
								
							action_queued()
							print("%s: shoot" % self)
							
						if Input.is_action_just_pressed("Holster"):
							player_character.stop_aiming()
							action_queued()
							print("%s: holster" % self)
				
					PLAYER_SELECTING_SOMETHING:
						## on a skill or item menu
						
						if Input.is_action_just_pressed("Holster"):
							action_queued()
						pass
				
					PLAYER_MOVING:
						if Input.get_axis("Down", "Up"):
							roll_power = clampf( roll_power + 0.1 * sign( Input.get_axis("Down", "Up") ), 0.1, 1.0 ) ## How far can hoopz roll, 0.0 to 1.0
							
						if Input.get_axis("Left", "Right"):
							aiming_angle = aiming_angle.rotated( sign( Input.get_axis("Left", "Right") ) * TAU / 32.0 )
							
						player_character.point_at( aiming_angle, roll_power )
							
						if Input.is_action_just_pressed("Action"):
							B2_Playerdata.player_stats.reset_action()
							action_queued()
							player_character.stop_pointing()
							player_character.start_rolling( aiming_angle )
							## TODO Add Rolling <- Done
							
						if Input.is_action_just_pressed("Holster"):
							player_character.stop_pointing()
							action_queued()
							print("%s: holster" % self)
					
					PLAYER_AIMING_SKILL:
						if Input.get_axis("Down", "Up"):
							aiming_angle = aiming_angle.rotated( sign( Input.get_axis("Down", "Up") ) * TAU / 16.0 )
						if Input.get_axis("Left", "Right"):
							enemy_selected += sign( Input.get_axis("Left", "Right") )
							## Vector2(0,-16) is the position for hoopz chest, the center point when aiming.
							aiming_angle = ( Vector2(0,-16) + player_character.position ).direction_to( enemy_list[ enemy_selected ].position ) 
							
						player_character.aim_gun( aiming_angle )
						
						if Input.is_action_just_pressed("Action"):
							use_skill( selected_skill )
							action_queued()
						
						if Input.is_action_just_pressed("Holster"):
							player_character.stop_aiming()
							action_queued()
					_:
						pass

func _cancel_action():
	if curr_action != NOTHING:
		if curr_action == PLAYER_MOVING:
			player_character.stop_pointing()
		if curr_action == PLAYER_AIMING or curr_action == PLAYER_AIMING_SKILL:
			player_character.stop_aiming()
		
		action_queued()

func slow_time( _time := 0.25 ):
	slowdown_label.modulate.a = 0.0
	if battle_tween:
		battle_tween.kill()
	battle_tween = create_tween()
	battle_tween.set_ignore_time_scale( true )
	#battle_tween.set_parallel( true )
	battle_tween.tween_callback(slowdown_label.show)
	battle_tween.tween_property(slowdown_label, "modulate:a", 1.0, 0.25)
	battle_tween.tween_property( Engine, "time_scale", 0.25, _time )
	print_rich("[color=red]Combat Module: Time slowed.[/color]")
	
func resume_time( _time := 0.25 ):
	if battle_tween:
		battle_tween.kill()
	battle_tween = create_tween()
	battle_tween.set_ignore_time_scale( true )
	battle_tween.tween_property( Engine, "time_scale", 1.0, _time )
	battle_tween.tween_property(slowdown_label, "modulate:a", 0.0, 0.25)
	battle_tween.tween_callback(slowdown_label.hide)
	print_rich("[color=pink]Combat Module: Time resumed.[/color]")

func action_queued() -> void:
	player_controls_new.show_menu()
	player_control_weapons.show()
	player_control_move.show()
	player_control_defend.show()
	weapon_stats_mini.show()
	
	item_and_skill_list.hide_menu()
	instructions.hide()
	resume_time()
	B2_CManager.combat_manager.resume_combat()
	B2_CManager.combat_manager.can_manipulate_camera = true
	curr_action = NOTHING

func reset() -> void:
	process_player_inputs = true
	instructions.hide()
	curr_action = NOTHING
	resume_time(0.0)
	#B2_CManager.combat_manager.resume_combat() <- Causes an infinite loop
	#action_queued() <- Causes an infinite loop

## Use an item. duh.
func use_item( slot : int ) -> void:
	B2_Jerkin.use_pocket_content( slot )
	B2_Sound.play( "sn_shekeltally01" )
	B2_Playerdata.player_stats.reset_action()
	action_queued()
	resume_time()
	
## Player selected an skill from the list. Need to aim it before use.
func select_skill( skill : B2_WeaponSkill ) -> void:
	if enemy_list.is_empty():
		push_error("Trying to attack when the battle is over. This should not happen.")
		return
		
	if B2_Gun.get_current_gun():
		# Set the current gun and aim at the first enemy on the list.
		enemy_selected = enemy_selected # seems stupid, but this is important. avoid OOB array issues when enemies are removed/defeated.
		aiming_angle = ( Vector2(0,-16) + player_character.position ).direction_to( enemy_list[ enemy_selected ].position ) 
		player_character.aim_gun( aiming_angle )
		
	item_and_skill_list.hide_menu()
	instructions.show()
	selected_skill = skill
	curr_action = PLAYER_AIMING_SKILL

## Player aimed the skill, use it.
func use_skill( skill : B2_WeaponSkill ) -> void:
	if enemy_list.is_empty():
		push_error("Trying to attack when the battle is over. This should not happen.")
		return
		
	var combat_manager := B2_CManager.combat_manager
	combat_manager.use_skill( 
		player_character, 
		player_character.global_position + player_character.aim_target, 
		B2_Gun.get_current_gun(), 
		skill,
		player_character.stop_aiming 
		)

func _on_attack_btn() -> void:
	if enemy_list.is_empty():
		push_error("Trying to attack when the battle is over. This should not happen.")
		return
		
	B2_CManager.combat_manager.pause_combat()
	await get_tree().process_frame ## Wait to avoid triggering multiple states (pressing a button and executing the action at the same time)
		
	## Disabled 22/04/25
	if B2_Gun.get_current_gun():
		# Set the current gun and aim at the first enemy on the list.
		enemy_selected = enemy_selected # seems stupid, but this is important. avoid OOB array issues when enemies are removed/defeated.
		aiming_angle = ( Vector2(0,-16) + player_character.position ).direction_to( enemy_list[ enemy_selected ].position ) 
		player_character.aim_gun( aiming_angle )
		
	player_controls_new.hide_menu()
	
	player_control_weapons.hide()
	player_control_move.hide()
	player_control_defend.hide()
	instructions.show()
	curr_action = PLAYER_AIMING
	slow_time()
	
func _on_skill_btn() -> void:
	B2_CManager.combat_manager.pause_combat()
	await get_tree().process_frame ## Wait to avoid triggering multiple states (pressing a button and executing the action at the same time)
	
	item_and_skill_list.show_skill_menu()
	
	player_controls_new.hide_menu()
	
	weapon_stats_mini.hide()
	player_control_weapons.hide()
	player_control_move.hide()
	player_control_defend.hide()
	curr_action = PLAYER_SELECTING_SOMETHING
	slow_time()
	
func _on_item_btn() -> void:
	B2_CManager.combat_manager.pause_combat()
	await get_tree().process_frame ## Wait to avoid triggering multiple states (pressing a button and executing the action at the same time)
	
	item_and_skill_list.show_item_menu()
	
	player_controls_new.hide_menu()
	
	weapon_stats_mini.hide()
	player_control_weapons.hide()
	player_control_move.hide()
	player_control_defend.hide()
	curr_action = PLAYER_SELECTING_SOMETHING
	slow_time()
	
func _on_move_btn() -> void:
	B2_CManager.combat_manager.pause_combat()
	await get_tree().process_frame ## Wait to avoid triggering multiple states (pressing a button and executing the action at the same time)
	
	B2_CManager.combat_manager.can_manipulate_camera = false
	B2_CManager.camera.combat_focus( player_character.global_position, 1.0 )
	player_character.point_at( aiming_angle, roll_power )
		
	player_controls_new.hide_menu()
		
	player_control_weapons.hide()
	player_control_move.hide()
	player_control_defend.hide()
	instructions.show()
	curr_action = PLAYER_MOVING
	slow_time()
	
func _on_defend_btn() -> void:
	await get_tree().process_frame ## Wait to avoid triggering multiple states (pressing a button and executing the action at the same time)
	
	if player_character.curr_STATE == player_character.STATE.DEFENDING:
		player_character.stop_defending()
	else:
		player_character.start_defending( aiming_angle )
	B2_Playerdata.player_stats.reset_action()
	
func _on_escape_btn() -> void:
	await get_tree().process_frame ## Wait to avoid triggering multiple states (pressing a button and executing the action at the same time)
	B2_Playerdata.player_stats.reset_action()
	for w in B2_Gun.get_bandolier():
			w.reset_action()
	if player_character.curr_STATE == player_character.STATE.DEFENDING:
			player_character.stop_defending()
			
	if randi_range(0,9) > 9: ## chances of running from battle.
		push_error("ESCAPE DEBUG - FIX THIS")
		## Escape failed, reset action for everything.
		print("Failed to escape Battle.")
		B2_Sound.play("sn_cursor_error01")
		var msg := ["Failed...", "Borked it...", "Too Slow...", "Wasnt able to..."]
		B2_Screen.display_damage_number( player_character, msg.pick_random(), Color.RED, 4.0 )
	else:
		## Escaped battle, you pussy.
		print("Escaped Battle.")
		darken_screen()

func darken_screen() -> void:
	var tween := create_tween()
	fade.show()
	fade.modulate = Color.TRANSPARENT
	tween.tween_callback( B2_CManager.combat_manager.pause_combat )
	tween.tween_callback( o_hud.hide_battle_ui )
	tween.tween_property( fade, "modulate", Color.WHITE, 1.0 )
	tween.tween_callback( B2_CManager.combat_manager.escape_combat )
	tween.tween_interval( 0.5 )
	tween.tween_property( fade, "modulate", Color.TRANSPARENT, 1.0 )
	tween.tween_callback( fade.hide )
	tween.tween_interval( 0.5 )
	#tween.tween_callback( B2_CManager.combat_manager.resume_combat )
	tween.tween_callback( B2_CManager.combat_manager.finish_combat )
	await tween.finished

func add_result_message( _msg : String, sfx := "" ) -> void:
	var msg : Dictionary
	msg["msg"] = _msg
	
	if sfx: ## sfx is optional
		msg["sfx"] = sfx
	battle_results.results.append( msg )

## battle ended, show results
func show_battle_results() -> void:
	process_player_inputs = false ## avoid moving the player when the battle finishes.
	battle_results.display_battle_results()
	
	o_hud.hide_battle_ui()
	await battle_results.battle_results_finished
	
	battle_results_finished.emit()

func tick_combat() -> void:
	weapon_stats_mini.tick_combat()
	if B2_Gun.get_current_gun():
		var gun = B2_Gun.get_current_gun() as B2_Weapon
		attack_btn.disabled 	= not ( gun.is_at_max_action() and gun.has_ammo() )
		skill_btn.disabled 		= not ( gun.is_at_max_action() and gun.has_ammo() )
	else: ## Weird, player has no weapons.
		attack_btn.disabled 	= true
		skill_btn.disabled 		= true
		
	move_btn.disabled 			= not B2_Playerdata.player_stats.is_at_max_action()
	defend_btn.disabled 		= not ( B2_Playerdata.player_stats.is_at_max_action() and B2_Playerdata.Quest("hoopz_shield") 		!= 0 ) ## Only use shied if you have shield.
	item_btn.disabled 			= not B2_Playerdata.player_stats.is_at_max_action()
	escape_btn.disabled 		= not ( B2_Playerdata.player_stats.is_at_max_action() and B2_Playerdata.Quest("escape_disabled") 	== 0 ) ## in certain situations, escape can be disabled.

func _physics_process(_delta: float) -> void:
	if slowdown_label.visible:
		slowdown_label.text = Text.pr("Slowdown: %sx" % str(Engine.time_scale).pad_decimals(2) )
	pass
