extends Resource
class_name B2_Script_Combat

@export_multiline var notes			:= \
"Use '\\' to add comments to the code.
MOVE 		| actor_node | destination_node 	- Move actor to a specific node
MOVE_POS 	| actor_node | destination_vector 	- Move actor to a specific position
LOOK		| actor_node | direction			- Actor looks to a specific direction
LOOK_AT		| actor_node | destination_node 	- Look torward another node
WAIT		| time								- Wait for some time. Value of 0.0 waits for all previous actions to finish.
START_BATTLE - No idea.
"
@export_multiline var combat_script := ""
var source : Object ## Who called this Cinema Script?
