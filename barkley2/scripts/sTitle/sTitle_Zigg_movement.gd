extends Node2D

@export var is_Ziggurat := false

@export var movement_limit := 0

var moved_amount := 0.0

var original_y_pos := 0.0
var time := 0.0

func _ready():
	original_y_pos = position.y
	z_index = 5

func move_left( amount : float ):
	moved_amount += amount
	if moved_amount <= movement_limit:
		position.x += amount

func _physics_process(delta):
	if is_Ziggurat:
		## Original code
		#dry = 240 / 2;
		#img = titleZigAnim;
		#dry += lengthdir_x(7, current_time / 50);
		
		position.y = ( sin(time * delta) * 7 ) + original_y_pos
		time += 25 * delta ## 25 feels better than 50, like the original
