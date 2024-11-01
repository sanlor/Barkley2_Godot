@icon("res://barkley2/assets/b2_original/images/merged/s_bball.png")
#extends Node2D
extends NavigationRegion2D
class_name B2_ROOMS

## WARNING Pathfinding sucks. it has many issues related to the starting and finish positions.
## Maybe improve AstarGrid2D resolution?

const O_HUD = preload("res://barkley2/scenes/Objects/System/o_hud.tscn")

signal permission_changed
signal pacify_changed( activated : bool )

@export var populate_reference_layer := true
@export var reference_layer : Array[TileMapLayer]
@onready var astar : AStarGrid2D

var astar_solid_tiles := Array() # used for debug
var astar_valid_tiles := Array() # used for debug

@export_category("DEBUG")
@export var debug_create_player_scene_at_room_start 		:= false		# create player if you run this scene independetly
@export var debug_player_scene_pos 							:= Vector2.ZERO # if you run this individual scene, where hoopz will be created.

@export_category("Room")
@export var collision_layer 		: TileMapLayer
@export var collision_layer_semi 	: TileMapLayer

@export_category("Room Options")
@export var enable_hud					:= true
@export var play_room_music				:= true
@export var room_music_name				:= ""
@export var room_pacify 				:= true # Player cant draw weapons.
@export var room_player_can_roll 		:= true # Player can roll around.

@export_category("Cinematics")
@export var player_can_pause			:= true
@export var play_cinema_at_room_start 	:= true
#@export var swap_with_hoopz_actor		:= true ## Temporarely remove o_hoopz and replace it with o_cts_hoopz
@export var cutscene_script 			: B2_Script ## Used for cutscenes and dialog.
@export var cutscene_script2 			: B2_Script ## Used for cutscenes and dialog. ## NOTE This is only used for 2 or 3 objects on the whole game.
@export var cutscene_script_mask		: Array[B2_Script_Mask] ## Mask allows you to replace variables in the B2_Script

var astar_pos_offset := Vector2i(8,8)

var b2_camera : B2_Camera_Hoopz

var obstacles 			:= []

var room_size := Vector2.ZERO
var hud_node

func _enter_tree() -> void:
	B2_Screen.can_pause = player_can_pause
	if is_instance_valid(collision_layer):
		collision_layer.hide()
	if is_instance_valid(collision_layer_semi):
		collision_layer_semi.hide()
	if play_room_music:
		ready.connect( _play_room_music )
	if enable_hud:
		hud_node = O_HUD.instantiate()
		add_child( hud_node, true )
	y_sort_enabled = true

func _set_region():
	if populate_reference_layer:
		for c in get_children():
			if c is TileMapLayer:
				reference_layer.append(c)
				
			if not is_instance_valid( collision_layer ):
				if c.name == "layer - collision":
					collision_layer = c
					
			if not is_instance_valid( collision_layer_semi ):
				if c.name == "layer - collision 2":
					collision_layer = c
					
	var map_rect := Rect2()
	for l : TileMapLayer in reference_layer:
		assert( is_instance_valid(l), "No reference avaiable for the pathfinding stuff" )
		map_rect = map_rect.merge( l.get_used_rect() )
	
	var poly := PackedVector2Array( [
		Vector2(0,0),
		Vector2(0,map_rect.end.y * 16),
		Vector2(map_rect.end.x * 16,map_rect.end.y * 16),
		Vector2(map_rect.end.x * 16,0),
		] )
	navigation_polygon.clear_outlines()
	navigation_polygon.add_outline( poly )
	NavigationServer2D.bake_from_source_geometry_data( navigation_polygon, NavigationMeshSourceGeometryData2D.new() )
	
	bake_navigation_polygon()

func update_pathfind():
	bake_navigation_polygon()

func set_pacify( state : bool ):
	room_pacify = state
	permission_changed.emit()
	pacify_changed.emit( not room_pacify )
	
func set_roll( state : bool ):
	room_player_can_roll = state
	permission_changed.emit()

func _play_room_music():
	if room_music_name.is_empty():
		B2_Music.room_get( name )
	else:
		B2_Music.play( room_music_name )

## Room setup
func _setup_player_node():
	var o_hoopz_scene = B2_CManager.o_hoopz_scene
	var player = B2_CManager.o_hoopz_scene.instantiate()
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
