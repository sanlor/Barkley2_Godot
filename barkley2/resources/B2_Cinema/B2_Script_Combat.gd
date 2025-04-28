extends Resource
class_name B2_Script_Combat

@export_multiline var notes			:= \
"Use '\\' to add comments to the code.
MOVE 		
MOVE_POS 	
LOOK		
LOOK_AT		
WAIT		
START_BATTLE
ACTIVATE_BLOCKER
DEACTIVATE_BLOCKER
MAKE_HUD
MAKE_MIN_HUD
FOLLOWFRAME
PLAYSET
"
@export_multiline var combat_script := ""
var source : Object ## Who called this Cinema Script?
