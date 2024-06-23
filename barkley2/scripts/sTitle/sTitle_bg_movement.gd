extends Node2D

@export var movement_limit := 0

var moved_amount := 0.0

func _ready():
	z_index = 5

func move_left( amount : float ):
	moved_amount += amount
	if moved_amount <= movement_limit:
		position.x -= amount
