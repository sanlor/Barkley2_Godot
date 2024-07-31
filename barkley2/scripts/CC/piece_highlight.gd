extends Sprite2D

@export var follow_piece : Sprite2D

var piece_grid_origin := Vector2(33,44) # the grid start at 33x44
var piece_grid_size := Vector2(32,16) # each cell is 32x16
var alignment_grid_size := Vector2(10,10) # The whole grid is 10x10

var weird_offset := Vector2( 0, -4.5 ) 

var curr_pos_on_grid := Vector2.ZERO

func _ready():
	pass
	
func _process(_delta):
	var piece_pos_on_grid = ( follow_piece.position / piece_grid_size ).round() 
	
	if curr_pos_on_grid != piece_pos_on_grid:
		#print("high ",piece_pos_on_grid)
		curr_pos_on_grid = piece_pos_on_grid
		warp_to_new_location()
		
func warp_to_new_location():
	modulate.a = 0.5
	var new_pos := (curr_pos_on_grid * piece_grid_size)
	var tween := create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.25)
	tween.tween_callback( set_position.bind( new_pos ) ) #  + weird_offset
	tween.tween_property(self, "modulate:a", 0.5, 0.25)
	
	pass
