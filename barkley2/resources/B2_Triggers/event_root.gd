@icon("uid://cv6copl74211t")
extends Area2D
class_name B2_Event_Root

@export_category("Interaction Event")
@export var is_active					:= true
#@export var player_can_pause			:= true
@export var cutscene_script 			: B2_Script
@export var cutscene_hook				: B2_Actor ## Allows for a new cutscene to load after this one finishes.

func event_trigger( _body : Node2D ) -> void:
	push_error( "Event trigger not set for %s." % self.name )
