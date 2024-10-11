@tool
extends B2_ProxEventTrigger

@onready var timer: Timer = $Timer

@export var cinema : B2_CinemaSpot

const O_ENTITY_INDICATOR_GOSSIP = preload("res://barkley2/scenes/Objects/_interactiveActor/_pedestrians/o_entity_indicatorGossip.tscn")

var activated := false

func _ready() -> void:
	get_parent().is_interactive = false
	_on_timer_timeout()

func event_action( node ) -> void:
	if activated: # run only once
		return 
	if node is B2_Player:
		B2_Playerdata.Quest( "tutorialZaneOverHere", 1 );
		activated = true
		# Move zane torward the door
		get_parent().cinema_moveto( cinema, "MOVE_FAST" )
		# wait for the walk cycle to end
		await get_parent().destination_reached
		# peace out
		get_parent().queue_free()
		
# Apply gossip box
func _on_timer_timeout() -> void:
	if activated: # run only once
		return 
	var gossip = O_ENTITY_INDICATOR_GOSSIP.instantiate()
	gossip.text = "Over here!"
	add_child(gossip)
	gossip.global_position = global_position + Vector2( 0,-65 )
	
	
