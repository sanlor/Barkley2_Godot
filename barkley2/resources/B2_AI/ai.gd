extends Node
class_name B2_AI

signal ranged_attack_trigger( 	active : bool ) ## Actor is  firing ranged weapon
signal melee_attack_trigger( 	active : bool ) ## Actor is attacking at melee range
signal aim_trigger( 			active : bool ) ## Actor is aiming its weapon / getting ready to fire
signal roll_trigger( 			active : bool ) ## Actor is rolling torward a direction
signal charge_trigger( 			active : bool ) ## Actor is Charging at a direction

var actor : B2_CombatActor
var is_active := false

@warning_ignore("unused_parameter")
func step() -> void:
	pass

## AI Action
@warning_ignore("unused_parameter")
func action() -> void:
	push_warning("Invalid AI action")
