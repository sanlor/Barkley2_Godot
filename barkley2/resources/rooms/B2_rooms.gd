@icon("res://barkley2/assets/b2_original/images/merged/s_bball.png")
extends Node2D
class_name B2_ROOMS

signal permission_changed

@export var populate_reference_layer := true
@export var reference_layer : Array[TileMapLayer]
@onready var astar : AStarGrid2D

@export_category("DEBUG")
@export var create_player_scene_at_room_start 	:= false
@export var player_scene_pos 					:= Vector2.ZERO

@export_category("Room")
@export var collision_layer : TileMapLayer

@export_category("Room Options")
@export var room_pacify 				:= true # Player cant draw weapons.
@export var room_player_can_roll 		:= true # Player can roll around.

@export_category("Cinematics")
@export var player_can_pause			:= true
@export var play_cinema_at_room_start 	:= true
@export var swap_with_hoopz_actor		:= true ## Temporarely remove o_hoopz and replace it with o_cts_hoopz
@export var cutscene_script 			: B2_Script

@export_category("Nodes")
var b2_cinema: B2_Cinema
@export var b2_camera: B2_Camera

var obstacles 			:= []

func _enter_tree() -> void:
	B2_Screen.can_pause = player_can_pause
	if is_instance_valid(collision_layer):
		collision_layer.hide()

func set_pacify( state : bool ):
	room_pacify = state
	permission_changed.emit()
	
func set_roll( state : bool ):
	room_player_can_roll = state
	permission_changed.emit()

func _update_obstacles():
	var time := Time.get_ticks_usec()
	obstacles.clear()
	for n in get_children():
		if n is B2_SOLID or n is B2_SEMISOLID:
			obstacles.append(n)
			
	print("_update_obstacles(): took %s usecs." % str(Time.get_ticks_usec() - time) )

func _init_pathfind():
	if populate_reference_layer:
		for c in get_children():
			if c is TileMapLayer:
				reference_layer.append(c)
				
	assert(not reference_layer.is_empty(), "No reference avaiable for the pathfinding stuff")
	astar = AStarGrid2D.new()
	
	var map_rect := Rect2()
	for l : TileMapLayer in reference_layer:
		assert( is_instance_valid(l), "No reference avaiable for the pathfinding stuff" )
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

## Room setup
func _setup_player_node():
	const O_HOOPZ = preload("res://barkley2/scenes/Player/o_hoopz.tscn")
	var player = O_HOOPZ.instantiate()
	player.position = player_scene_pos
	if b2_camera != null:
		b2_camera.follow_mouse = true
		b2_camera.follow_player( player )
		b2_camera.position = player_scene_pos
		
	add_child( player )
	return player
	
func _setup_camera( player ):
	b2_camera = B2_Camera_Hoopz.new()
	if not player == null:
		b2_camera.follow_player( player as B2_Player )
		b2_camera.follow_mouse = true
	add_child( b2_camera )
