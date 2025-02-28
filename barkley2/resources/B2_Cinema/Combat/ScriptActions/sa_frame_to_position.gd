extends B2_ScriptActions
class_name B2_SA_FrameToPosition

## Move the camera to a position or a node
@export_node_path("Node2D") var node 		: NodePath 			## Which node to focus on.
@export var position 						: Vector2 			## Move to a specific position
@export var is_relative						:= false 			## Position is relative to this node.

@export_enum("CAMERA_FAST", "CAMERA_SLOW", "CAMERA_NORMAL") 	## Camera movement speed
var speed								:= "CAMERA_NORMAL"
