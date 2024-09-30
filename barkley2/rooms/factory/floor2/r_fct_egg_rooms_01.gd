extends Node2D

@onready var b_2_cinema: B2_Cinema = $B2_Cinema

@export var reference_layer : TileMapLayer
@onready var astar : AStarGrid2D

var obstacles 			:= []

# on the original game, the object o_world runs a piece of code at every room start.
# check scr_map_roomstart()

func _ready() -> void:
	_init_pathfind()
	_update_pathfind()
	# print( get_astar_path( Vector2(208,274) / 16, Vector2(270,464) / 16 ) ) ## debug testing
	
	# If you go back to this room after progressing the tutorial, all the egg shit is already fucked beyond repair and can't be interacted with etc. //
	if B2_Playerdata.Quest( "gameStart", null ) != 1:
		# the cutscene was already played.
		# return
		pass
	else:
		# play the initial cutscene.
		
		#BodySwap("diaper");
		#scr_event_entity_settings(id, 0, 0, 0);
		B2_Playerdata.Quest("hudVisible", 		0);
		B2_Playerdata.Quest("zoneVisible", 		0);
		B2_Playerdata.Quest("dropEnabled", 		0);
		B2_Playerdata.Quest("infiniteAmmo", 	1);
		b_2_cinema.play_cutscene()

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
	astar.region = 		reference_layer.get_used_rect()
	astar.cell_size = 	reference_layer.get_tile_set().tile_size
	astar.update()
	astar.fill_solid_region( reference_layer.get_used_rect(), false )
	
	
func _update_pathfind():
	var time := Time.get_ticks_usec()
	_update_obstacles()
	
	var _obstacles : Array[Vector2i] = []
	
	for n in obstacles:
		var tile_size 	:int= astar.cell_size.x
		var pos			:Vector2i = reference_layer.local_to_map( n.position )
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
	var _origin 		:= reference_layer.local_to_map(origin) 		#Vector2i(origin		/ astar.cell_size.x )
	var _destination 	:= reference_layer.local_to_map(destination) 	#Vector2i(destination	/ astar.cell_size.x )
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
