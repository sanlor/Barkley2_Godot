extends B2_ScriptActions
class_name B2_SA_Look_At

@export_enum("torward_node", "direction") var look_target
@export_node_path("Node2D") var node 		: Array[NodePath]
@export var direction 						: Vector2
