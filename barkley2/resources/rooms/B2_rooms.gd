@icon("res://barkley2/assets/b2_original/images/merged/s_bball.png")
#extends Node2D
extends NavigationRegion2D
class_name B2_ROOMS

## WARNING Pathfinding sucks. it has many issues related to the starting and finish positions.
## Maybe improve AstarGrid2D resolution?

const O_HUD = preload("res://barkley2/scenes/Objects/System/o_hud.tscn")
const O_ZONE_NAME = preload("res://barkley2/objects/oZoneName.tscn")

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

@export var teleport_spot		:= false			## In Certain situations, hoopz can teleport to a room. This enables that function
@export var teleport_node		: B2_Teleport_Mark	## The room have a "o_teleport_mark" node to mark the spot
@export var teleport_pos		:= Vector2.ZERO		## A specific position to transport

@export_category("Room")
@export var collision_layer 		: TileMapLayer
@export var collision_layer_semi 	: TileMapLayer

@export_category("Room Options")
@export var enable_hud					:= true
@export var is_interior					:= false # lowers the music volume of the music
@export var play_room_music				:= true
@export var room_music_name				:= ""
@export var room_pacify 				:= true # Player cant draw weapons.
@export var room_player_can_roll 		:= true # Player can roll around.
@export var show_zone_banner			:= true
@export var override_zone_name			:= "" ## Allow custom zone name (upper text)
@export var override_zone_flavor		:= "" ## Allow custom zone flavor (bottom text)
@export var camera_bound_to_map			:= false # Camera cannot see outside the map.

@export_category("Navigation")
@export var source_geometry_mode := NavigationPolygon.SOURCE_GEOMETRY_GROUPS_WITH_CHILDREN

@export_category("Cinematics")
@export var player_can_pause			:= true
@export var play_cinema_at_room_start 	:= true
#@export var swap_with_hoopz_actor		:= true ## Temporarely remove o_hoopz and replace it with o_cts_hoopz
@export var cutscene_script 			: B2_Script ## Used for cutscenes and dialog.
@export var cutscene_script2 			: B2_Script ## Used for cutscenes and dialog. ## NOTE This is only used for 2 or 3 objects on the whole game.
@export var cutscene_script_mask		: Array[B2_Script_Mask] ## Mask allows you to replace variables in the B2_Script

@export_category("Weather")
@export_flags("Rain:1", "Smog:2") var room_weather := 0 ## ALERT not implemented. Need to work on this.

var astar_pos_offset := Vector2i(8,8)

var b2_camera : B2_Camera_Hoopz

var obstacles 			:= []

var room_size := Vector2.ZERO
var hud_node

var map_rect := Rect2() ## Map boundaries. Used by the pathfinding and camera limits.

func _enter_tree() -> void:
	B2_Screen.can_pause = player_can_pause
	_hide_collision_layer()
	if play_room_music:
		ready.connect( _play_room_music )
	if enable_hud:
		hud_node = O_HUD.instantiate()
		add_child( hud_node, true )
		
	y_sort_enabled = true
	ready.connect( _after_ready )

func _hide_collision_layer() -> void:
	if is_instance_valid(collision_layer):
		collision_layer.hide()
	if is_instance_valid(collision_layer_semi):
		collision_layer_semi.hide()

func _set_region():
	if populate_reference_layer:
		reference_layer.clear()
		for c in get_children():
			if c is TileMapLayer:
				reference_layer.append(c)
				c.add_to_group("navigation_polygon_source_geometry_group")
				
				## Set stuff in case you forgot to do it manually
				if not is_instance_valid( collision_layer ):
					if c.name == "layer - collision":
						collision_layer = c
						
				if not is_instance_valid( collision_layer_semi ):
					if c.name == "layer - collision 2":
						collision_layer = c
	
	## Players dont need to see this, only during development.
	_hide_collision_layer()
	
	## Check the size of all Tilemaplayers to get its real Rect2.
	for l : TileMapLayer in reference_layer:
		assert( is_instance_valid(l), "No reference avaiable for the pathfinding stuff" )
		map_rect = map_rect.merge( l.get_used_rect() )
		
	room_size = map_rect.size * 16 ## <- important for B2_EffectAtmo
	
	## Failsave in case you forgot to set it.
	if not is_instance_valid(navigation_polygon):
		navigation_polygon = NavigationPolygon.new()
	
	## NavigationRegion setup.
	var poly := PackedVector2Array( [
		Vector2(0,0),
		Vector2(0,map_rect.end.y * 16),
		Vector2(map_rect.end.x * 16,map_rect.end.y * 16),
		Vector2(map_rect.end.x * 16,0),
		] )
		
	navigation_polygon.clear_outlines()
	navigation_polygon.add_outline( poly )
	navigation_polygon.source_geometry_mode = source_geometry_mode
	navigation_polygon.source_geometry_group_name = "navigation_polygon_source_geometry_group"
	NavigationServer2D.bake_from_source_geometry_data( navigation_polygon, NavigationMeshSourceGeometryData2D.new() )
	
	bake_navigation_polygon()

func _after_ready() -> void:
	## add interior effects
	if is_interior:
		B2_Music.volume_mod = 0.75 
	else:
		B2_Music.volume_mod = 1.00
		
	## add weather effects
	if room_weather & 0b01 == 0b01: ## Rain effect
		# do something
		pass
	elif room_weather & 0b10 == 0b10: ## Smog effect
		# do something
		pass
		
	if show_zone_banner:
		var zone := O_ZONE_NAME.instantiate()
		zone.zone_data( name )
		if not override_zone_name.is_empty():
			zone.zone = override_zone_name
		if not override_zone_flavor.is_empty():
			zone.flavor = override_zone_flavor
			
		add_child( zone, true )

func update_pathfind():
	if not is_baking():
		bake_navigation_polygon()
	print( "%s: tried to update the pathfind mesh while it was already updating." % name )

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
	var player = B2_CManager.o_hoopz_scene.instantiate()
	player.position = debug_player_scene_pos
	if b2_camera != null:
		b2_camera.follow_mouse = true
		b2_camera.follow_player( player )
		b2_camera.position = debug_player_scene_pos
		b2_camera.set_camera_bound( camera_bound_to_map )
		
	add_child( player )
	return player
	
func _setup_camera( player ):
	b2_camera = B2_Camera_Hoopz.new()
	if not player == null:
		b2_camera.follow_mouse = true
		b2_camera.follow_player( player as B2_Player )
	add_child( b2_camera, true )
	b2_camera.set_camera_bound( camera_bound_to_map )
	print_rich( "[color=orange]Room %s: created player at DEBUG location %s.[/color]" % [name, debug_player_scene_pos] )

# Check if the actor is inside a building. return false if the parent is not B2_ROOMS
func is_inside_room() -> bool:
	return is_interior
		
# Get the room area. return "unknow" if the parent is not B2_ROOMS
func get_room_area() -> String:
	var room_name : String = get_room_name()
	if room_name.begins_with("r_") and room_name.count("_", 0, 6) >= 2:
		var area := room_name.get_slice( "_", 1 ) # r_tnn_residentialDistrict01 > tnn
		return area
	else:
		push_warning("Room name is not standard. fix this.")
		return ""
	
# Get the room name. return "unknow" if the parent is not B2_ROOMS
func get_room_name() -> String:
	return name
