## Controls how enemies are spawn on the map
@tool
@icon("uid://c8ef176trmf7s")
extends Node2D
class_name B2_Enemy_Spawner

const ENEMY_SPAWNER_DATA 		:= "res://barkley2/resources/B2_Enemy_Spawner/spawn_point_location.json"
const SPAWNER_POINT 			= preload("uid://cfcctssodib1c")
const ENEMY_SCENE_LIST 			: Dictionary[String,PackedScene] = {
	"o_enemy_drone_egg" 		: preload("uid://ca5m2ojpqka31"),
	"o_enemy_darkRat" 			: preload("uid://bw704hnw70nik"),
	"o_enemy_catfish_small" 	: preload("uid://dl0ylc1ocrp5l"),
	"o_enemy_cGremlin_small"	: null,
	"o_enemy_ruinedDrone"		: null,
	"o_enemy_alienMenace_egg"	: null,
	"o_woodBarrel"				: preload("uid://bon7jbw3v5c2p"),
	"o_mtnpassJar"				: null,
	"o_bustaBulb"				: null,
}

@export_category("Direct import data")
@export_tool_button("Import now!") var import_data : Callable = _import_to_map

## Can't exist during gameplay.
func _ready() -> void:
	if not Engine.is_editor_hint():
		queue_free()

static func load_json() -> Dictionary:
	var json_file := FileAccess.get_file_as_string( ENEMY_SPAWNER_DATA )
	var _spawn_data = JSON.parse_string( json_file )
	if _spawn_data:
		return _spawn_data
	else:
		return {}

static func import( my_room : String ) -> Array:
	var spawn_data := load_json()
	if not spawn_data:
		push_error("Issue loading the json file")
		return []
	
	var my_room_data = spawn_data.get( my_room )

	
	var spawn_point_array := []
	
	for element : String in my_room_data:
		if element.contains("_palette"): # Ignore palettes
			continue
		elif my_room_data[element]["uuid"].contains("_palette"): # Ignore palettes
			breakpoint
			continue
		else:
			var pos := Vector2( my_room_data[element]["x"], my_room_data[element]["y"] )
			var point := SPAWNER_POINT.instantiate()
			point.load_from_dict( my_room_data[element] )
			point.global_position = pos
			point.name = "spawnpoint_" + str( my_room_data[element]["uuid"] )
			#add_sibling( point, true)
			#point.owner = get_parent()
			spawn_point_array.append( point )
	
	return spawn_point_array

func _import_to_map() -> void:
	### Cleanup
	for i in get_parent().get_children():
		if is_instance_valid(i):
			if i.name.begins_with("spawnpoint_"):
				i.queue_free()
				
	## Make spawns to the map.
	for i in import( get_parent().name ):
		add_sibling( i, true)
		i.owner = get_parent()
