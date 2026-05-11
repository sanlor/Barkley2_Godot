## Controls how enemies are spawn on the map
@tool
@icon("uid://c8ef176trmf7s")
extends Node2D
class_name B2_Enemy_Spawner

@export_category("Direct import data")
@export_file() var enemy_spawner_data := "res://barkley2/resources/B2_Enemy_Spawner/spawn_point_location.json"
@export_tool_button("Import now!") var import_data : Callable = _import

func _import() -> void:
	pass
