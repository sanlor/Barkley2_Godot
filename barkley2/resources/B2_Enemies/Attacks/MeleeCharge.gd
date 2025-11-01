extends Resource
class_name B2_MeleeAttack
## Enemy does a little animation and charges at the target.

@export var number_of_jumps 	:= 2
@export var charge_time 		:= 0.5
@export var charge_force		:= 50000.0
@export var charge_damage		:= 10

signal action_finished

func action( source : B2_EnemyCombatActor, target : Vector2 ) -> void:
	#await source.cinema_jump( number_of_jumps ) ## TODO Fix this
	source.cinema_charge_at( target, charge_force )
	await source.finished_charge_action
	
	action_finished.emit()
