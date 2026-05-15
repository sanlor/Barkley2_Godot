@icon("uid://hn1pbdh6bawm")
extends B2_FSM
class_name B2_FSM_Jump_Toward_Player

@export var landed_state : B2_FSM

func enter() -> void:
	super()
	var target := enemy_actor.global_position
	var time := randf_range(0.25,0.75)
	var offset := my_actor.ActorAnim.offset.y
	var t := create_tween()
	t.tween_callback( _pre_jump )
	t.parallel().tween_property( my_actor.ActorAnim, 	"offset:y", 		offset - 32, 	time / 2 ).set_ease(	Tween.EASE_IN)
	t.parallel().tween_property( my_actor, 				"global_position", 	target, 		time ).set_ease(		Tween.EASE_OUT_IN)
	t.tween_property( my_actor.ActorAnim, 				"offset:y", 		offset, 		time / 2 ).set_ease(	Tween.EASE_OUT)
	t.tween_callback( _pos_jump )
	t.tween_interval( 0.25 )
	t.tween_callback( my_ai.state_transition.bind(self, landed_state) )
	
func _pre_jump() -> void:
	pass
	
func _pos_jump() -> void:
	pass
