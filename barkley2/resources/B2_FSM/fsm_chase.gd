@icon("uid://dadcamgwa58ra")
extends B2_FSM
class_name B2_FSM_Chase

@export var enemy_attack_radius 	:= 32.0
@export var attack_state : B2_FSM
@export var enemy_de_aggro_radius 	:= 48.0
@export var deaggro_state : B2_FSM

func _ready() -> void:
	assert(attack_state)
	assert(deaggro_state)

func _target_reached() -> void:
	my_ai.state_transition( self, attack_state )
	
func _target_far() -> void:
	my_ai.state_transition( self, deaggro_state )

func step() -> void:
	if _has_enemy_actor():
		var ActorNav := my_actor.ActorNav as NavigationAgent2D
		var target := B2_CManager.o_hoopz
		
		ActorNav.set_target_position( target.global_position )
		my_actor.curr_input = my_actor.global_position.direction_to( ActorNav.get_next_path_position() )
		
		if my_actor.global_position.distance_to( enemy_actor.global_position ) > enemy_de_aggro_radius:
			_target_far()
		if my_actor.global_position.distance_to( enemy_actor.global_position ) < enemy_attack_radius:
			_target_reached()
