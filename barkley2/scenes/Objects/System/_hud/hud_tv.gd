extends Control

@onready var tv_face: TextureRect = $tv_face
@onready var hud_health: Label = $hud_health

## Sprites
const region := Vector2( 24, 30 )

## Hoopz face stuff
const FACES_PER_HEALTH 	:= 3.0
const FACE_SPEED		:= 0.75
const FACE_LEFT 		:= 0
const FACE_CENTER 		:= 1
const FACE_RIGHT 		:= 2

const HEALTHY_OFFSET 	:= 0
const HURT1_OFFSET 		:= 1
const HURT2_OFFSET 		:= 2
const HURT3_OFFSET 		:= 3
const HURT4_OFFSET 		:= 4
const DED_OFFSET 		:= 5

var curr_face 			:= FACE_CENTER
var curr_health 		:= HEALTHY_OFFSET

var faceCount 	:= 2.0 + randf()
var faceWait 	:= 0.5 + randf() * 1.5

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_PAUSABLE ## Avoid moving its face with the game paused
	hud_health.update_health_display()

func change_tv_face():
	tv_face.texture.region.position.x = ( curr_face * region.x ) + ( curr_health * region.x * FACES_PER_HEALTH )

func update_health_display():
	var _curr 	: float = B2_Playerdata.player_stats.get_effective_stat( B2_HoopzStats.STAT_CURRENT_HP )
	var _max 	: float = B2_Playerdata.player_stats.get_effective_stat( B2_HoopzStats.STAT_EFFECTIVE_MAX_HP )
	var health_ratio : float = _curr / _max
	
	## Choose the right hoopz face to show.
	@warning_ignore("narrowing_conversion")
	var new_health = DED_OFFSET - int( float(DED_OFFSET) * health_ratio )
	if curr_face != new_health:
		curr_health = new_health
		change_tv_face()

func _physics_process(delta: float) -> void:
	hud_health.update_health_display()
	update_health_display()
	
	faceCount -= FACE_SPEED * delta 
	if faceCount < 0.0:
		faceCount = 2.0 + randf()
		if randf() < 0.5:
			curr_face = [FACE_LEFT, FACE_RIGHT].pick_random()
			faceWait = 0.5 + randf() * 1.5
			change_tv_face()
			
	if curr_face != FACE_CENTER:
		if faceWait > 0.0:
			faceWait -= FACE_SPEED * delta
		else:
			curr_face = FACE_CENTER
			change_tv_face()
