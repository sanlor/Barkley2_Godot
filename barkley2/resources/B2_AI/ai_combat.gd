extends B2_AI
class_name B2_AI_Combat

var is_disabled := false

## AI Action
func combat_action( _player_character : B2_CombatActor, _enemy_list : Array[B2_EnemyCombatActor], _combat_manager : B2_CombatManager ) -> bool:
	push_warning("Invalid AI action")
	return false

func combat_cancel( _action : bool ) -> void:
	is_disabled = _action
