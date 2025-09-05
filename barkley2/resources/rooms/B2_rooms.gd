@icon("res://barkley2/assets/b2_original/images/merged/s_bball.png")
#extends Node2D
extends NavigationRegion2D
class_name B2_ROOMS

## WARNING Pathfinding sucks. it has many issues related to the starting and finish positions.
## Maybe improve AstarGrid2D resolution?

const O_HUD 					= preload("res://barkley2/scenes/Objects/System/o_hud.tscn")
const O_ZONE_NAME 				= preload("res://barkley2/objects/oZoneName.tscn")
const COLLISION_WADING_TILESET 	= preload("uid://m673wsth5kja")
const COLLISION_ABYSS_TILESET 	= preload("uid://snddsm584j8b")
const COLLISION_2_TILESET 		= preload("uid://cbgwi3h47ghpg")
const COLLISION_TILESET 		= preload("uid://n70843ohvm84")

signal permission_changed
signal pacify_changed( activated : bool )
@export var populate_reference_layer 	:= true 			## Automatically try to populate "reference_layer" with TileMapLayers
@export var reference_layer : Array[TileMapLayer]
@onready var astar : AStarGrid2D ## DEPRECATED

var astar_solid_tiles := Array() # used for debug
var astar_valid_tiles := Array() # used for debug

@export_category("DEBUG")
@export var debug_create_player_scene_at_room_start 		:= false		## create player if you run this scene independetly
@export var debug_player_scene_pos 							:= Vector2.ZERO ## if you run this individual scene, where hoopz will be created.
@export var load_debug_save_data							:= false		## Pretty self explanatory

@export var teleport_spot		:= false			## In Certain situations, hoopz can teleport to a room. This enables that function
@export var teleport_node		: B2_Teleport_Mark	## The room have a "o_teleport_mark" node to mark the spot
@export var teleport_pos		:= Vector2.ZERO		## A specific position to transport

@export_category("Room")
@export var play_enviro_sounds		:= false		## Some rooms have ambient sound
@export var enviro_sound_array		: Array[String]	## a list of all ambient sounds that this room has.
@export var collision_layer 		: TileMapLayer	## The tilemap that handles colision of everything.
@export var collision_layer_semi 	: TileMapLayer	## The tilemap that handles colision for somethings (like actors, but not for bullets)
@export var collision_layer_wade 	: TileMapLayer	## The tilemap that handles colision for water (casing and bullets falling in the water)
@export var collision_layer_abyss 	: TileMapLayer	## The tilemap that handles colision for bottomless pits (casing and bullets disappear)
var collision_array 				: Array[TileMapLayer] = []

@export_category("Room Options")
@export var enable_hud					:= true		## Allow the hud to show up
@export var is_interior					:= false 	## lowers the music volume of the music 
@export var play_room_music				:= true		## This room can play a music
@export var room_music_name				:= ""		## Forces a speccific music
@export var room_pacify 				:= true 	## Player cant draw weapons.
@export var room_player_can_roll 		:= true 	## Player can roll around.
@export var show_zone_banner			:= true		## Show the zone banner in this room
@export var override_zone_name			:= "" 		## Allow custom zone name (upper text)
@export var override_zone_flavor		:= "" 		## Allow custom zone flavor (bottom text)
@export var camera_bound_to_map			:= false 	## Camera cannot see outside the map.

@export_category("Room light")
@export var is_this_room_dark			:= false	## Adds a canvas modulate to the scene, to simulate a dark room
@export var room_darkness_color			:= Color(0.5, 0.5, 0.5, 1.0)

@export_category("Navigation")
@export var source_geometry_mode := NavigationPolygon.SOURCE_GEOMETRY_GROUPS_WITH_CHILDREN

@export_category("Cinematics")
@export var player_can_pause			:= true		## Player can pause in this room
@export var play_cinema_at_room_start 	:= true		## Play some cutscene when the player loads this room.
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
	if Engine.is_editor_hint():
		return
		
	B2_Screen.can_pause = player_can_pause
	_hide_collision_layer()
	if play_room_music:		ready.connect( _play_room_music )
	else:					B2_Music.stop( 1.0 )
	
	if enable_hud:
		hud_node = O_HUD.instantiate()
		add_child( hud_node, true )
		hud_node.call_deferred( "show_hud" )
		
	y_sort_enabled = true
	ready.connect( _after_ready )
	
	if is_this_room_dark:
		var room_darkness_node := CanvasModulate.new()
		room_darkness_node.color = room_darkness_color
		add_child( room_darkness_node )
		#move_child( room_darkness_node, 0 )
		#room_darkness_node.owner = self
		print( "room_darkness_node created for room '%s'." % name )
	
	if play_enviro_sounds:
		if enviro_sound_array.is_empty():
			push_warning("Room is set to play some soothing enviro sounds, but no sound was added to the array.")
		else:
			for sound in enviro_sound_array:
				var stream : String = B2_Sound.get_sound(sound)
				if stream.is_empty():
					push_error("Invalid sound added for enviro: %s" % sound)
					break
				var sound_node := AudioStreamPlayer.new()
				add_child( sound_node )
				sound_node.stream = load( stream )
				sound_node.stream.loop = true
				sound_node.bus = "audio"
				sound_node.play()
			
func _ready() -> void:
	push_error("Room %s not setup." % get_room_name())

## manually check collision againt all tilemap layers on the reference layer
func check_tilemap_collision( pos : Vector2, collision_mask : int ) -> bool:
	var local_pos : Vector2i = reference_layer.front().local_to_map( pos )
	for tilemap : TileMapLayer in collision_array:
		# check if the cell is being used
		if tilemap.get_cell_source_id(local_pos) >= 0:
			## Check if the collision mask match
			if tilemap.tile_set.get_physics_layer_collision_layer(0) || collision_mask != 0: ## bitwise op OR
				return true
	## No collision
	return false

func _hide_collision_layer() -> void:
	if is_instance_valid(collision_layer):
		collision_layer.hide()
	if is_instance_valid(collision_layer_semi):
		collision_layer_semi.hide()
	if is_instance_valid(collision_layer_wade):
		collision_layer_wade.hide()
	if is_instance_valid(collision_layer_abyss):
		collision_layer_abyss.hide()
		
func _set_region():
	if populate_reference_layer:
		reference_layer.clear()
		for c in get_children():
			if c is StaticBody2D:
				c.add_to_group("navigation_polygon_source_geometry_group")
				
			if c is TileMapLayer:
				reference_layer.append(c)
				c.add_to_group("navigation_polygon_source_geometry_group")
				
				## Set stuff in case you forgot to do it manually
				if c.name == "layer - collision":
					if not is_instance_valid( collision_layer ):
						collision_layer = c
					collision_layer.tile_set = COLLISION_TILESET
					collision_array.append(c)
					
				if c.name == "layer - collision 2":
					if not is_instance_valid( collision_layer_semi ):
						collision_layer_semi = c
					collision_layer_semi.tile_set = COLLISION_2_TILESET
					collision_array.append(c)
					
				if c.name == "layer - wading":
					if not is_instance_valid( collision_layer_wade ):
						collision_layer_wade = c
					collision_layer_wade.tile_set = COLLISION_WADING_TILESET
					collision_array.append(c)
					
				if c.name == "layer - abyss":
					if not is_instance_valid( collision_layer_abyss ):
						collision_layer_abyss = c
					collision_layer_abyss.tile_set = COLLISION_ABYSS_TILESET
					collision_array.append(c)
	
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
		if not B2_RoomXY.room_reference:
			B2_RoomXY.room_reference = self

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
	if load_debug_save_data: B2_Playerdata.preload_skip_tutorial_save_data()
	return player
	
func _setup_camera( player ):
	if B2_CManager.camera:
		b2_camera = B2_CManager.camera
		return
		
	b2_camera = B2_Camera_Hoopz.new()
	if not player == null:
		b2_camera.follow_mouse = true
		b2_camera.follow_player( player as B2_Player_FreeRoam )
	add_child( b2_camera, true )
	b2_camera.set_camera_bound( camera_bound_to_map )
	b2_camera.name = "room_created_camera"
	b2_camera.is_lost = false
	B2_CManager.camera = b2_camera
	print_rich( "[color=orange]Room %s: created player at DEBUG location %s.[/color]" % [name, debug_player_scene_pos] )

## return true if the room is dark
func get_room_darkness() -> bool:
	return is_this_room_dark

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
		push_warning( "Room name '%s' is not standard. fix this." % room_name )
		return ""
	
# Get the room name. return "unknow" if the parent is not B2_ROOMS
func get_room_name() -> String:
	return name
