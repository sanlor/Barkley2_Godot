extends Area2D

const O_MG_DIVING_DANGER_TORPEDO = preload("uid://dytqavwygm2rh")

const MAX_DIST := 128

var source_pos 	:= Vector2.ZERO
var target_pos 	:= Vector2.ZERO
var speed		:= Vector2.ZERO

@onready var timer: Timer = $Timer
@onready var s_mg_diving_danger_sub: 	AnimatedSprite2D 	= $s_mg_diving_danger_sub
@onready var detection_area: 			Area2D 				= $detection_area

func _ready() -> void:
	source_pos = global_position
	get_new_target()
	
func get_new_target() -> void:
	target_pos = source_pos + Vector2( randf_range(-MAX_DIST,MAX_DIST), randf_range(-MAX_DIST,MAX_DIST) * randf() )
	
func _physics_process(delta: float) -> void:
	speed = speed.move_toward( position.direction_to(target_pos), 1.0 * delta )
	
	position += speed
	if position.distance_to(target_pos) < 5.0:
		get_new_target()
		
	for body in get_overlapping_bodies():
		if body.name == "o_mg_diving_player":
			body.hurt()
			body.apply_central_impulse( global_position.direction_to(body.global_position) * 10000.0 )
			
	## Fire them torpedos
	for body in detection_area.get_overlapping_bodies():
		if body.name == "o_mg_diving_player":
			if timer.is_stopped():
				var torpedo := O_MG_DIVING_DANGER_TORPEDO.instantiate()
				torpedo.target = body
				torpedo.global_position = global_position
				add_sibling( torpedo, true)
				B2_Sound.play(["sn_mg_diving_torpedo1","sn_mg_diving_torpedo2"].pick_random())
				timer.start()
