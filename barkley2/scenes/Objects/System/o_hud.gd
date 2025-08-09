extends B2_Hud

## DEBUG
var debug_messages := true

## Check o_hud.
# Oh boy... more work.

@onready var hud_bar: 	TextureRect 	= $hud_bar
@onready var hud_tv: 	Control 		= $hud_bar/hud_tv
@onready var hud_dna: 	ColorRect 		= $hud_bar/hud_dna

@onready var hud_glamp: ColorRect = $hud_bar/hud_glamp
@onready var g_letter: TextureRect = $hud_bar/hud_glamp/hud_glamp_container/g_letter
@onready var l_letter: TextureRect = $hud_bar/hud_glamp/hud_glamp_container/l_letter
@onready var a_letter: TextureRect = $hud_bar/hud_glamp/hud_glamp_container/a_letter
@onready var m_letter: TextureRect = $hud_bar/hud_glamp/hud_glamp_container/m_letter
@onready var p_letter: TextureRect = $hud_bar/hud_glamp/hud_glamp_container/p_letter

@onready var hud_gun: ColorRect = $hud_bar/hud_gun
@onready var hud_ammo: ColorRect = $hud_bar/hud_ammo
@onready var hud_weight: ColorRect = $hud_bar/hud_weight
@onready var hud_periodic: ColorRect = $hud_bar/hud_periodic
@onready var hud_pockets: Control = $hud_bar/hud_pockets
@onready var hud_marquee_text: RichTextLabel = $hud_bar/hud_marquee/hud_marquee_text
@onready var hud_wifi: ColorRect = $hud_bar/hud_wifi

## Ammo
@onready var hud_gun_bag: 		TextureRect = 	$hud_bar/hud_gun/hud_gun_bag
@onready var hud_gun_sprite: 	TextureRect = 	$hud_bar/hud_gun/hud_gun_sprite
@onready var hud_ammo_amount: 	Label = 		$hud_bar/hud_ammo/hud_ammo_amount

## Combat
## New Menu
@onready var player_controls_new: Control = $combat_module/player_controls_new
@onready var item_and_skill_list: Control = $combat_module/item_and_skill_list

## Old Menu
@onready var player_control_weapons: B2_Border = $combat_module/player_control_weapons
@onready var player_control_move: B2_Border = $combat_module/player_control_move
@onready var player_control_defend: B2_Border = $combat_module/player_control_defend

@onready var weapon_stats_mini: VBoxContainer = $combat_module/weapon_stats_mini

@onready var player_controls: 	B2_Border = $player_controls ## PLACEHOLDER
@onready var combat_module: 	B2_HudCombat = $combat_module

@export var is_hud_visible := true

## Anim
var tween : Tween
var c_tween : Tween ## Tween used only for the combat UI.
var gun_hud_tween : Tween
var wait_anim := true
signal event_finished

const SHOWN_Y 	:= 200.0
const HIDDEN_Y 	:= 241.0

var hudDrawCount := 0

## gun ammo hud
var pulse 				:= 0.0
var t					:= 0.0
var gun_hud_intensity 	:= 1.0
var prev_gun			: B2_Weapon

## Combat stuff
const combat_fade_speed := 0.25

func _ready() -> void:
	if debug_messages: print("o_hud: debug messages is ON.")
	layer = B2_Config.HUD_LAYER
	B2_CManager.o_hud = self
	hud_bar.texture.region.position = Vector2( 0, 0 )
	
	_change_visibility()
		
	B2_SignalBus.quest_updated.connect( _change_visibility )
	B2_SignalBus.gun_changed.connect( _flash_hud )
	
	if is_hud_visible: 	hud_bar.position.y = SHOWN_Y
	else: 				hud_bar.position.y = HIDDEN_Y
	hud_tv.change_tv_face()
	
	## Hide Combat UI
	player_control_weapons.hide()
	player_control_move.hide()
	player_control_defend.hide()
	player_controls.hide()
	weapon_stats_mini.hide()
	item_and_skill_list.hide()
	player_control_weapons.modulate.a 	= 0.0
	player_control_move.modulate.a 		= 0.0
	player_control_defend.modulate.a 	= 0.0
	player_controls.modulate.a 			= 0.0
	weapon_stats_mini.modulate.a 		= 0.0
	item_and_skill_list.modulate.a 		= 0.0
	
func get_combat_module() -> B2_HudCombat:
	return combat_module
	
func _change_visibility() -> void:
	if B2_Playerdata.Quest("hudVisible") == 0:
		is_hud_visible = false
	
func show_hud() -> void:
	if not visible:
		show()
	if is_instance_valid(tween):
		tween.kill()
	tween = create_tween()
	tween.tween_property( hud_bar, "position:y", SHOWN_Y, 0.05 )
	tween.tween_callback( event_finished.emit )
	if debug_messages: print("o_hud: show_hud()")
	
func hide_hud() -> void:
	if is_instance_valid(tween):
		tween.kill()
	tween = create_tween()
	tween.tween_property( hud_bar, "position:y", HIDDEN_Y, 0.05 )
	tween.tween_callback( event_finished.emit )
	if debug_messages: print("o_hud: hide_hud()")

func fade_in( element ) -> void:
	if is_instance_valid(tween):
		if tween.is_running():
			await tween.finished
		tween.kill()
	tween = create_tween()
	tween.tween_property( element, "modulate:a", 1.0, 0.5 )
	tween.tween_interval( 0.2 )
	tween.tween_callback( event_finished.emit )

## Used during the intro
func execute_event_user_0() -> void:
	# Hide the current hud
	hide_hud()
	if debug_messages: print("o_hud: execute_event_user_0()")

## Used during the intro
func execute_event_user_1() -> void:
	# show naked hud during tutorial
	show_hud()
	if debug_messages: print("o_hud: execute_event_user_1()")

## Used during the intro
func execute_event_user_2() -> void:
	# hide hud_elements
	hudDrawCount = 0
	hud_bar.texture.region.position = Vector2( 384, 0 )
	hud_dna.modulate.a 		= 0.0
	hud_glamp.modulate.a 	= 0.0
	l_letter.modulate.a 	= 0.0
	a_letter.modulate.a 	= 0.0
	m_letter.modulate.a 	= 0.0
	p_letter.modulate.a 	= 0.0
	hud_gun.modulate.a 		= 0.0
	hud_weight.modulate.a 	= 0.0
	hud_ammo.modulate.a 	= 0.0
	hud_periodic.modulate.a 		= 0.0
	hud_pockets.modulate.a 			= 0.0
	hud_marquee_text.modulate.a 	= 0.0
	hud_wifi.modulate.a 			= 0.0
	await get_tree().process_frame
	event_finished.emit()

## Used during the intro
func execute_event_user_3() -> void:
	## Used during the tutorial scene.
	# Gradually show each hud element
	if hudDrawCount == 0: fade_in( hud_dna )
	elif hudDrawCount == 1: fade_in( hud_glamp )
	elif hudDrawCount == 2: fade_in( l_letter )
	elif hudDrawCount == 3: fade_in( a_letter )
	elif hudDrawCount == 4: fade_in( m_letter )
	elif hudDrawCount == 5: fade_in( p_letter )
	elif hudDrawCount == 6: fade_in( hud_gun )
	elif hudDrawCount == 7: fade_in( hud_ammo ); fade_in( hud_weight );
	elif hudDrawCount == 8: fade_in( hud_periodic )
	elif hudDrawCount == 9: fade_in( hud_pockets )
	elif hudDrawCount == 10: hud_bar.texture.region.position = Vector2( 0, 0 ); fade_in( hud_marquee_text )
	elif hudDrawCount == 11: fade_in( hud_wifi )
	else: ## Catch all
		await get_tree().process_frame
		event_finished.emit()
	hudDrawCount += 1
	
func show_battle_ui() -> void:
	if c_tween:
		c_tween.kill()
	c_tween = create_tween()
	c_tween.set_parallel(true)
	c_tween.tween_callback( player_control_weapons.show )
	c_tween.tween_callback( player_control_move.show )
	c_tween.tween_callback( player_control_defend.show )
	c_tween.tween_callback( player_controls.show )
	c_tween.tween_callback( weapon_stats_mini.show )
	c_tween.tween_callback( item_and_skill_list.show )
	
	c_tween.tween_property(player_control_weapons, 	"modulate:a", 1.0, combat_fade_speed)
	c_tween.tween_property(player_control_move, 	"modulate:a", 1.0, combat_fade_speed)
	c_tween.tween_property(player_control_defend, 	"modulate:a", 1.0, combat_fade_speed)
	c_tween.tween_property(player_controls, 		"modulate:a", 1.0, combat_fade_speed)
	c_tween.tween_property(weapon_stats_mini, 		"modulate:a", 1.0, combat_fade_speed)
	c_tween.tween_property(item_and_skill_list, 	"modulate:a", 1.0, combat_fade_speed)
	
	player_controls_new.show_menu()
	
func hide_battle_ui() -> void:
	if c_tween:
		c_tween.kill()
	c_tween = create_tween()
	c_tween.set_parallel(true)
	c_tween.tween_property(player_control_weapons, 	"modulate:a", 0.0, combat_fade_speed)
	c_tween.tween_property(player_control_move, 	"modulate:a", 0.0, combat_fade_speed)
	c_tween.tween_property(player_control_defend, 	"modulate:a", 0.0, combat_fade_speed)
	c_tween.tween_property(player_controls, 		"modulate:a", 0.0, combat_fade_speed)
	c_tween.tween_property(weapon_stats_mini, 		"modulate:a", 0.0, combat_fade_speed)
	c_tween.tween_property(item_and_skill_list, 	"modulate:a", 0.0, combat_fade_speed)
	
	c_tween.set_parallel(false)
	c_tween.tween_callback( player_control_weapons.hide )
	c_tween.tween_callback( player_control_move.hide )
	c_tween.tween_callback( player_control_defend.hide )
	c_tween.tween_callback( player_controls.hide )
	c_tween.tween_callback( weapon_stats_mini.hide )
	c_tween.tween_callback( item_and_skill_list.hide )
	combat_module.reset()
	player_controls_new.hide_menu()
	
func set_ammo_amt( amt : int ):
	t += 0.1
	pulse = ( sin( t ) / 2.0) ## 0.0 to 0.5
	
	hud_ammo_amount.text = str( clampi(amt, 0, 9999) )
	
	if amt > 0:
		hud_ammo_amount.modulate = Color("87d2be")
		hud_ammo_amount.modulate.a = 0.5
	else:
		hud_ammo_amount.modulate = Color.RED
		hud_ammo_amount.modulate.a = pulse

func _flash_hud() -> void:
	hud_gun.intensity = 1.85
	gun_hud_intensity = 4.0
	if gun_hud_tween: gun_hud_tween.kill()
	gun_hud_tween = create_tween()
	gun_hud_tween.set_parallel( true )
	gun_hud_tween.tween_property( hud_gun, "intensity", 		1.0, 0.5 )
	gun_hud_tween.tween_property( self, "gun_hud_intensity", 	1.0, 0.5 )

func _physics_process(_delta: float) -> void:
	hud_gun_bag.visible = B2_Playerdata.gunbag_open
	
	var curr_wpn = B2_Gun.get_current_gun()
	if curr_wpn and B2_Gun.has_any_guns():
		# update the gun hud texture
		if curr_wpn != prev_gun or not hud_gun_sprite.texture:
			hud_gun_sprite.texture = curr_wpn.get_weapon_hud_sprite()
			prev_gun = curr_wpn
		set_ammo_amt( curr_wpn.curr_ammo )
	else:
		hud_gun_sprite.texture = null
		set_ammo_amt( 0 )
		
	hud_gun_sprite.modulate = Color.WHITE * gun_hud_intensity
	
	if not B2_Playerdata.is_holding_gun:		hud_gun_sprite.modulate.a 	= 0.55
	else:										hud_gun_sprite.modulate.a 	= 0.85
	
	hud_gun.queue_redraw()
