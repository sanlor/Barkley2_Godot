extends B2_EnvironInteractive

@export var disable_door 		: B2_DOOR_PARENT
@export var disable_doorlight 	: B2_DoorLight

func _ready() -> void:
	## Code to check if the object should exist
	
	if evict_check():
		queue_free()
		return
	
	## If it exist, disable door and remove doorlight.
	if is_instance_valid(disable_doorlight):
		disable_doorlight.queue_free()
		
	if is_instance_valid(disable_door):
		disable_door.locked = true
		disable_door.draw_locked = false

#func pre_cutscene() -> void:
	#execute_event_user_1()

func execute_event_user_1() -> void:
	## Get random number
	B2_Playerdata.Quest("random", randi_range(0, 4) )


## Check for quest variable.
func evict_check() -> bool:
	return false
