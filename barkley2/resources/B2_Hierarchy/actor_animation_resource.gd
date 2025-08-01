extends Resource
class_name B2_Actor_Animations
## Class that holds info ablut movement for the Combat actor.
## TODO Should I add anything else to this?

@export var ANIMATION_STAND 						:= "default"
@export var ANIMATION_SOUTH 						:= ""
@export var ANIMATION_SOUTHEAST 					:= ""
@export var ANIMATION_SOUTHWEST 					:= ""
@export var ANIMATION_WEST 							:= ""
@export var ANIMATION_NORTH 						:= ""
@export var ANIMATION_NORTHEAST 					:= ""
@export var ANIMATION_NORTHWEST 					:= ""
@export var ANIMATION_EAST 							:= ""
@export var ANIMATION_STAND_SPRITE_INDEX 			:= [1, 1, 0, 0, 0, 0, 0, 1]
@export var ANIMATION_IDLE 							: Array[String] = []
#@export var CHARGE_UP								:= "CHARGE_UP"
#@export var CHARGE_DOWN								:= "CHARGE_DOWN"

func setup_walk_anim() -> void: ## TODO
	pass
	
func setup_stand_anim( _id_array : Array ) -> void:
	assert( _id_array.size() <= 8 )
	ANIMATION_STAND_SPRITE_INDEX = _id_array
