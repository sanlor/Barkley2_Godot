extends B2_CombatScriptActions
class_name B2_CSA_Frame

## Move the camera to a position or a node

@export_enum("torward_node", "torward_position") 
var look_target 						:= "torward_node"

@export_node_path("Node2D") var node 	: Array[NodePath]
@export var position 					: Vector2

@export_enum("CAMERA_FAST", "CAMERA_SLOW", "CAMERA_NORMAL") 
var speed								:= "CAMERA_NORMAL"
