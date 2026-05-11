@tool
extends Node2D
class_name B2_Enemy_Spawner_Point

const FN_SMALL = preload("uid://c5asr1c5g1w6h")

@export_category("Spawn Data")
@export var spawn_hue	:= 0.0
@export var build 		:= "default"
@export var resource 	:= 1.0
@export var uuid		:= ""
@export var x			:= 0.0
@export var y			:= 0.0
@export var objectName	:= "o_enemy_catfish_small"
@export var level		:= 1.0

@export_category("Update Visualization")
@export_tool_button("Do it!") var _aaaaa : Callable = _update_visualization

func load_from_dict( dict : Dictionary ) -> void:
	spawn_hue	= dict.get("hue")
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
	dict["hue"] 			= spawn_hue
	dict["build"] 			= build
	dict["resource"] 		= resource
	dict["uuid"] 			= uuid
	dict["x"] 				= x
	dict["y"] 				= y
	dict["objectName"] 		= objectName
	dict["level"] 			= level
	return dict

func _ready() -> void:
	_update_visualization()

func _update_visualization() -> void:
	for i in get_children():
		if is_instance_valid(i):
			i.queue_free()
	## TODO
	add_child( B2_CManager.get_cached_scene( objectName ).instantiate() )
	queue_redraw()
	
func _draw() -> void:
	draw_string( FN_SMALL, Vector2( 0, 8 ), "Spawn Point", HORIZONTAL_ALIGNMENT_LEFT )
	draw_set_transform( Vector2.ZERO, 0.0, Vector2(1.0,0.25) )
	draw_circle( Vector2.ZERO, 16.0, Color.HOT_PINK, false )
	
