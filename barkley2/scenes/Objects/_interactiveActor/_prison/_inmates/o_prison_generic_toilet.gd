@tool
extends AnimatedSprite2D

const CENSOR_COLORS := [
	Color8(69, 60, 74),
	Color8(107, 103, 114),
	Color8(107, 103, 114),
	Color8(163, 127, 115),
	Color8(163, 127, 115),
	Color8(207, 183, 174),
	Color8(207, 183, 174),
	Color8(207, 183, 174),
	]
const CENSOR_OFFSET := Vector2(-5,4)

@onready var censor_bar_timer: Timer = $censor_bar_timer
@onready var s_prison_head: AnimatedSprite2D = $sPrisonHead
@onready var s_prison_face: AnimatedSprite2D = $sPrisonHead/sPrisonFace
	
func _ready() -> void:
	censor_bar_timer.start()
	frame = 0
	s_prison_head.frame = randi_range(0,9)
	s_prison_face.frame = randi_range(0,4)
	if randf() > 0.6: # Chance for not having a beard
		s_prison_face.hide()
	
## Hoopz is sitting.
func execute_event_user_0():
	s_prison_head.hide()
	s_prison_face.hide()
	frame = 1
	
func _draw() -> void:
	const RECT_SIZE := 2.0
	for x in 5:
		for y in 4:
			var rect := Rect2( CENSOR_OFFSET + Vector2(x,y) * RECT_SIZE, Vector2.ONE * RECT_SIZE )
			draw_rect(rect, CENSOR_COLORS.pick_random(), true )

func _on_censor_bar_timer_timeout() -> void:
	queue_redraw()
