#extends B2_CombatScript
extends Resource
class_name B2_CombatScriptActions

## Actions used by the Combat script
## Not all fields should be set, since certain actions ignore certain stuffs.

@export_subgroup("Misc")
@export var wait_for_action_to_finish := false
