extends Node2D

var HGT_OFFSET := -4
var BODHGT := [
	30,
	30,
	28,
	28,
	24,
	24,
]

@onready var s_prison_body: AnimatedSprite2D = $sPrisonBody
@onready var s_prison_head: AnimatedSprite2D = $sPrisonHead
@onready var s_prison_face: AnimatedSprite2D = $sPrisonHead/sPrisonFace

var facing_up := false

func _ready() -> void:
	if facing_up:
		s_prison_body.animation = "back"
		s_prison_head.frame = randi_range(13,19)
		s_prison_head.position.y = -26.0
		s_prison_face.hide()
	else:
		s_prison_body.animation = "default"
		s_prison_body.frame = randi_range(0,5)
		s_prison_head.frame = randi_range(0,9)
		s_prison_head.position.y = -( BODHGT[s_prison_body.frame] + HGT_OFFSET )
		if randf() > 0.75:
			s_prison_face.show()
			s_prison_face.frame = randi_range(0,4)
		else:
			s_prison_face.hide()
