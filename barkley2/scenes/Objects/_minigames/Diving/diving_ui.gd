extends CanvasLayer

@onready var drown_timer: Timer = $drown_timer
@onready var s_mg_diving_border: TextureRect = $s_mg_diving_border
@onready var s_mg_diving_oxygen: TextureRect = $s_mg_diving_oxygen_bg/s_mg_diving_oxygen
@onready var s_mg_diving_oxygen_lbl: Label = $s_mg_diving_oxygen_lbl
@onready var s_mg_diving_drown: AnimatedSprite2D = $s_mg_diving_drown

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
					hoopz_ded = true
					B2_Music.stop()
					B2_Sound.play("sn_mg_diving_toilet_scream")
					
					pass
		else:
			s_mg_diving_drown.position = Vector2( randf_range(-64,64), randf_range(-48,48) ) + get_viewport().get_visible_rect().size / 2
			s_mg_diving_drown.frame -= 1
	else:
		s_mg_diving_drown.hide()
		s_mg_diving_drown.frame = 5
		drowning = 0
		
