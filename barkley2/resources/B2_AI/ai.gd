extends Node
class_name B2_AI

const AI_COMBAT = preload("res://barkley2/resources/B2_AI/ai_combat.gd")
var actor : B2_EnemyCombatActor
var is_active := false

@warning_ignore("unused_parameter")
func step() -> void:
	pass

## AI Action
@warning_ignore("unused_parameter")
func action() -> void:
	push_warning("Invalid AI action")
