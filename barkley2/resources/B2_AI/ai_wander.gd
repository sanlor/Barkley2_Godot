extends B2_AI
class_name B2_AI_Wander

var wander_target_pos := Vector2.ZERO 

var home_point 				:= Vector2.ZERO
@export var home_radius 	:= 64.0

## Player Detection
var detection_radius := 80.0

signal emote( type : String )
