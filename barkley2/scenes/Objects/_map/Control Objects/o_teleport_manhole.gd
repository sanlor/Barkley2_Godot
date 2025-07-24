extends Sprite2D

@export_category("Manhole stuff")
@export var is_open 				:= false
@export var silent 					:= false
@export var draw_cover 				:= true
@export var teleport_room_string	:= "" ## Ex.: r_sw2_eastExit01, 288, 152, EAST
@export var open_direction			:= Vector2.RIGHT
@export var open_distance			:= 40.0

@export_category("Player Detections")
@export var detection_distance := 64.0

@onready var s_manhole_cover: Sprite2D = $s_manhole_cover
@onready var player_detection: 		Area2D = $player_detection
@onready var player_detection_col: 	CollisionShape2D = $player_detection/player_detection_col
@onready var teleport_area: Area2D = $teleport_area

var tween : Tween

var cutscene_script : B2_Script_Legacy

func _ready() -> void:
	player_detection_col.shape.radius = detection_distance
	s_manhole_cover.visible = draw_cover
	if draw_cover:
		player_detection.body_entered.connect( open_manhole )
		player_detection.body_exited.connect( close_manhole )
	teleport_area.body_entered.connect( teleport_to_room )
	
func open_manhole( body : Node2D ) -> void:
	if not draw_cover:
		return
	if B2_Input.cutscene_is_playing:
		return
	if not body is B2_Player:
		return
	if not silent: B2_Sound.play("manhole_opening_closing")
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property( s_manhole_cover, "position", open_direction * open_distance, 0.5 ).set_ease(Tween.EASE_OUT_IN)
	
	
func close_manhole( body : Node2D ) -> void:
	if not draw_cover:
		return
	if B2_Input.cutscene_is_playing:
		return
	if not body is B2_Player:
		return
	if not silent: B2_Sound.play("manhole_opening_closing")
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property( s_manhole_cover, "position", Vector2.ZERO, 0.5 ).set_ease(Tween.EASE_IN_OUT)

func teleport_to_room( body : Node2D ) -> void:
	if not body is B2_Player:
		return
	_make_cinema_script()
	B2_CManager.play_cutscene( cutscene_script, self, [] )
	
func _make_cinema_script() -> void:
	var scr := B2_Script_Legacy.new()
	var my_script := \
	"LOOK   | o_cts_hoopz | SOUTHEAST
	WAIT   | 0.25
	PLAYSET| o_cts_hoopz | kneelDown | kneel
	WAIT   | 0
	Misc   | alpha | o_cts_hoopz | 0 | 1
	WAIT   | 1.0
	WAIT   | 0.75
	FADE   | 1 | 0.5
	WAIT   | 0.5
	Teleport | %s | %s | %s | 0.5" % [ teleport_room_string.get_slice( ",", 0 ), teleport_room_string.get_slice( ",", 1 ), teleport_room_string.get_slice( ",", 2 ) ]
	scr.original_script = my_script
	cutscene_script = scr
