extends B2_CombatScriptActions
class_name B2_CSA_Look_At

@export_enum("torward_node", "direction") var look_target
@export_node_path("Node2D") var node 		: Array[NodePath]
@export var direction 						: Vector2
