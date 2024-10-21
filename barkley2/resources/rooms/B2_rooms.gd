@icon("res://barkley2/assets/b2_original/images/merged/s_bball.png")
extends Node2D
class_name B2_ROOMS

signal permission_changed

@export var populate_reference_layer := true
@export var reference_layer : Array[TileMapLayer]
@onready var astar : AStarGrid2D

var astar_solid_tiles := Array() # used for debug
var astar_valid_tiles := Array() # used for debug

@export_category("DEBUG")
@export var debug_create_player_scene_at_room_start 		:= false		# create player if you run this scene independetly
@export var debug_player_scene_pos 							:= Vector2.ZERO # if you run this individual scene, where hoopz will be created.
@export var show_pathfind_info								:= false 		# show some debug pathfind data

@export_category("Room")
@export var collision_layer : TileMapLayer

@export_category("Room Options")
@export var play_room_music				:= true
@export var room_music_name				:= ""
@export var room_pacify 				:= true # Player cant draw weapons.
@export var room_player_can_roll 		:= true # Player can roll around.

@export_category("Cinematics")
#@export var player_can_pause			:= true
@export var play_cinema_at_room_start 	:= true
#@export var swap_with_hoopz_actor		:= true ## Temporarely remove o_hoopz and replace it with o_cts_hoopz
@export var cutscene_script 			: B2_Script

@export_category("Nodes")
@export var b2_camera: B2_Camera

var obstacles 			:= []

func _enter_tree() -> void:
#	B2_Screen.can_pause = player_can_pause
	if is_instance_valid(collision_layer):
		collision_layer.hide()
	if play_room_music:
		ready.connect( _play_room_music )

func set_pacify( state : bool ):
	room_pacify = state
	permission_changed.emit()
	
func set_roll( state : bool ):
	room_player_can_roll = state
	permission_changed.emit()

func _play_room_music():
	if room_music_name.is_empty():
		B2_Music.room_get( name )
	else:
		B2_Music.play( room_music_name )

## This is a hard one.
# Cant update pachfinding dinamically. B2_Environ arent taken into account, so actors can go trhu objects.
# solution, manually update collision mask.

func _update_obstacles():
	var time := Time.get_ticks_usec()
	obstacles.clear()
	for n in get_children():
		if n is B2_SOLID or n is B2_SEMISOLID: # or n is B2_EnvironSolid or n is B2_EnvironSemisolid:
			obstacles.append(n)
			
	print("_update_obstacles(): took %s usecs." % str(Time.get_ticks_usec() - time) )

func _init_pathfind():
	if populate_reference_layer:
		for c in get_children():
			if c is TileMapLayer:
				reference_layer.append(c)
				
	assert( not reference_layer.is_empty(), "No reference avaiable for the pathfinding stuff" )
	assert( is_instance_valid(collision_layer), "No collision avaiable for the pathfinding stuff" )
	
	astar = AStarGrid2D.new()
	
	## ASTAR Setup.
	astar.jumping_enabled				= true
	astar.default_compute_heuristic 	= AStarGrid2D.HEURISTIC_EUCLIDEAN
	astar.default_estimate_heuristic 	= AStarGrid2D.HEURISTIC_EUCLIDEAN
	astar.diagonal_mode					= AStarGrid2D.DIAGONAL_MODE_ONLY_IF_NO_OBSTACLES
	#astar.diagonal_mode				= AStarGrid2D.DIAGONAL_MODE_AT_LEAST_ONE_WALKABLE
	
	var map_rect := Rect2()
	for l : TileMapLayer in reference_layer:
		assert( is_instance_valid(l), "No reference avaiable for the pathfinding stuff" )
		map_rect = map_rect.merge( l.get_used_rect() )
		
	astar.region = 		map_rect # reference_layer.get_used_rect()
	astar.cell_size = 	reference_layer.front().get_tile_set().tile_size
	astar.update()
	#astar.fill_solid_region( reference_layer.get_used_rect(), false )
	astar.fill_solid_region( map_rect, false )
	
# Is this needed?
func update_pathfind():
	_update_pathfind()
	
func _update_pathfind():
	var time := Time.get_ticks_usec()
	_update_obstacles()
	var _obstacles : Array[Vector2i] = []
	
	if not _obstacles.is_empty(): ## Maybe useless
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
				
	# update data from collision layer
	for tile in collision_layer.get_used_cells():
		astar.set_point_solid( tile, true )
			
	if show_pathfind_info:
		astar_valid_tiles.clear()
		astar_solid_tiles.clear()
		
		for x in astar.region.end.x:
			for y in astar.region.end.y:
				if not astar.is_point_solid( Vector2i( x, y ) ):
					astar_valid_tiles.append( Vector2i( x, y ) )
				else:
					astar_solid_tiles.append( Vector2i( x, y ) )
		debug_pathfind()
	
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
	my_path = astar.get_point_path( _destination, _origin, true ) ## Partial path seems usefull since we are unsure if a cinemaspot is inside a wall.
	
	if my_path.is_empty():
		push_error("Path generation failed.")
	
	return my_path

## Room setup
func _setup_player_node():
	const O_HOOPZ = preload("res://barkley2/scenes/Player/o_hoopz.tscn")
	var player = O_HOOPZ.instantiate()
	player.position = debug_player_scene_pos
	if b2_camera != null:
		b2_camera.follow_mouse = true
		b2_camera.follow_player( player )
		b2_camera.position = debug_player_scene_pos
		
	add_child( player )
	return player
	
func _setup_camera( player ):
	b2_camera = B2_Camera_Hoopz.new()
	if not player == null:
		b2_camera.follow_player( player as B2_Player )
		b2_camera.follow_mouse = true
	add_child( b2_camera, true )
	print_rich( "[color=orange]Room %s: created player at DEBUG location %s.[/color]" % [name, debug_player_scene_pos] )

func debug_pathfind():
	queue_redraw()
	
func _draw() -> void:
	if show_pathfind_info:
		for tile : Vector2i in astar_solid_tiles:
			var real_pos : Vector2 = tile * 16
			draw_rect( Rect2( real_pos, Vector2(16,16) ), Color(Color.RED, 0.5), true )
			draw_rect( Rect2( real_pos, Vector2(16,16) ), Color(Color.DARK_RED, 0.5), false )
			
		for tile : Vector2i in astar_valid_tiles:
			var real_pos : Vector2 = tile * 16
			draw_rect( Rect2( real_pos, Vector2(16,16) ), Color(Color.PINK, 0.5), true )
			draw_rect( Rect2( real_pos, Vector2(16,16) ), Color(Color.HOT_PINK, 0.5), false )
		
