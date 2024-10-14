extends B2_Event_Root
class_name B2_Event_Step_Trigger

@export var col_shape : CollisionShape2D

func _enter_tree() -> void:
	assert( is_instance_valid(col_shape), "Forgot to select the collision on node %s, buddy." % name )
	col_shape.debug_color = Color("b557df6b")
	body_entered.connect( _pre_event_trigger )

func _pre_event_trigger(_body : Node2D) -> void:
	if _body is B2_Player:
		event_trigger( _body )
