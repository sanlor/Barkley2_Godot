extends CanvasLayer
class_name B2_Hud

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
@onready var hud_marquee_text: Label = $hud_bar/hud_marquee/hud_marquee_text
@onready var hud_wifi: ColorRect = $hud_bar/hud_wifi

## Ammo
@onready var hud_ammo_amount: Label = $hud_bar/hud_ammo/hud_ammo_amount

## Combat
@onready var player_control_weapons: B2_Border = $combat_module/player_control_weapons
@onready var player_control_move: B2_Border = $combat_module/player_control_move
@onready var player_control_defend: B2_Border = $combat_module/player_control_defend
@onready var weapon_stats: B2_Border = $combat_module/weapon_stats

@onready var player_controls: B2_Border = $player_controls ## PLACEHOLDER


@export var is_hud_visible := true

## Anim
var tween : Tween
var c_tween : Tween ## Tween used only for the combat UI.
var wait_anim := true
signal event_finished

const SHOWN_Y 	:= 200.0
const HIDDEN_Y 	:= 241.0

var hudDrawCount := 0

## Combat stuff
const combat_fade_speed := 0.25

func _ready() -> void:
	if debug_messages: print("o_hud: debug messages is ON.")
	layer = B2_Config.HUD_LAYER
	B2_CManager.o_hud = self
	hud_bar.texture.region.position = Vector2( 0, 0 )
	
	_change_visibility()
		
	B2_Playerdata.quest_updated.connect( _change_visibility )
		
	if is_hud_visible: 	hud_bar.position.y = SHOWN_Y
	else: 				hud_bar.position.y = HIDDEN_Y
	hud_tv.change_tv_face()
	
	## Hide Combat UI
	player_control_weapons.hide()
	player_control_move.hide()
	player_control_defend.hide()
	weapon_stats.hide()
	player_controls.hide()
	player_control_weapons.modulate.a 	= 0.0
	player_control_move.modulate.a 		= 0.0
	player_control_defend.modulate.a 	= 0.0
	weapon_stats.modulate.a 			= 0.0
	player_controls.modulate.a 			= 0.0
	
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
	c_tween.tween_callback( weapon_stats.show )
	c_tween.tween_callback( player_controls.show )
	c_tween.tween_property(player_control_weapons, 	"modulate:a", 1.0, combat_fade_speed)
	c_tween.tween_property(player_control_move, 	"modulate:a", 1.0, combat_fade_speed)
	c_tween.tween_property(player_control_defend, 	"modulate:a", 1.0, combat_fade_speed)
	c_tween.tween_property(weapon_stats, 			"modulate:a", 1.0, combat_fade_speed)
	c_tween.tween_property(player_controls, 		"modulate:a", 1.0, combat_fade_speed)

func hide_battle_ui() -> void:
	if c_tween:
		c_tween.kill()
	c_tween = create_tween()
	c_tween.set_parallel(true)
	c_tween.tween_property(player_control_weapons, 	"modulate:a", 0.0, combat_fade_speed)
	c_tween.tween_property(player_control_move, 	"modulate:a", 0.0, combat_fade_speed)
	c_tween.tween_property(player_control_defend, 	"modulate:a", 0.0, combat_fade_speed)
	c_tween.tween_property(weapon_stats, 			"modulate:a", 0.0, combat_fade_speed)
	c_tween.tween_property(player_controls, 		"modulate:a", 0.0, combat_fade_speed)
	c_tween.set_parallel(false)
	c_tween.tween_callback( player_control_weapons.hide )
	c_tween.tween_callback( player_control_move.hide )
	c_tween.tween_callback( player_control_defend.hide )
	c_tween.tween_callback( weapon_stats.hide )
	c_tween.tween_callback( player_controls.hide )
	
func set_ammo_amt( amt : int ):
	hud_ammo_amount.text = str( clampi(amt, 0, 9999) )
