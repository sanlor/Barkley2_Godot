## Controls how enemies are spawn on the map
@tool
@icon("uid://c8ef176trmf7s")
extends Node2D
class_name B2_Enemy_Spawner

const SPAWNER_POINT = preload("uid://cfcctssodib1c")
const ENEMY_SCENE_LIST : Dictionary[String,PackedScene] = {
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
@export_file() var enemy_spawner_data := "res://barkley2/resources/B2_Enemy_Spawner/spawn_point_location.json"
@export_tool_button("Import now!") var import_data : Callable = _import

var spawn_data : Dictionary
var my_room_data : Dictionary

func _load_json() -> bool:
	var json_file := FileAccess.get_file_as_string( enemy_spawner_data )
	spawn_data = JSON.parse_string( json_file )
	return not spawn_data.is_empty()
		

func _import() -> void:
	var my_room := get_parent().name
	
	if not _load_json():
		push_error("Issue loading the json file")
		return
	
	if not spawn_data.has( my_room ):
		push_error("Room '%s' not found inside the spawn data." % my_room)
		return
	
	my_room_data = spawn_data.get( my_room )
	#print( my_room_data )
	
	## Cleanup
	for i in get_children():
		if is_instance_valid(i):
			i.queue_free()
	
	for element : String in my_room_data:
		if element.begins_with("_"): # Ignore palletes
			continue
		var pos := Vector2( my_room_data[element]["x"], my_room_data[element]["y"] )
		var point := SPAWNER_POINT.instantiate()
		point.load_from_dict( my_room_data[element] )
		point.global_position = pos
		point.name = "spawn_" + str( my_room_data[element]["uuid"] )
		add_child( point, true)
		point.owner = get_parent()
		
