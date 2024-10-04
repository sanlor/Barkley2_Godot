@icon("res://barkley2/assets/b2_original/images/merged/s_bball.png")
extends Node2D
class_name B2_ROOMS

@export var reference_layer : Array[TileMapLayer]
@onready var astar : AStarGrid2D

var obstacles 			:= []

func _update_obstacles():
	var time := Time.get_ticks_usec()
	obstacles.clear()
	for n in get_children():
		if n is B2_SOLID or n is B2_SEMISOLID:
			obstacles.append(n)
			
	print("_update_obstacles(): took %s usecs." % str(Time.get_ticks_usec() - time) )

func _init_pathfind():
	assert(reference_layer != null, "No reference avaiable for the pathfinding stuff")
	astar = AStarGrid2D.new()
	
	var map_rect := Rect2()
	for l : TileMapLayer in reference_layer:
		map_rect = map_rect.merge( l.get_used_rect() )
		
	astar.region = 		map_rect # reference_layer.get_used_rect()
	astar.cell_size = 	reference_layer.front().get_tile_set().tile_size
	astar.update()
	#astar.fill_solid_region( reference_layer.get_used_rect(), false )
	astar.fill_solid_region( map_rect, false )
	
	
func _update_pathfind():
	var time := Time.get_ticks_usec()
	_update_obstacles()
	
	var _obstacles : Array[Vector2i] = []
	
	for n in obstacles:
		@warning_ignore("narrowing_conversion")
		var tile_size 	:int= astar.cell_size.x
		var pos			:Vector2i = reference_layer.front().local_to_map( n.position )
		#var pos_x		:int= n.position.x 	/ tile_size
		#var pos_y		:int= n.position.y 	/ tile_size
		var size_x 		:int= n.width 		/ tile_size
		var size_y 		:int= n.height 		/ tile_size
		
		for x : int in size_x:
			for y : int in size_y:
				var tile_pos := Vector2i(pos.x + x, pos.y + y)
				astar.set_point_solid( tile_pos, true )
				
	print("_update_pathfind(): took %s usecs." % str(Time.get_ticks_usec() - time) )
	
## Remmeber, the path returned is inverted.
func get_astar_path(origin : Vector2, destination : Vector2) -> PackedVector2Array:
	var _origin 		: Vector2i = reference_layer.front().local_to_map(origin) 		#Vector2i(origin		/ astar.cell_size.x )
	var _destination 	: Vector2i = reference_layer.front().local_to_map(destination) 	#Vector2i(destination	/ astar.cell_size.x )
	var my_path 		:= PackedVector2Array()
	
	if not astar.is_in_boundsv(_origin):
		push_error(_origin, 		" is OOB.")
		return my_path
	if not astar.is_in_boundsv(_destination):
		push_error(_destination, 	" is OOB.")
		return my_path
	my_path = astar.get_point_path(_destination, _origin, true) ## Partial path seems usefull since we are unsure if a cinemaspot is inside a wall.
	
	if my_path.is_empty():
		push_error("Path generation failed.")
	
	return my_path
