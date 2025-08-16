@tool
extends B2_ProxEventTrigger

@onready var timer: Timer = $Timer

const O_ENTITY_INDICATOR_GOSSIP = preload("res://barkley2/scenes/Objects/_interactiveActor/_pedestrians/o_entity_indicatorGossip.tscn")

func _ready() -> void:
	_on_timer_timeout()

func event_trigger( node ) -> void:
	if node is B2_PlayerCombatActor:
		queue_free()
		
# Apply gossip box
func _on_timer_timeout() -> void:
	var gossip = O_ENTITY_INDICATOR_GOSSIP.instantiate()
	gossip.text = "Press spacebar to roll."
	add_child(gossip)
	gossip.global_position = global_position + Vector2( 0,-65 )
