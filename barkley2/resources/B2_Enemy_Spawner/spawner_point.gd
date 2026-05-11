extends Node2D
class_name B2_Enemy_Spawner_Point

@

@export_category("Spawn Data")
@export var spawn_hue	:= 0.0
@export var build 		:= "default"
@export var resource 	:= 1.0
@export var uuid		:= ""
@export var x			:= 194.0
@export var y			:= 632.0
@export var objectName	:= "o_enemy_cGremlin_small"
@export var level		:= 1.0

func load_from_dict( dict : Dictionary ) -> void:
	spawn_hue	= dict.get("spawn_hue")
	build 		= dict.get("build")
	resource 	= dict.get("resource")
	uuid		= dict.get("uuid")
	x			= dict.get("x")
	y			= dict.get("y")
	objectName	= dict.get("objectName")
	level		= dict.get("level")
	_update_visualization()

func save_to_dict() -> Dictionary:
	var dict := Dictionary()
	dict["spawn_hue"] 		= spawn_hue
	dict["build"] 			= build
	dict["resource"] 		= resource
	dict["uuid"] 			= uuid
	dict["x"] 				= x
	dict["y"] 				= y
	dict["objectName"] 		= objectName
	dict["level"] 			= level
	return dict

func _update_visualization() -> void:
	pass
	
