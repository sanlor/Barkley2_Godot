@icon("uid://dadcamgwa58ra")
extends B2_FSM
class_name B2_FSM_Chase

@export var enemy_attack_radius 	:= 32.0
@export var enemy_de_aggro_radius 	:= 48.0


func _init() -> void:
	if my_STATE == B2_AI.STATE.NONE:
		my_STATE = B2_AI.STATE.CHASE

func step() -> void:
	if enemy_actor:
		if my_actor.global_position.distance_to( enemy_actor.global_position ) > enemy_de_aggro_radius:
			my_ai.state_transition( my_STATE, B2_AI.STATE.IDLE )
			return
		if my_actor.global_position.distance_to( enemy_actor.global_position ) < enemy_attack_radius:
			my_ai.state_transition( my_STATE, B2_AI.STATE.READY_ATTACK )
			return
		
		var ActorNav := my_actor.ActorNav as NavigationAgent2D
		var target := B2_CManager.o_hoopz
		
		ActorNav.set_target_position( target.global_position )
		my_actor.curr_input = my_actor.global_position.direction_to( ActorNav.get_next_path_position() )
