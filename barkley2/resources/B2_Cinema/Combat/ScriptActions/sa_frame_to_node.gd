extends B2_ScriptActions
class_name B2_SA_FrameToNode

## Move the camera to a position or a node
@export_node_path("Node2D") var node 		: NodePath 			## Which node to focus on.
@export var use_node_array					:= false 			## use an array of nodes to focus on
@export_node_path("Node2D") var node_array 	: Array[NodePath] 	## move torwarde these nodes in sequence
@export var is_relative						:= false 			## Position is relative to this node.

@export_enum("CAMERA_FAST", "CAMERA_SLOW", "CAMERA_NORMAL") 	## Camera movement speed
var speed								:= "CAMERA_NORMAL"
