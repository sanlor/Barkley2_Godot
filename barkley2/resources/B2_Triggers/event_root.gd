extends Area2D
class_name B2_Event_Root

@export_category("Interaction Event")
#@export var player_can_pause			:= true
@export var cutscene_script 			: B2_Script

func event_trigger( _body : Node2D ) -> void:
	push_error( "Event trigger not set for %s." % self.name )
