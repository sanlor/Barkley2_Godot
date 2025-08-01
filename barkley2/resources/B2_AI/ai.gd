extends Node
class_name B2_AI

var actor : B2_CombatActor
var is_active := false

@warning_ignore("unused_parameter")
func step() -> void:
	pass

## AI Action
@warning_ignore("unused_parameter")
func action() -> void:
	push_warning("Invalid AI action")
