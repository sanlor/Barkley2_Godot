@tool
@icon("uid://bxos3ytbl836h")
extends Node2D
class_name B2_Enemy_Spawner_Point
## B2_Enemy_Spawner_Point spawns enemies, duh!

const FN_SMALL = preload("uid://c5asr1c5g1w6h")

@export_category("Spawn Data")
@export var spawn_hue	:= 0.0
@export var build 		:= "default"
@export var resource 	:= 1.0
@export var uuid		:= ""
@export var x			:= 0.0
@export var y			:= 0.0
@export var objectName	:= ""
@export var level		:= 1.0

@export_category("Update Visualization")
@export_tool_button("Do it!") var _aaaaa : Callable = _update_visualization

func load_from_dict( dict : Dictionary ) -> void:
	if not dict.is_empty():
		spawn_hue	= dict.get("hue")
		build 		= dict.get("build")
		resource 	= dict.get("resources")
		uuid		= dict.get("uuid")
		x			= dict.get("x")
		y			= dict.get("y")
		objectName	= dict.get("objectName")
		level		= dict.get("level")
		_update_visualization()
	else:
		push_error("Spawner invalid.")
		queue_free()

func save_to_dict() -> Dictionary:
	var dict := Dictionary()
	dict["hue"] 			= spawn_hue
	dict["build"] 			= build
	dict["resources"] 		= resource
	dict["uuid"] 			= uuid
	dict["x"] 				= x
	dict["y"] 				= y
	dict["objectName"] 		= objectName
	dict["level"] 			= level
	return dict

func _ready() -> void:
	if Engine.is_editor_hint():
		_update_visualization()
	else:
		_spawn_enemy()

func _get_enemy_scene() -> PackedScene:
	if objectName.is_empty():
		push_error( "objectName not set for spawnpoint %s. Quitting now." % name )
		return null
	else:
		return B2_CManager.get_cached_scene( objectName )
	

## Actually spawns the enemy
func _spawn_enemy() -> void:
	var enemy_scene : PackedScene = _get_enemy_scene()
	if enemy_scene:
		var enemy_actor : B2_CombatActor = B2_CManager.get_cached_scene( objectName ).instantiate()
		## TODO Add enemy status and build.
		enemy_actor.global_position = global_position
		enemy_actor.name = "%s_%s" % [objectName, uuid]
		add_sibling.call_deferred( enemy_actor, true )
	else:
		push_error( "objectName %s not valid for spawnpoint %s. Quitting now." % [objectName, name] )
	## My job is done. See ya!
	queue_free()

## Spawn a enemy sample, for debug purposes.
func _update_visualization() -> void:
	var enemy_scene : PackedScene = _get_enemy_scene()
	## Cleanup
	for i in get_children():
		if is_instance_valid(i):
			i.queue_free()
	if enemy_scene:
		## TODO Add enemy status and build.
		add_child( enemy_scene.instantiate() )
	else:
		push_error( "objectName %s not valid for spawnpoint %s. Quitting now." % [objectName, name] )
	queue_redraw()
	
func _draw() -> void:
	draw_string( FN_SMALL, Vector2( 0, 8 ), str(uuid), HORIZONTAL_ALIGNMENT_LEFT )
	draw_set_transform( Vector2.ZERO, 0.0, Vector2(1.0,0.25) )
	draw_circle( Vector2.ZERO, 16.0, Color.HOT_PINK, false )
	
func _on_timer_timeout() -> void:
	pass # Replace with function body.
