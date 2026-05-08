## Actor moves torward the target and changes state after reaching a certain distance.
@icon("uid://dadcamgwa58ra")
extends B2_FSM
class_name B2_FSM_Go_Near_Player

@export var target_distance_from_player := 64.0 ## Minimum distance from the player.
@export var reached_player_state 		: B2_FSM
	
func _ready() -> void:
	assert( reached_player_state, "'reached_player_state' is not valid." )
	
func _target_reached() -> void:
	my_ai.state_transition( self, reached_player_state )
