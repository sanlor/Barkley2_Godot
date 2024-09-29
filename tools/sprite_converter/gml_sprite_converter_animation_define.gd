extends B2_TOOL_GML_SPRITE_CONVERTER_ROOT
class_name B2_TOOL_GML_SPRITE_CONVERTER_ANIMATION_DEFINE

## scr_entity_animation_define(animationName, sprite, startImage, numberOfFrames, animationSpeed)
#scr_entity_animation_define("stomach_start", sHoopzPrisonStomach, 0, 6, ANIMATION_DEFAULT_SPEED);

#scr_entity_animation_new(argument0);
#scr_entity_animation_setSpriteIndex(argument0, argument1);
#scr_entity_animation_setRange(argument0, argument2, argument3);
#scr_entity_animation_setSpeed(argument0, argument4);

@export var animationName 	: String
@export var sprite 			: String
@export var startImage 		: int
@export var numberOfFrames 	: int
@export var animationSpeed 	:= 5
