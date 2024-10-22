extends Node2D

const O_ENTITY_INDICATOR_GOSSIP = preload("res://barkley2/scenes/Objects/_interactiveActor/_pedestrians/o_entity_indicatorGossip.tscn")

func _ready() -> void:
	create_gossip( 'Loading "CombatModule" ...', 2.5 )
	await get_tree().create_timer(4.0).timeout
	create_gossip( 'Checking license for module...', 2.5 )
	await get_tree().create_timer(4.0).timeout
	create_gossip( 'License expired. Falling back to default behaviour.', 2.5 )
	await get_tree().create_timer(3.0).timeout
	
	get_parent().explode()
	
func create_gossip( text : String, linger_time : float ):
	var gossip = O_ENTITY_INDICATOR_GOSSIP.instantiate()
	gossip.text = text
	gossip.timer = linger_time
	gossip.position.y -= 64.0
	add_child( gossip )
