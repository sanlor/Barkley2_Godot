extends Resource
class_name B2_WeaponAttack
## Base class for all Weapon's regular ass attacks

signal action_finished

func action( _source : Vector2, _weapon : B2_Weapon, _target : Vector2 ) -> void:
	push_warning( "Missing action" )
	action_finished.emit()
