extends Node2D

@export var movement_limit := 0

var moved_amount := 0.0

var original_x_pos := 0.0
var original_y_pos := 0.0
var time := 0.0

func _ready():
	original_y_pos = position.y
	original_x_pos = position.x
	z_index = 5

func move_left( amount : float ):
	moved_amount += amount
	if moved_amount <= movement_limit:
		position.x -= amount

func apply_tim( tim : float):
	position.x = original_x_pos + (movement_limit * tim)
	#position.x = clamp(position.x, original_x_pos, movement_limit)
