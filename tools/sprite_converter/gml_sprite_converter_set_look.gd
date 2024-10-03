extends B2_TOOL_GML_SPRITE_CONVERTER_ROOT
class_name B2_TOOL_GML_SPRITE_CONVERTER_SET_LOOK

## scr_entity_set_look(sprite, N, NE, E, SE, S, SW, W, NW);
## Is set clockwise, anything null defaults to first frame

@export var sprite 		: String
@export var subNE 		: int
@export var subSE 		: int
@export var subSW 		: int
@export var subNW 		: int
@export var subN 		: int
@export var subE 		: int
@export var subS 		: int
@export var subW 		: int
