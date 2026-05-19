extends B2_EnemyCombatActor
class_name B2_Enemy_SewerBeast

var is_wading := false

const O_SPLASH:													= preload("uid://dgxwfaoi5p3x1")

@onready var ai_wading: 				B2_AI_Wading 			= $B2_AI_Wading
@onready var ai_sewer_beast_young: 		B2_AI_SewerBeast_Young 	= $B2_AI_SewerBeast_Young


func _ready() -> void:
	super()
	ready.connect( _to_wade_or_not_to_wade ) # <- this is the question.
	
func _to_wade_or_not_to_wade() -> void:
	if not check_for_water():
		actor_ai = ai_wading
		curr_STATE = STATE.WADING
		ActorAnim.play( "water" )
		my_shadow.hide()
	else:
		actor_ai = ai_sewer_beast_young
		my_shadow.show()
		curr_STATE = B2_CombatActor.STATE.NORMAL
	

func _ai_ranged_attack( enabled : bool ) -> void:
	if enabled:
		if curr_STATE == STATE.NORMAL:
			_begin_attack()
			
	
func _ai_jump( enabled : bool ) -> void:
	if enabled:
		if curr_STATE == STATE.NORMAL:
			cinema_jump( curr_input * 200.0 ) ## Debug direction
