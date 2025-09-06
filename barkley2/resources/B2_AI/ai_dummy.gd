extends B2_AI
class_name B2_AI_Dummy
## Does nothing.

## AI Action
func combat_action( _player_character : B2_CombatActor, _enemy_list : Array[B2_EnemyCombatActor] ) -> bool:
	return false
