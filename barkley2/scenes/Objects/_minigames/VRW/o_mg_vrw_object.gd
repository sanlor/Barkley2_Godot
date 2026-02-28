extends CharacterBody2D
class_name B2_Minigame_VRW_Object

const ROOM_WIDTH := 1440.0

## Does some harmless cloning. Check o_mg_vrw_object draw function.a
static func dew_it( parent : Node2D ) -> Array[Node2D]:
	var array : Array[Node2D]
	# PARENT: Draw the object in three different places
	var dx 	:= parent.position.x; 
	var dy 	:= parent.position.y;
	#clone_object( dx, dy, parent )
	dx = parent.position.x + (ROOM_WIDTH - 384); dy = parent.position.y;
	array.append( clone_object( dx, dy, parent ) )
	dx = parent.position.x - (ROOM_WIDTH - 384); dy = parent.position.y;
	array.append( clone_object( dx, dy, parent ) )
	return array
	
static func clone_object( x : float, y : float, parent : Node2D  ) -> Node2D:
	var clone := parent.duplicate()
	clone.position = Vector2( x, y )
	parent.add_sibling( clone, true )
	return clone
	
