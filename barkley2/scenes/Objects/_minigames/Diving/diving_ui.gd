extends CanvasLayer

@onready var drown_timer: Timer = $drown_timer
@onready var s_mg_diving_border: TextureRect = $s_mg_diving_border
@onready var s_mg_diving_oxygen_bg: TextureRect = $s_mg_diving_oxygen_bg
@onready var s_mg_diving_oxygen: TextureRect = $s_mg_diving_oxygen_bg/s_mg_diving_oxygen
@onready var s_mg_diving_oxygen_lbl: Label = $s_mg_diving_oxygen_lbl
@onready var s_mg_diving_drown: AnimatedSprite2D = $s_mg_diving_drown

@onready var camera_hoopz: B2_Camera_Hoopz = $"../B2_Camera_Hoopz"
@onready var o_mg_diving_player: RigidBody2D = $"../o_mg_diving_player"

const MAX_DROWNING	:= 3 # seconds to drown after the counter reaches 0
const MAX_OXYGEN 	:= 100.0
var oxygen 			:= 0.0
var hoopz_ded		:= false
var drowning		:= 0
var music_fast		:= false

func _ready() -> void:
	s_mg_diving_drown.hide()

func _physics_process(delta: float) -> void:
	if hoopz_ded:
		return
		
	@warning_ignore("narrowing_conversion")
	s_mg_diving_oxygen_lbl.text = String.num_int64(abs(oxygen - MAX_OXYGEN))
	s_mg_diving_oxygen.material.set_shader_parameter("ratio", oxygen / 100.0)
	oxygen = clampf(oxygen + 2.0 * delta, 0.0, MAX_OXYGEN)
	
	## Flicker
	if oxygen == 100.0:
		if not music_fast:
			B2_Music.play("mus_diving_fast",0.0)
			music_fast = true
		s_mg_diving_drown.visible = not s_mg_diving_drown.visible
	else:
		if music_fast:
			B2_Music.play("mus_diving",0.0)
			music_fast = false
			

func _on_drown_timer_timeout() -> void:
	if oxygen == 100.0:
		
		s_mg_diving_drown.show()
		if s_mg_diving_drown.frame == 0:
			drowning += 1
			if drowning >= MAX_DROWNING: ## Drown
				if not hoopz_ded:
					drown_timer.stop() # Stop timer, nothing else to update
					
					B2_Music.stop()
					B2_Sound.play("sn_mg_diving_toilet_scream")
					
					## Set some variables for the death state.
					if B2_CManager.get_BodySwap() == "prison":		B2_Playerdata.Quest("junklordSpecial", "prison")
					else:											B2_Playerdata.Quest("junklordSpecial", "drown")
						
					## Hide UI
					s_mg_diving_oxygen_bg.hide()
					s_mg_diving_drown.hide()
						
					## Set player stuff. mostly animation, camera and gameover screen
					hoopz_ded = true
					o_mg_diving_player.drown()
					camera_hoopz.follow_player( null )
					camera_hoopz.follow_mouse = false
					
					## Fade out
					var t := create_tween()
					t.tween_property(s_mg_diving_border.texture,"fill_to", Vector2(0.51,0.51), 6.0 )
					t.tween_callback( B2_Music.play.bind("mus_gameover", 0.0) )
					t.tween_interval( 2.0 )
					await t.finished
					
					B2_Screen.show_defeat_screen()
		else:
			s_mg_diving_drown.position = Vector2( randf_range(-64,64), randf_range(-48,48) ) + get_viewport().get_visible_rect().size / 2
			s_mg_diving_drown.frame -= 1
	else:
		s_mg_diving_drown.hide()
		s_mg_diving_drown.frame = 5
		drowning = 0
		
