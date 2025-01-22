extends B2_CombatScriptActions
class_name B2_CSA_Move_Actor

## Move the camera to a position or a node

@export_enum("torward_node", "torward_position") 
var look_target 						:= "torward_node"

@export_node_path("Node2D") var node 		: NodePath 			## Which node to focus on.
@export var use_node_array					:= false 			## use an array of nodes to focus on
@export_node_path("Node2D") var node_array 	: Array[NodePath] 	## move torwarde these nodes in sequence

@export var position 						: Vector2 			## Move to a specific position
@export var is_relative						:= false 			## Position is relative to this node.

@export_enum("CAMERA_FAST", "CAMERA_SLOW", "CAMERA_NORMAL") 	## Camera movement speed
var speed								:= "CAMERA_NORMAL"

#func _init() -> void:
	#if look_target == "torward_node":
		#if use_node_array:
			#for n in node_array:
				#assert( not n.is_empty() )
		#else:
			#assert( not node.is_empty() )
	#else:
		#assert( position != Vector2.ZERO )
