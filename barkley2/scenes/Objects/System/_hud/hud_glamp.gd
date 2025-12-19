extends ColorRect
## 19/12/25 --> Fuck! Year is almost ending.
# Got my yellow belt (krav maga) yesterday. fun.

# Anyway, This controls how the GLAMP letters fills up.
# Ofcourse, the original game had to make this verry complicated.
# s_hud_glamp has a bunch of sprites with different colors. The OG game (from what I can find) uses only the yellow and blue parts.

@onready var g_overlay: ColorRect = $hud_glamp_container/g_letter/g_overlay
@onready var l_overlay: ColorRect = $hud_glamp_container/l_letter/l_overlay
@onready var a_overlay: ColorRect = $hud_glamp_container/a_letter/a_overlay
@onready var m_overlay: ColorRect = $hud_glamp_container/m_letter/m_overlay
@onready var p_overlay: ColorRect = $hud_glamp_container/p_letter/p_overlay

@onready var g_letter: TextureRect = $hud_glamp_container/g_letter
@onready var l_letter: TextureRect = $hud_glamp_container/l_letter
@onready var a_letter: TextureRect = $hud_glamp_container/a_letter
@onready var m_letter: TextureRect = $hud_glamp_container/m_letter
@onready var p_letter: TextureRect = $hud_glamp_container/p_letter

const FLASH_COLOR := Color.ORANGE
const FLASH_TIMER := 0.5

var old_guts 	:= INF
var old_luck 	:= INF
var old_agile 	:= INF
var old_might 	:= INF
var old_piety 	:= INF

func _ready() -> void:
	B2_SignalBus.stat_updated.connect( _update_stat_display )
	_update_stat_display( false )

func _update_stat_display( stat_name = null ) -> void:
	var guts := float( B2_Playerdata.get_player_guts() ) / 100.0
	var luck := float( B2_Playerdata.get_player_luck() ) / 100.0
	var agile := float( B2_Playerdata.get_player_agile() ) / 100.0
	var might := float( B2_Playerdata.get_player_might() ) / 100.0
	var piety := float( B2_Playerdata.get_player_piety() ) / 100.0
	
	if stat_name:
		var t := create_tween()
		t.set_parallel( true )
		match stat_name:
			B2_HoopzStats.STAT_BASE_GUTS:
				g_letter.modulate = FLASH_COLOR * 2.0
				t.tween_property( g_letter, "modulate", Color.WHITE, FLASH_TIMER )
				
			B2_HoopzStats.STAT_BASE_LUCK:
				l_letter.modulate = FLASH_COLOR * 2.0
				t.tween_property( l_letter, "modulate", Color.WHITE, FLASH_TIMER )
				
			B2_HoopzStats.STAT_BASE_AGILE:
				a_letter.modulate = FLASH_COLOR * 2.0
				t.tween_property( a_letter, "modulate", Color.WHITE, FLASH_TIMER )
				
			B2_HoopzStats.STAT_BASE_MIGHT:
				m_letter.modulate = FLASH_COLOR * 2.0
				t.tween_property( m_letter, "modulate", Color.WHITE, FLASH_TIMER )
				
			B2_HoopzStats.STAT_BASE_PIETY:
				p_letter.modulate = FLASH_COLOR * 2.0
				t.tween_property( p_letter, "modulate", Color.WHITE, FLASH_TIMER )
	
	g_overlay.material.set_shader_parameter( "progress", guts )
	l_overlay.material.set_shader_parameter( "progress", luck )
	a_overlay.material.set_shader_parameter( "progress", agile )
	m_overlay.material.set_shader_parameter( "progress", might )
	p_overlay.material.set_shader_parameter( "progress", piety )
