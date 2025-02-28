extends B2_ScriptActions
class_name B2_SA_Look
## Actor looks to a specific position.

enum DIR{
	SOUTH,
	SOUTHWEST,
	WEST,
	NORTHWEST,
	NORTH,
	NORTHEAST,
	EAST,
	SOUTHEAST,
	}

@export var actor 					: NodePath
@export var direction 				:= DIR.SOUTH
@export var use_position_instead 	:= false
@export var position_is_relative	:= false ## That is, relative to the source node. If left unticket, the position is a global position.
@export var position				:= Vector2.ZERO
