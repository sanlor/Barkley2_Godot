extends B2_FSM
class_name B2_FSM_Change_AI
## Used to chage the parent actor's AI

@export var new_ai : B2_AI

func enter() -> void:
	super()
	my_actor.actor_ai = new_ai
	#push_warning("%s: Change AI" % my_actor.name)
