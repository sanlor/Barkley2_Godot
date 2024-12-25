extends Control
class_name B2_DiagFG

## Simplified version of the Border node. Doesnt have the random border flair and is a bit smaller.

const SIMPLE_DIAG_EDGE = preload("res://barkley2/resources/B2_Breakout/simple_diag_edge.tres")
const SIMPLE_DIAG_CORNER = preload("res://barkley2/resources/B2_Breakout/simple_diag_corner.tres")

const corner_size 	:= Vector2(32,32)
const edge_size 	:= Vector2(16,16)

@export var diag_size := Vector2(32,32) : 
	set(s):
		diag_size = s
		queue_redraw()

func set_panel_size(x, y):
	diag_size = Vector2(x,y).round()
	
func _draw() -> void:

	
	## Edge
	var top 	:= SIMPLE_DIAG_EDGE.duplicate()
	var bottom 	:= SIMPLE_DIAG_EDGE.duplicate()
	var left 	:= SIMPLE_DIAG_EDGE.duplicate()
	var right 	:= SIMPLE_DIAG_EDGE.duplicate()
	left.region.position.x 		= edge_size.x * 0
	top.region.position.x 		= edge_size.x * 1
	right.region.position.x 	= edge_size.x * 2
	bottom.region.position.x 	= edge_size.x * 3
	
	if diag_size.y > corner_size.y * 2: # Avoid wasting time drawing things that cant be seen.
		for vert in (diag_size.y / 16) - 1:
			draw_texture( left, Vector2(0, edge_size.y * vert) )
			draw_texture( right, Vector2(diag_size.x - edge_size.x, edge_size.y * vert) )
		
	if diag_size.x > corner_size.x * 2:  # Avoid wasting time drawing things that cant be seen.
		for hori in (diag_size.x / 16) - 1:
			draw_texture(top, Vector2( edge_size.x * hori, 0 ) )
			draw_texture(bottom, Vector2( edge_size.x * hori, diag_size.y - edge_size.y ) )

	## Corners
	var top_left 		:= SIMPLE_DIAG_CORNER.duplicate()
	var top_right 		:= SIMPLE_DIAG_CORNER.duplicate()
	var bottom_left 	:= SIMPLE_DIAG_CORNER.duplicate()
	var bottom_right 	:= SIMPLE_DIAG_CORNER.duplicate()
	top_right.region.position.x 	= corner_size.x * 0
	top_left.region.position.x 		= corner_size.x * 1
	bottom_left.region.position.x 	= corner_size.x * 2
	bottom_right.region.position.x 	= corner_size.x * 3
	draw_texture(top_right, Vector2( diag_size.x - corner_size.x, 0 ) )
	draw_texture(top_left, Vector2( 0, 0 ) )
	draw_texture(bottom_left, Vector2(0, diag_size.y - corner_size.y) )
	draw_texture(bottom_right, diag_size - corner_size )
