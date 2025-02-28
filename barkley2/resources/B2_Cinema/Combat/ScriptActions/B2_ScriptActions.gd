#extends B2_CombatScript
extends Resource
class_name B2_ScriptActions

## Actions used by the Combat script
## Not all fields should be set, since certain actions ignore certain stuffs.

@export_subgroup("Misc")
@export var source_is_the_player		:= false
@export var target_is_the_player		:= false
@export var wait_for_action_to_finish 	:= false
