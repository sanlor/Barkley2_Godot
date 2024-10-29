extends B2_Script
class_name B2_Script_Mask

## Mask for replacing text from the B2_Script.
@export var target_string 		:= "" ## What string are you looking for in the B2_Script. Should start with $ (Ex.: $boobs)
@export var desired_string 		:= "" ## What should we replace it with?
@export var replace_all			:= false ## WIP

func setup( target : String, desired : String, all := false ):
	target_string 		= target
	desired_string 		= desired
	replace_all 		= all
