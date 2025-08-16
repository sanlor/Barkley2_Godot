extends B2_Event_Root
class_name B2_Event_Step_Trigger

@export var col_shape : CollisionShape2D

func _enter_tree() -> void:
	assert( is_instance_valid(col_shape), "Forgot to select the collision on node %s, buddy." % name )
	col_shape.debug_color = Color("b6775c6b")
	body_entered.connect( _pre_event_trigger )

func _pre_event_trigger(_body : Node2D) -> void:
	if _body is B2_PlayerCombatActor:
		event_trigger( _body )

func event_trigger( _node ):
	if is_instance_valid(cutscene_script):
		B2_CManager.play_cutscene( cutscene_script, self, [] )
		await B2_CManager.event_ended
		await get_tree().process_frame
		if cutscene_hook:
			B2_CManager.play_cutscene( cutscene_hook.cutscene_script, self, cutscene_hook.cutscene_script_mask )
